

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
    height: isMyMessage ? messageBackground.height + Theme.paddingLarge
                          * 2 : chatMessageAuthor.height
                          + messageBackground.height + Theme.paddingLarge * 4
    width: messagesListView.width
    property bool isMyMessage: messageSenderId == userSession.userId
    property var message


    function getCodePoint(chars) {
      if (chars.length === 1) {
        return chars.charCodeAt(0);
      }
      // Handle surrogate pairs
      const high = chars.charCodeAt(0);
      const low = chars.charCodeAt(1);
      return (high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000;
    }

    function convertToOriginalHtml(textWithEmojis) {
      // This regex matches emoji characters and captures their code points
      const emojiRegex = /([\uD800-\uDBFF][\uDC00-\uDFFF])|./g;

      var htmlParts = [];
      var match;

      while ((match = emojiRegex.exec(textWithEmojis)) !== null) {
        const charS = match[0];

        // Check if it's an emoji (surrogate pair or single char)
        if (charS.length === 2 || getCodePoint(charS) > 0xFFFF) {
          // Get the code point (works for both single and surrogate pairs)
          const codePoint = getCodePoint(charS).toString(16);

          // Create the img tag
          htmlParts.push('<img src="file:///usr/share/ru.neochapay.maximus/qml/emojiSvgs/' + codePoint +'.svg" width="40" height="40"/>');
          htmlParts.push(' ');
        } else {
          // Regular text character
          htmlParts.push(charS);
        }
      }

      const msg  = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
                     <html><head><meta name="qrichtext" content="1" /><style type="text/css">
                     p, li { white-space: pre-wrap; }
                     </style></head><body style=" font-family:\'ALS Hauss Variable\'; font-size:32px; font-weight:400; font-style:normal;">
                     <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">'+ htmlParts.join('') +'</p></body></html>';

      // Construct the full HTML structure

      console.log(msg)
      return msg
    }

    Image {
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

        anchors {
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
        radius: chatMessageImage.width / 2
        visible: chatMessageImage.source == ""
        anchors.centerIn: chatMessageImage
        color: "white"
    }

    Label {
        id: chatMessageAuthor
        text: messageName
        visible: !isMyMessage
        font.pixelSize: Theme.fontSizeSmall

        anchors {
            left: chatMessageImage.right
            leftMargin: Theme.paddingLarge
            top: parent.top
            topMargin: Theme.paddingLarge
        }
    }

    Rectangle {
        id: messageBackground
        color: isMyMessage ? Theme.rgba(Theme.highlightBackgroundColor,
                                        0.3) : Theme.rgba(
                                 Theme.secondaryHighlightColor, 0.2)
        width: messageType
               == ChatMessage.PhotoMessage ? postImage.width + Theme.paddingLarge
                                             * 2 : chatMessageText.width + Theme.paddingLarge * 2

        height: messageType
                == ChatMessage.PhotoMessage ? chatMessageText.height + reactionsCounter.height
                                              + postImage.height + Theme.paddingLarge
                                              * 3 : chatMessageText.height
                                              + reactionsCounter.height + Theme.paddingLarge * 3

        radius: Theme.paddingLarge / 2

        anchors {
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
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
                top: parent.top
                topMargin: Theme.paddingLarge
            }
        }

        Label {
            id: chatMessageText
            text: convertToOriginalHtml(formatLinks(messageText))
            visible: text.length > 0
            width: listItem.width * 0.6
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
                top: messageType == ChatMessage.PhotoMessage ? postImage.bottom : parent.top
                topMargin: Theme.paddingLarge
            }
            onLinkActivated: Qt.openUrlExternally(link)

            textFormat: Text.RichText
            linkColor: Theme.rgba(Theme.secondaryHighlightFromColor(), 0.7)

            function formatLinks(text) {
                if (!text)
                    return ""

                text = text.replace(/(https?:\/\/[^\s<]+|www\.[^\s<]+)/g,
                                    function (url) {
                                        var href = url.indexOf(
                                                    'http') === 0 ? url : 'http://' + url
                                        return '<a href="' + href + '">' + url + '</a>'
                                    })

                // Форматирование email-адресов
                text = text.replace(
                            /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/g,
                            '<a href="mailto:$1">$1</a>')
                // Форматирование телефонных номеров (международный формат)
                text = text.replace(/(\+?[\d\s\-\(\)]{7,}\d)/g,
                                    function (phone) {
                                        var cleanPhone = phone.replace(
                                                    /[^\d\+]/g, '')
                                        return '<a href="tel:' + cleanPhone + '">' + phone + '</a>'
                                    })
                return text
            }
        }

        Item {
            id: reactionsCounter
            visible: reactionsCount > 0

            anchors {
                top: chatMessageText.bottom
                topMargin: Theme.paddingLarge
                right: parent.right
                rightMargin: Theme.paddingLarge
            }
        }
    }
}
