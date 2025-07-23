/*
 * Copyright (C) 2025 Sinyov Nikolay <nikolay.sinyov@gmail.com>
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
 import "../js/Utils.js" as Utils
 import "../js/emoji.js" as EmojiFunc

 ListItem {
     id: listItem
     width: parent.width
     contentHeight: Theme.itemSizeLarge

     property int unreadCount: 0
     property string title: ""
     property string chatDescription: ""
     property var lastMessageTime: ""
     property string chatIcon: ""
     property bool canSendMessage: true

     Avatar {
         id: avatar
         title: listItem.title
         icon: chatIcon
         anchors {
             left: parent.left
             leftMargin: Theme.horizontalPageMargin
             verticalCenter: parent.verticalCenter
         }
     }

     Column {
         id: contentColumn
         anchors {
             left: avatar.right
             leftMargin: Theme.paddingLarge
             right: parent.right
             rightMargin: Theme.horizontalPageMargin
             verticalCenter: parent.verticalCenter
         }
         spacing: Theme.paddingSmall / 2

         Row {
             width: parent.width

             Label {
                 id: chatName
                 width: parent.width - timeLabel.width
                 text: title
                 color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                 font.pixelSize: Theme.fontSizeMedium
                 truncationMode: TruncationMode.Fade
             }

             Label {
                 id: timeLabel
                 text: Utils.formatTime(lastMessageTime)
                 color: unreadCount > 0 ? Theme.highlightColor : Theme.secondaryColor
                 font.pixelSize: Theme.fontSizeExtraSmall
                 anchors.verticalCenter: chatName.verticalCenter
                 font.bold: unreadCount > 0
             }
         }

         Row {
             width: parent.width
             spacing: Theme.paddingSmall

             Image {
                 id: statusIcon
                 source: "image://theme/icon-s-installed"
                 width: Theme.fontSizeSmall
                 height: Theme.fontSizeSmall
                 visible: unreadCount === 0 && lastMessageTime !== ""
                 anchors.verticalCenter: parent.verticalCenter
             }

             Label {
                 id: messageLabel
                 width: parent.width
                        - (unreadBadge.visible ? unreadBadge.width + Theme.paddingSmall : 0)
                        - (statusIcon.visible ? statusIcon.width + Theme.paddingSmall : 0)
                 text: EmojiFunc.convertToOriginalHtml(chatDescription) || qsTr("No messages")
                 color: unreadCount > 0 ? Theme.primaryColor : Theme.secondaryColor
                 font.pixelSize: Theme.fontSizeSmall
                 truncationMode: TruncationMode.Fade
                 maximumLineCount: 1
                 font.bold: unreadCount > 0
             }

             Rectangle {
                 id: unreadBadge
                 width: Math.max(unreadCountLabel.implicitWidth + Theme.paddingSmall, height)
                 height: unreadCountLabel.implicitHeight + Theme.paddingSmall
                 radius: height / 2
                 color: Theme.highlightColor
                 anchors.verticalCenter: parent.verticalCenter
                 visible: unreadCount > 0

                 Label {
                     id: unreadCountLabel
                     anchors.centerIn: parent
                     text: unreadCount > 99 ? "99+" : unreadCount
                     font.pixelSize: Theme.fontSizeTiny
                     font.bold: true
                     color: Theme.primaryColor
                 }
             }
         }
     }

     Separator {
         width: parent.width
         anchors.bottom: parent.bottom
         color: Theme.primaryColor
         opacity: 0.1
     }
 }
