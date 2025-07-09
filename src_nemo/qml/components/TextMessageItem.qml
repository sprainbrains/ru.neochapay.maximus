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

Item {
    id: chatMessageItem
    width: messagesListView.width
    height: messageAuthor.height + messageTextLabel.height + Theme.itemSpacingSmall*4

    Image{
        id: chatMessageIcon
        width: Theme.itemHeightLarge
        height: Theme.itemHeightLarge
        source: messageIcon

        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingSmall
            left: parent.left
            leftMargin: Theme.itemSpacingSmall
        }
    }

    Label{
        id: messageAuthor
        text: messageName
        font.pixelSize: Theme.fontSizeMedium
        width: parent.width - Theme.itemSpacingSmall
        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingSmall
            left: chatMessageIcon.right
            leftMargin: Theme.itemSpacingSmall
        }
    }

    Label{
        id: messageTextLabel
        text: messageText
        font.pixelSize: Theme.fontSizeSmall
        width: parent.width - Theme.itemSpacingSmall
        anchors{
            top: messageAuthor.bottom
            topMargin: Theme.itemSpacingSmall
            left: chatMessageIcon.right
            leftMargin: Theme.itemSpacingSmall
        }
    }
}
