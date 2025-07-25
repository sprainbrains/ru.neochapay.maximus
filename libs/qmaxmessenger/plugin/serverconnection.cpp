/*
 * Copyright (C) 2025 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "serverconnection.h"
#include <QVariant>
#include <QUuid>
#include <QJsonArray>

ServerConnection::ServerConnection(QObject *parent)
    : QObject(parent)
    , m_messQueue(MessagesQueue::instance())
    , m_settings(Settings::instance())
    , m_heartBeatTimer(new QTimer(this))
{
    QVariant deviceId = m_settings->value(QString("deviceId"));
    m_userId = m_settings->value(QString("userId"), "-1").toInt();

    if(deviceId.isNull()) {
        deviceId = QUuid::createUuid().toString();
        m_settings->setValue("deviceId", deviceId);
    }
    connect(m_messQueue, &MessagesQueue::readyToSend, this, &ServerConnection::init);
    connect(m_messQueue, &MessagesQueue::connectionClosed, m_heartBeatTimer, &QTimer::stop);
    connect(m_messQueue, &MessagesQueue::messageReceived, this, &ServerConnection::onMessageReceived);
    connect(m_messQueue, &MessagesQueue::connectionError, this, &ServerConnection::connectionError);

    connect(m_heartBeatTimer, &QTimer::timeout, this, &ServerConnection::sendHeartBeatMessage);
}

void ServerConnection::init()
{
    QJsonObject payload;
    payload["deviceId"] = m_settings->value(QString("deviceId")).toString();

    QJsonObject userAgent;
    userAgent.insert("appVersion", "25.6.11");
    userAgent.insert("deviceLocale", "ru");
    userAgent.insert("deviceName", "Chrome");
    userAgent.insert("deviceType", "WEB");
    userAgent.insert("headerUserAgent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36");
    userAgent.insert("locale", "ru");
    userAgent.insert("osVersion", "Linux");
    userAgent.insert("screen", "1080x1920 1.0x");
    userAgent.insert("timezone", "Europe/Moscow");
    payload.insert("userAgent", userAgent);

    m_messSeq = m_messQueue->sendMessage(6, payload);
    //m_heartBeatTimer->start(30000);
}

void ServerConnection::sendHeartBeatMessage()
{
    QJsonObject payload;
    payload["interactive"] = true;
    m_messQueue->sendMessage(1, payload);
}

void ServerConnection::onMessageReceived(RawApiMessage message)
{
    if(message.seq() == m_messSeq && !message.payload().isEmpty()) {
        qDebug() << "READY TO LOGIN";
        emit readyToLogin();
    }
    m_heartBeatTimer->start(30000);
}

void ServerConnection::sendPhone(QString phone)
{
    QJsonObject payload;
    payload["type"] = "START_AUTH";
    payload["language"] = "ru";
    payload["phone"] = phone;

    int seq = m_messQueue->sendMessage(17, payload);
    connect(m_messQueue, &MessagesQueue::messageReceived, [=](RawApiMessage message) {
        if(message.seq() == seq) {
            if(!message.payload()["token"].toString().isEmpty()) {
                emit tokenReady(message.payload()["token"].toString());
            }
        }
    });
}

void ServerConnection::sendCode(QString code)
{
    QJsonObject payload;
    payload["authTokenType"] = "CHECK_CODE";
    payload["token"] = m_settings->value(QString("token")).toString();
    payload["verifyCode"] = code;

    m_messQueue->sendMessage(18, payload);
}

void ServerConnection::requestDataSync()
{
    QJsonObject payload;
    payload["chatsCount"] = 40;
    payload["chatsSync"] = 0;
    payload["contactsSync"] = 0;
    payload["draftsSync"] = 0;
    payload["interactive"] = true;
    payload["presenceSync"] = 0;
    payload["token"] = m_settings->value(QString("authToken")).toString();
    m_messQueue->sendMessage(19, payload);
}

void ServerConnection::requestContactsByIDs(QList<int> idS)
{
    QJsonObject payload;
    QJsonArray contactIds;
    foreach (int id, idS) {
        contactIds << id;
    }
    payload["contactIds"] = contactIds;
    m_messQueue->sendMessage(32, payload);
}

void ServerConnection::requestChatById(int chatId, int from, int backward, int forward)
{
    QJsonObject payload;
    payload["chatId"] = chatId;
    payload["from"] = from;
    payload["backward"] = backward;
    payload["forward"] = forward;
    payload["getMessages"] = true;
    m_messQueue->sendMessage(49, payload);
}

void ServerConnection::refreshToken()
{
    QJsonObject payload;
    int seq = m_messQueue->sendMessage(158, payload);
    connect(m_messQueue, &MessagesQueue::messageReceived, [=](RawApiMessage message) {
        if(message.seq() == seq) {
            QJsonObject payload = message.payload();
            QString lifetimeToken = payload["token"].toString();
            int tokenLifeTime = payload["token_lifetime_ts"].toInt();
            int tokenRefresh = payload["token_refresh_ts"].toInt();

            m_settings->setValue("lifetimeToken", lifetimeToken);
            m_settings->setValue("tokenLifeTime", tokenLifeTime);
            m_settings->setValue("tokenRefresh", tokenRefresh);
        }
    });
}

void ServerConnection::sendMessage(Chat *chat, QString text)
{
    QJsonObject payload;
    payload["chatId"] = chat->chatId();
    payload["notify"] = true;
    QJsonObject message;
    message["text"] = text;
    message["cid"] = QDateTime::currentDateTime().toMSecsSinceEpoch();
    message["attaches"] = QJsonArray();
    message["elements"] = QJsonArray();
    payload["message"] = message;

    m_messQueue->sendMessage(64, payload);
}
