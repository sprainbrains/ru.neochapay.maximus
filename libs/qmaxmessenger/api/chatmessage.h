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
#ifndef CHATMESSAGE_H
#define CHATMESSAGE_H

#include <QJsonObject>
#include <QObject>
#include <QDateTime>

#include "contact.h"

class ChatMessage : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Contact* sender READ sender NOTIFY chatMessageChanged FINAL)
    Q_PROPERTY(qint64 messageID READ messageID NOTIFY chatMessageChanged FINAL)
    Q_PROPERTY(QDateTime messageTime READ messageTime NOTIFY chatMessageChanged FINAL)
    Q_PROPERTY(QString text READ text NOTIFY chatMessageChanged FINAL)
    Q_PROPERTY(QList<ChatMessageElement> elements READ elements NOTIFY chatMessageChanged FINAL)
    Q_PROPERTY(MessageType messageType READ messageType NOTIFY chatMessageChanged FINAL)

    // TODO:
    // type
    // attaches

public:
    struct ChatMessageElement
    {
        QString type;
        int from = 0;
        int length;
    };

    enum MessageType{
        UnknowMessageType,
        TextMessage,
        ControlMessage,
    };
    Q_ENUMS(MessageType)

    explicit ChatMessage(QObject *parent = nullptr);
    explicit ChatMessage(QJsonObject chatMessageObject, QObject *parent = nullptr);
    ChatMessage(const ChatMessage& other, QObject *parent = nullptr);
    ChatMessage& operator=(const ChatMessage& other);

    Contact* sender() const;
    qint64 messageID() const;
    QDateTime messageTime() const;
    QString text() const;
    QList<ChatMessageElement> elements() const;
    MessageType messageType() const;

signals:
    void chatMessageChanged();

private:
    Contact* m_sender;
    qint64 m_messageID;
    QDateTime m_messageTime;
    QString m_text;
    QList<ChatMessageElement> m_elements;
    MessageType m_messageType;
};

#endif // CHATMESSAGE_H
