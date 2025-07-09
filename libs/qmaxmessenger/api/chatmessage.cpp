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

#include "chatmessage.h"
#include <QJsonArray>

ChatMessage::ChatMessage(QObject *parent)
    : QObject{parent}
{
}

ChatMessage::ChatMessage(QJsonObject chatMessageObject, QObject *parent)
    : QObject{parent}
    , m_messageType(UnknowMessageType)
{
    m_sender = new Contact(chatMessageObject["sender"].toInt());
    m_messageID = chatMessageObject["id"].toString().toDouble();
    m_text = chatMessageObject["text"].toString();
    m_messageTime = QDateTime::fromMSecsSinceEpoch(chatMessageObject["time"].toInt()*1000);

    QJsonArray elements = chatMessageObject["elements"].toArray();
    foreach (QJsonValue element, elements) {
        QJsonObject e = element.toObject();
        ChatMessageElement chatMessageElement;
        chatMessageElement.type = e["type"].toString();
        chatMessageElement.from = e["from"].toInt();
        chatMessageElement.length = e["length"].toInt();
        m_elements.push_back(chatMessageElement);
    }

    if(!m_text.isEmpty()) {
        m_messageType = TextMessage;
    }
//Attaches
    QJsonArray attaches = chatMessageObject["attaches"].toArray();
    foreach (QJsonValue attach, attaches) {
        if(attach["_type"].toString() == "CONTROL") {
            m_messageType = ControlMessage;
        }
    }
}

ChatMessage::ChatMessage(const ChatMessage &other, QObject *parent)
    : QObject{parent}
    , m_messageType(UnknowMessageType)
{
    m_sender = other.sender();
    m_messageID = other.messageID();
    m_text = other.text();
    m_messageTime = other.messageTime();
    m_elements = other.elements();
    m_messageType = other.messageType();
}

ChatMessage &ChatMessage::operator=(const ChatMessage &other)
{
    m_sender = other.sender();
    m_messageID = other.messageID();
    m_text = other.text();
    m_messageTime = other.messageTime();
    m_elements = other.elements();
    m_messageType = other.messageType();
    return *this;
}

Contact *ChatMessage::sender() const
{
    return m_sender;
}

qint64 ChatMessage::messageID() const
{
    return m_messageID;
}

QDateTime ChatMessage::messageTime() const
{
    return m_messageTime;
}

QString ChatMessage::text() const
{
    return m_text;
}

QList<ChatMessage::ChatMessageElement> ChatMessage::elements() const
{
    return m_elements;
}

ChatMessage::MessageType ChatMessage::messageType() const
{
    return m_messageType;
}
