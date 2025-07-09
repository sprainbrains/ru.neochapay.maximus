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

#ifndef CHATMESSAGESMODEL_H
#define CHATMESSAGESMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include <api/messagesqueue.h>
#include <api/chatmessage.h>

class ChatMessagesModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ChatMessagesModel(QObject *parent = nullptr);
    virtual ~ChatMessagesModel();
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role) const;
    QHash<int, QByteArray> roleNames() const { return m_hash; }

    Q_INVOKABLE void requsetChat(double chatId, qint64 lastEventTime);
signals:
    void chatLoaded();

private:
    void loadMessagesList(QJsonObject payload);
    void pushNewMessageToList(QJsonObject message);

    MessagesQueue* m_messQueue;
    QMetaObject::Connection m_connect;

    QHash<int, QByteArray> m_hash;
    QList<ChatMessage*> m_messages;
    double m_currentChatId;
};

#endif // CHATMESSAGESMODEL_H
