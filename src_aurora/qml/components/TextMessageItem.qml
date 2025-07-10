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

Item {
    id: listItem
    height: isMyMessage ? messageBackground.height + Theme.paddingLarge * 2 : chatMessageAuthor.height + messageBackground.height + Theme.paddingLarge * 4
    width: messagesListView.width
    property bool isMyMessage: messageSenderId == userSession.userId

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
        visible: !isMyMessage

        anchors{
            left: parent.left
            leftMargin: Theme.paddingLarge
            top: parent.top
            topMargin: Theme.paddingLarge
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
        visible: !isMyMessage
        font.pixelSize: Theme.fontSizeSmall

        anchors{
            left: chatMessageImage.right
            leftMargin: Theme.paddingLarge
            top: parent.top
            topMargin: Theme.paddingLarge
        }
    }

    Rectangle{
        id: messageBackground
        color: Theme.highlightBackgroundColor
        width: messageType == ChatMessage.PhotoMessage
               ? postImage.width + Theme.paddingLarge * 2
               : chatMessageText.width + Theme.paddingLarge * 2

        height: messageType == ChatMessage.PhotoMessage
                    ? chatMessageText.height + postImage.height + Theme.paddingLarge * 3
                    : chatMessageText.height + Theme.paddingLarge * 2

        radius: Theme.paddingLarge / 2

        anchors{
            left: isMyMessage ? undefined : chatMessageImage.right
            leftMargin: Theme.paddingLarge
            right: isMyMessage ? parent.right : undefined
            rightMargin: isMyMessage ? Theme.paddingLarge : undefined
            top: chatMessageAuthor.bottom
            topMargin: Theme.paddingLarge
        }

        Image {
            id: postImage
            source: messageType == ChatMessage.PhotoMessage ? messageExtendedData : ""
            width: listItem.width * 0.6
            fillMode: Image.PreserveAspectFit
            visible: messageType == ChatMessage.PhotoMessage
            anchors{
                left: parent.left
                leftMargin: Theme.paddingLarge
                top: parent.top
                topMargin: Theme.paddingLarge
            }
        }

        Label {
            id: chatMessageText
            text: messageText
            visible: chatMessageText.text.length > 0
            width: listItem.width * 0.6
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            anchors{
                left: parent.left
                leftMargin: Theme.paddingLarge
                top: messageType == ChatMessage.PhotoMessage ? postImage.bottom : parent.top
                topMargin: Theme.paddingLarge
            }
        }
    }
}
