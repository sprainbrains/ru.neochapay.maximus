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

 import "../components"

 Page {
     id: chatListPage
     allowedOrientations: Orientation.All

     SilicaListView {
         id: listView
         anchors.fill: parent
         model: chatListModel
         header: PageHeader {
             title: qsTr("Chats")
         }

         PullDownMenu {
             MenuItem {
                 text: qsTr("About")
                 onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
             }
             MenuItem {
                 text: qsTr("Logout")
                 onClicked: userSession.logout()
             }
         }

         delegate: ChatListItem {
             title: model.title
             chatDescription: model.chatDescription
             lastMessageTime: model.lastMessageTime
             chatIcon: model.chatIcon
             unreadCount: model.unreadCount !== undefined ? model.unreadCount : 0
             canSendMessage: model.canSendMessage

             onClicked: pageStack.push(Qt.resolvedUrl("ChatPage.qml"), {
                 chatTitle: model.title,
                 currentChat: chatListModel.get(model.index)
             })
         }

         VerticalScrollDecorator {}
     }
 }
