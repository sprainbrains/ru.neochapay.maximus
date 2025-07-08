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

import QtQuick
import QtQuick.Controls

import Nemo
import Nemo.Controls

import ru.neochapay.maximus 1.0

Page {
    id: root

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Chat")
    }

    property var chatId
    property var lastEventTime

    Spinner {
        id: spinner
        width: (Theme.itemHeightExtraSmall + Theme.itemSpacingMedium)*2
        height: (Theme.itemHeightExtraSmall + Theme.itemSpacingMedium)*2
        anchors.centerIn: parent
        clip: true
        enabled: true
    }

    ChatMessagesModel{
        id: chatMessagesModel
        Component.onCompleted: {
            chatMessagesModel.requsetChat(chatId, lastEventTime)
        }

        onChatLoaded: spinner.enabled = false
    }

    Column{
        id: mainColumn
        anchors.fill: parent

        ListView{
            id: messagesListView
            width: parent.width
            height: parent.height - Theme.itemHeightLarge
            model: chatMessagesModel

            delegate: ListViewItemWithActions {
                id: item
                label: messageName
                description: messageText
                icon: messageIcon
                width: parent.width
                height: Theme.itemHeightLarge
                showNext: false
                clip: true
            }

            onCountChanged: {
                messagesListView.messagesListView = count - 1
            }
        }

        Row{
            width: parent.width
            height: Theme.itemHeightLarge

            TextField{
                id: textMessage
                height: parent.height
                width: parent.width - parent.height
            }

            NemoIcon{
                width: height
                height: parent.height
                source: "image://theme/paper-plane"

                MouseArea{
                    anchors.fill: parent
                    onClicked: serverConnection.sendMessage(chatId, 0, textMessage.text)
                }
            }
        }
    }
}
