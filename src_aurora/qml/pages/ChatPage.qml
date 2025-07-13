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

    function extractTextWithEmojis(htmlString) {
        const textMatch = htmlString.match(/<p[^>]*>([\s\S]*?)<\/p>/i);
          if (!textMatch) return '';

          const pContent = textMatch[1];
          var result = '';

          // Process text nodes and img tags
          var lastIndex = 0;
          const imgRegex = /<img[^>]+src="([^"]+)"[^>]*>/gi;
          var imgMatch;

          while ((imgMatch = imgRegex.exec(pContent)) !== null) {
            // Add text before the image
            result += pContent.slice(lastIndex, imgMatch.index);
            lastIndex = imgRegex.lastIndex;

            // Process image
            const src = imgMatch[1];
            const emojiMatch = src.match(/([0-9a-f]+)\.svg$/i);
            if (emojiMatch) {
                const codePoint = parseInt(emojiMatch[1], 16);
                      // Alternative to fromCodePoint for older environments
                      if (codePoint <= 0xFFFF) {
                        result += String.fromCharCode(codePoint);
                      } else {
                        // For code points beyond BMP (Basic Multilingual Plane)
                        const offset = codePoint - 0x10000;
                        result += String.fromCharCode(
                          0xD800 + (offset >> 10),
                          0xDC00 + (offset & 0x3FF)
                        );
                      }
                    }
          }

          // Add remaining text after last image
          result += pContent.slice(lastIndex);

          // Clean up HTML entities and tags if needed
          return result.replace(/&[^;]+;/g, '').replace(/<[^>]+>/g, '');
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

    EmojiModel {
            id: emojiModel
            iconsPath: '../emojiSvgs/'
            iconsType: '.svg'
        }

    Rectangle {
            id: body
            width: 400
            height: 420
            radius: 10
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            EmojiPicker {
                id: emojiPicker
                model: emojiModel
                editor: messageTextField
                anchors.fill: parent
            }
        }

    Item{
        id: sendMessageRow
        width: parent.width
        height: Theme.iconSizeExtraLarge
        anchors.bottom: chatListPage.bottom

        TextEdit{
            id: messageTextField
            focus: true
            width: parent.width - sendButton.width - Theme.paddingSmall*2
            height: parent.height - Theme.paddingSmall*2
            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.RichText
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
                console.log("text a ", extractTextWithEmojis(messageTextField.text));
                serverConnection.sendMessage(currentChat, extractTextWithEmojis(messageTextField.text))
                messageTextField.text = ""
            }
        }
    }

}
