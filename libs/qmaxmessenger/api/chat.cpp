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

#include "chat.h"
#include <QJsonArray>

Chat::Chat(QObject *parent)
    : QObject{parent}
{
}

Chat::Chat(QJsonObject jsonObject, QObject *parent)
    : QObject{parent}
{
    m_owner = Contact(jsonObject["owner"].toInt());
    m_hasBots = jsonObject["hasBots"].toInt();
    m_joinTime = jsonObject["joinTime"].toInt();
    m_created = jsonObject["created"].toInt();
    m_messages.push_back(new ChatMessage(jsonObject["lastMessage"].toObject()));
    if(jsonObject["type"].toString() == "DIALOG") {
        m_type = Type::DIALOG;
    } else if(jsonObject["type"].toString() == "CHAT") {
        m_type = Type::CHAT;
        m_chatTitle = jsonObject["title"].toString();
        m_baseRawIconUrl = jsonObject["baseRawIconUrl"].toString();
    } else {
        m_type = Type::UNKNOWTYPE;
    }
    m_lastFireDelayedErrorTime = jsonObject["lastFireDelayedErrorTime"].toInt();
    m_lastDelayedUpdateTime = jsonObject["lastDelayedUpdateTime"].toInt();
    m_prevMessageId = jsonObject["prevMessageId"].toInt();
    m_modified = QDateTime::fromMSecsSinceEpoch(jsonObject["modified"].toInt() * 1000);
    m_lastEventTime = jsonObject["lastEventTime"].toDouble();

    if(jsonObject["status"].toString() == "ACTIVE") {
        m_status = Status::ACTIVE;
    } else if(jsonObject["status"].toString() == "INACTIVE") {
        m_status = Status::INACTIVE;
    } else {
        m_status = Status::UNKNOWSTATUS;
    }

    foreach (QJsonValue participant, jsonObject["participants"].toObject().keys()) {
        int contactId = participant.toString().toInt();
        if(contactId != m_owner.userId()) {
            Contact p = Contact(contactId);
            m_participants.push_back(p);
        }
    }
    m_chatId = jsonObject["id"].toDouble();
}


Chat::Chat(const Chat &other, QObject *parent)
    : QObject{parent}
{
    m_owner = other.owner();
    m_hasBots = other.hasBots();
    m_joinTime = other.joinTime();
    m_created = other.created();
    m_messages = other.messages();
    m_type = other.type();
    m_lastFireDelayedErrorTime = other.lastFireDelayedErrorTime();
    m_lastDelayedUpdateTime = other.lastDelayedUpdateTime();
    m_prevMessageId = other.prevMessageId();
    m_modified = other.modified();
    m_lastEventTime = other.lastEventTime();
    m_status = other.status();
    m_participants = other.participants();
    m_chatId = other.chatId();
}

Chat &Chat::operator=(const Chat &other)
{
    m_owner = other.owner();
    m_hasBots = other.hasBots();
    m_joinTime = other.joinTime();
    m_created = other.created();
    m_messages = other.messages();
    m_type = other.type();
    m_lastFireDelayedErrorTime = other.lastFireDelayedErrorTime();
    m_lastDelayedUpdateTime = other.lastDelayedUpdateTime();
    m_prevMessageId = other.prevMessageId();
    m_modified = other.modified();
    m_lastEventTime = other.lastEventTime();
    m_status = other.status();
    m_participants = other.participants();
    m_chatId = other.chatId();

    return *this;
}

qint64 Chat::chatId() const
{
    return m_chatId;
}

Chat::Status Chat::status() const
{
    return m_status;
}

qint64 Chat::lastEventTime() const
{
    return m_lastEventTime;
}

QDateTime Chat::modified() const
{
    return m_modified;
}

Chat::Type Chat::type() const
{
    return m_type;
}

QList<ChatMessage*> Chat::messages() const
{
    return m_messages;
}

Contact Chat::owner() const
{
    return m_owner;
}

bool Chat::hasBots() const
{
    return m_hasBots;
}

int Chat::created() const
{
    return m_created;
}

int Chat::lastFireDelayedErrorTime() const
{
    return m_lastFireDelayedErrorTime;
}

int Chat::lastDelayedUpdateTime() const
{
    return m_lastDelayedUpdateTime;
}

int Chat::prevMessageId() const
{
    return m_prevMessageId;
}

QList<Contact> Chat::participants() const
{
    return m_participants;
}

int Chat::joinTime() const
{
    return m_joinTime;
}

QString Chat::chatTitle() const
{
    return m_chatTitle;
}

QString Chat::baseRawIconUrl() const
{
    return m_baseRawIconUrl;
}
