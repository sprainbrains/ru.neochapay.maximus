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

    property var chatId
    property var lastEventTime

    BusyIndicator {
        id: spinner
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        enabled: true
    }

    ChatMessagesModel{
        id: chatMessagesModel
        Component.onCompleted: {
            chatMessagesModel.requsetChat(chatId, lastEventTime)
        }

        onChatLoaded: spinner.enabled = false
        onRowsInserted: chatMessagesList.scrollToBottom()
    }

    SilicaListView {
        id: chatMessagesList
        width: parent.width
        height: parent.height - header.height - sendMessageRow.height
        anchors.top:  header.bottom
        model: chatMessagesModel
        clip: true

        Component.onCompleted: scrollToBottom()

        delegate: ListItem {
            id: listItem
            contentHeight:  chatMessageAuthor.height + chatMessageText.height + Theme.paddingSmall * 4

            Image{
                id: chatMessageImage
                width: Theme.itemSizeMedium - Theme.paddingSmall * 2
                height: Theme.itemSizeMedium - Theme.paddingSmall * 2
                source: messageIcon
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }

                anchors{
                    left: parent.left
                    leftMargin: Theme.paddingSmall
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
            }

            Rectangle {
                id: mask
                width: chatMessageImage.width
                height: chatMessageImage.width
                radius: chatMessageImage.width/2
                visible: chatMessageImage.source == ""
                anchors.centerIn: chatMessageImage
                color: "white"
            }

            Label {
                 id: chatMessageAuthor
                 text: messageName

                 anchors{
                     left: chatMessageImage.right
                     leftMargin: Theme.paddingSmall
                     top: parent.top
                     topMargin: Theme.paddingSmall
                 }
             }

            Label {
                id: chatMessageText
                text: messageText
                font.pixelSize: Theme.fontSizeSmall
                anchors{
                    left: chatMessageImage.right
                    leftMargin: Theme.paddingSmall
                    top: chatMessageAuthor.bottom
                    topMargin: Theme.paddingSmall
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
                 serverConnection.sendMessage(chatId, 0, messageTextField.text)
                 messageTextField.text = ""
             }
        }
    }

}
