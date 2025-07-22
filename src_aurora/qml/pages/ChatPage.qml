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
import EmojiModel 1.0
import "../js/emoji.js" as EmojiFunc

Page {
    id: chatListPage
    objectName: "chatsListPage"
    allowedOrientations: Orientation.All
    property alias chatTitle: header.title

    PageHeader {
        id: header
        objectName: "pageHeader"
        title: qsTr("Chat")
    }

    property var currentChat
    property bool showPopup: false

    // Background dimmer
    Rectangle {
        visible: showPopup
        anchors.fill: parent
        z: 10
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            onClicked:{
                showPopup = false
            }
        }
    }

    Rectangle {
        visible: showPopup
        width: parent.width
        height: parent.height / 3
        z: 11
        radius: Theme.paddingMedium
        anchors{
            bottom: sendMessageRow.top
            left: parent.left
            leftMargin: Theme.paddingSmall
            right: parent.right
            rightMargin: Theme.paddingSmall
        }

        color: Theme.rgba(Theme.highlightBackgroundColor, 0.9)
        border.color: Theme.highlightColor
        border.width: 1

        EmojiPicker {
            id: emojiPicker
            model: emojiModel
            editor: messageTextField
            anchors.fill: parent
            anchors.margins: Theme.paddingSmall
        }
    }

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

    EmojiModel {
        id: emojiModel
        iconsPath: '../emojiSvgs/'
        iconsType: '.svg'
    }

    SilicaListView {
        id: messagesListView
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: sendMessageRow.top
        }
        model: chatMessagesModel
        clip: true

        footer: Item {
            width: parent.width
            height: Theme.paddingMedium
            // visible: (chatMessagesModel.messageSenderId === userSession.userId) &&
            visible: (chatMessagesModel.messageSenderId === userSession.userId) &&
                     (messagesListView.currentIndex === count - 1)
        }

        MouseArea {
            anchors.fill: parent
            z: -1  // Put behind delegates
            onClicked: messagesListView.forceActiveFocus()
        }
        property bool needToUpdate: true

        onCountChanged: {
            messagesListView.currentIndex = count - 1
        }

        delegate: Loader{
            z: 1
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

    Rectangle {
        id: sendMessageRow
        width: parent.width
        height: visible ? Theme.itemSizeLarge : 0
        anchors.bottom: parent.bottom
        visible: currentChat.type !== Chat.CHANNEL
        color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.rgba(Theme.primaryColor, 0.2)
        }

        TextEdit{
            id: messageTextField
            clip: true
            width: parent.width - sendButton.width - emojiButton.width - Theme.paddingSmall*4
            height: parent.height - Theme.paddingSmall*2
            verticalAlignment:  TextEdit.AlignVCenter
            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.RichText
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeMedium

            anchors{
                top: parent.top
                topMargin: Theme.paddingSmall
                left: emojiButton.right
                leftMargin: Theme.paddingSmall
            }

            Text {
                visible: (!messageTextField.text || messageTextField.text !== "") && !messageTextField.activeFocus
                text: qsTr("Type a message...")
                color: Theme.secondaryColor
                opacity: 0.5
                font: messageTextField.font
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
            }

            Keys.onReturnPressed: event.accepted = true
            Keys.onEnterPressed: event.accepted = true

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: Theme.paddingSmall
                }
                height: 2
                color: messageTextField.activeFocus ? Theme.highlightColor : Theme.primaryColor

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
        }

        Rectangle {
            id: emojiButton
            width: Theme.itemSizeSmall
            height: Theme.itemSizeSmall
            radius: width / 2
            color: showPopup ? Theme.highlightColor : "transparent"
            anchors{
                top: parent.top
                topMargin: Theme.paddingSmall
                left: parent.left
                leftMargin: Theme.paddingSmall
            }

            Image {
                id: emojiIcon
                source: "../icons/emoji-smiley.svg"
                width: parent.width * 0.6
                height: parent.height * 0.6
                anchors.centerIn: parent
                sourceSize.width: width
                sourceSize.height: height
            }

            ColorOverlay {
                anchors.fill: emojiIcon
                source: emojiIcon
                color: showPopup ? Theme.primaryColor : Theme.secondaryColor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    showPopup = !showPopup
                }
            }
        }

        Rectangle {
            id: sendButton
            width: Theme.itemSizeSmall
            height: Theme.itemSizeSmall
            radius: width / 2
            color: Theme.highlightColor
            anchors{
                top: parent.top
                topMargin: Theme.paddingSmall
                left: messageTextField.right
                leftMargin: Theme.paddingSmall
            }

            Image {
                source: "image://theme/icon-m-send"
                width: parent.width * 0.5
                height: parent.height * 0.5
                anchors.centerIn: parent
                sourceSize.width: width
                sourceSize.height: height
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    serverConnection.sendMessage(currentChat, EmojiFunc.extractTextWithEmojis(messageTextField.text))
                    messageTextField.text = ""
                }
            }
        }
    }
}
