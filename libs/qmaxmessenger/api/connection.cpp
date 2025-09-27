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

#include "connection.h"

Connection::Connection(QObject *parent)
    : QObject(parent)
    , m_connected(false)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &Connection::onConnected);
    connect(&m_webSocket, &QWebSocket::errorOccurred, this, &Connection::onError);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &Connection::onDisconected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &Connection::onTextMessageReceived);

    connectToSocket();
}

int Connection::sendMessage(RawApiMessage message)
{
    QString jsonString = message.toJsonString();
    int seq = m_webSocket.sendTextMessage(jsonString);
    qDebug().noquote() << ">>>>>>>" << jsonString;
    return seq;
}

void Connection::onConnected()
{
    if(!m_connected) {
        m_connected = true;
        emit connectedChanged();
    }
}


void Connection::onDisconected()
{
    if(m_connected) {
        m_connected = false;
        emit connectedChanged();
    }
    connectToSocket();
}

void Connection::onTextMessageReceived(QString messageString)
{
    RawApiMessage message(messageString);
    qDebug().noquote() << "<<<<<<<" << messageString;
    emit messageReceived(message);
}

void Connection::onError(QAbstractSocket::SocketError error)
{
    Q_UNUSED(error);

    qDebug() << Q_FUNC_INFO << m_webSocket.errorString();
    emit errorReceived(m_webSocket.errorString());
}

void Connection::connectToSocket()
{
    QNetworkRequest request;
    request.setUrl(QUrl("wss://ws-api.oneme.ru/websocket"));
    request.setRawHeader("Origin", "https://web.max.ru");

    m_webSocket.ignoreSslErrors();
    m_webSocket.open(request);
}

bool Connection::connected() const
{
    return m_connected;
}
