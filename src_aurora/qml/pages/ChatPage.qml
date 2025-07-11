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
import QtGraphicalEffects 1.0

import ru.neochapay.maximus 1.0

Page {
    id: chatListPage
    objectName: "chatsListPage"
    allowedOrientations: Orientation.All

    PageHeader {
        id: header
        objectName: "pageHeader"
        title: qsTr("Chat")
    }

    property var currentChat
    property var lastEventTime

    BusyIndicator {
        id: spinner
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        enabled: true
    }

    ChatMessagesModel{
        id: chatMessagesModel
        chat: currentChat
        onChatLoaded: {
            spinner.enabled = false
            messagesListView.needToUpdate = true
        }
    }

    SilicaListView {
        id: messagesListView
        width: parent.width
        height: parent.height - header.height - sendMessageRow.height
        anchors.top:  header.bottom
        model: chatMessagesModel
        clip: true

        property bool needToUpdate: true

        onCountChanged: {
            messagesListView.currentIndex = count - 1
        }

        delegate: Loader{
            Component.onCompleted: {
                if(messageType == ChatMessage.TextMessage || messageType == ChatMessage.PhotoMessage) {
                    source = "../components/TextMessageItem.qml";
                } else if (messageType == ChatMessage.ControlMessage) {
                    source = "../components/ControlMessageItem.qml";
                } else {
                    source = "../components/UnsupportedMessage.qml"
                }
            }
        }
    }

    Item{
        id: sendMessageRow
        width: parent.width
        height: Theme.iconSizeExtraLarge
        anchors.bottom: chatListPage.bottom

        TextField{
            id: messageTextField
            width: parent.width - sendButton.width - Theme.paddingSmall*2
            height: parent.height - Theme.paddingSmall*2
            anchors{
                top: parent.top
                topMargin: Theme.paddingSmall
                left: parent.left
                leftMargin: Theme.paddingSmall
            }
        }

        IconButton {
            id: sendButton
            width: parent.height - Theme.paddingSmall * 2
            height: parent.height - Theme.paddingSmall * 2
            icon.source: "image://theme/icon-m-send?" + (pressed
                                                         ? Theme.highlightColor
                                                         : Theme.primaryColor)
            anchors{
                top: parent.top
                topMargin: Theme.paddingSmall
                left: messageTextField.right
                leftMargin: Theme.paddingSmall
            }
            onClicked: {
                serverConnection.sendMessage(currentChat, messageTextField.text)
                messageTextField.text = ""
            }
        }
    }

}
