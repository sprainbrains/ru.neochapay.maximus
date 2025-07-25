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

#ifndef SERVERCONNECTION_H
#define SERVERCONNECTION_H

#include <QObject>
#include <QTimer>
#include "api/chat.h"
#include "api/messagesqueue.h"
#include "api/settings.h"

class ServerConnection : public QObject
{
    Q_OBJECT
public:
    explicit ServerConnection(QObject *parent = nullptr);
    void init();
    int userId() const;

    Q_INVOKABLE void sendPhone(QString phone);
    Q_INVOKABLE void sendCode(QString code);
    Q_INVOKABLE void requestDataSync();
    Q_INVOKABLE void requestContactsByIDs(QList<int> idS);
    Q_INVOKABLE void requestChatById(int chatId, int from, int backward = 30, int forward = 0);
    Q_INVOKABLE void refreshToken();
    Q_INVOKABLE void sendMessage(Chat *chat, QString text);

signals:
    void readyToLogin();
    void userIdChanged();
    void tokenReady(QString token);
    void connectionError();

private slots:
    void sendHeartBeatMessage();
    void onMessageReceived(RawApiMessage message);

private:
    MessagesQueue* m_messQueue;
    Settings* m_settings;
    QTimer *m_heartBeatTimer;
    int m_messSeq;
    int m_userId;
};

#endif // SERVERCONNECTION_H
