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

import QtQuick 2.0
import Sailfish.Silica 1.0

import ru.neochapay.maximus 1.0

ApplicationWindow {
    initialPage: Qt.resolvedUrl("pages/MainPage.qml")
    cover: Qt.resolvedUrl("cover/DefaultCoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    ServerConnection{
        id: serverConnection
        onReadyToLogin: {
            if(userSession.authToken.length == 0) {
                pageStack.replace(Qt.resolvedUrl("pages/EntherPhonePage.qml"))
                userSession.coldStart()
            } else {
                requestDataSync();
            }
        }
        onTokenReady: {
            userSession.storeToken(token)
            pageStack.push(Qt.resolvedUrl("pages/EntherCodePage.qml"))
        }
        onConnectionError: {

        }
    }

    UserSession{
        id: userSession
        onUserIdChanged: {
            if(userSession.userId > 0) {
                pageStack.clear();
                pageStack.push(Qt.resolvedUrl("pages/ChatListPage.qml"))
            }
        }

        onUserLogin: serverConnection.requestDataSync();

        onUserLogout: {
            pageStack.clear();
            pageStack.replace(Qt.resolvedUrl("pages/EntherPhonePage.qml"))
            userSession.coldStart()
        }
    }

    ChatsListModel{
        id: chatListModel
    }
}
