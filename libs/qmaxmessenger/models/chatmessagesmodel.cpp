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

#include "chatmessagesmodel.h"

#include <QJsonArray>

ChatMessagesModel::ChatMessagesModel(QObject *parent)
    : QAbstractListModel{parent}
    , m_messQueue(MessagesQueue::instance())
{
    m_connect = connect(m_messQueue, &MessagesQueue::messageReceived, [=](RawApiMessage message) {
        if(message.opcode() == 49) {
            loadMessagesList(message.payload());
        }

        if(message.opcode() == 128) {
            if(message.payload()["chatId"].toDouble() == m_currentChatId) {
                pushNewMessageToList(message.payload()["message"].toObject());
            }
        }
    });

    m_hash.insert(Qt::UserRole, QByteArray("messageIcon"));
    m_hash.insert(Qt::UserRole+1, QByteArray("messageName"));
    m_hash.insert(Qt::UserRole+2, QByteArray("messageText"));
    m_hash.insert(Qt::UserRole+3, QByteArray("messageType"));
}

ChatMessagesModel::~ChatMessagesModel()
{
    QObject::disconnect(m_connect);
}

int ChatMessagesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_messages.count();
}

QVariant ChatMessagesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    if (index.row() >= m_messages.size()) {
        return QVariant();
    }

    ChatMessage* item = m_messages.at(index.row());
    if (role == Qt::UserRole) {
        return item->sender()->baseRawUrl();
    } else if (role == Qt::UserRole + 1) {
        return item->sender()->name();
    } else if (role == Qt::UserRole + 2) {
        if(item->text().isEmpty()) {
            return "#UNSUPPORTED MESSAGE#";
        } else {
            return item->text();
        }
    } else if (role == Qt::UserRole +3) {
        return item->messageType();
    }

    return QVariant();
}

void ChatMessagesModel::requsetChat(double chatId, qint64 lastEventTime)
{
    QJsonObject payload;
    payload["backward"] = 30;
    payload["forward"] = 0;
    payload["getMessages"] = true;
    payload["chatId"] = chatId;
    payload["from"] = lastEventTime;

    m_messQueue->sendMessage(49, payload);

    m_currentChatId = chatId;
}

void ChatMessagesModel::loadMessagesList(QJsonObject payload)
{
    QJsonArray messages = payload["messages"].toArray();
    if(messages.empty()) {
        return;
    }

    beginResetModel();
    m_messages.clear();
    foreach(QJsonValue mess, messages) {
        ChatMessage* m = new ChatMessage(mess.toObject());
        if(m == nullptr) {
            continue;
        }

        if(m->messageID() > 0) {
            m_messages.push_back(m);
        }
    }
    endResetModel();
    emit chatLoaded();
}

void ChatMessagesModel::pushNewMessageToList(QJsonObject message)
{
    ChatMessage* m = new ChatMessage(message);
    if(m == nullptr || m->messageID() < 1) {
        return;
    }
    beginInsertRows( QModelIndex(), 0, 0 );
    m_messages.push_back(m);
    endInsertRows();
}

