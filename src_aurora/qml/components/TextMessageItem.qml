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

import "../js/emoji.js" as EmojiFunc
import "../js/Utils.js" as Utils


Item {
    id: listItem
    height: (isMyMessage ?  Theme.paddingLarge : chatMessageAuthor.height)
                          + messageBackground.height
                          + Theme.paddingLarge * 4

    width: messagesListView.width
    property bool isMyMessage: messageSenderId == userSession.userId
    property var message

    property bool hasReply: replyToMessageId !== 0
    property bool isPhotoMessage: messageType === ChatMessage.PhotoMessage

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
        width: (isPhotoMessage ? postImage.width  : chatMessageText.width)
                        + Theme.paddingLarge * 2

        height: (isPhotoMessage ? postImage.height + Theme.paddingLarge * 3 : 0)
                        + chatMessageText.height
                        + (hasReply ? replyContainer.height : 0)
                        + (reactionsCounter.visible? reactionsCounter.height : 0)
                        + timeLabel.height
                        + Theme.paddingLarge * 2

        radius: Theme.paddingLarge / 2

        anchors {
            left: isMyMessage ? undefined : chatMessageImage.right
            leftMargin: Theme.paddingLarge
            right: isMyMessage ? parent.right : undefined
            rightMargin: isMyMessage ? Theme.paddingLarge : undefined
            top: chatMessageAuthor.bottom
            topMargin: Theme.paddingLarge
        }
        Rectangle {
            id: replyContainer
            visible: hasReply
            width: parent.width - 2 * Theme.paddingLarge
            height: visible ? (replySenderNameLabel.height
                                + (postReplyImage.visible ? postReplyImage.height + Theme.paddingSmall : 0)
                                + (replyMessageTextLabel.visible ? replyMessageTextLabel.height : 0)) : 0
            color: "transparent"
            anchors {
                top: parent.top
                topMargin: Theme.paddingMedium
                left: parent.left
                leftMargin: Theme.paddingLarge
                right: parent.right
                rightMargin: Theme.paddingLarge
            }

            Rectangle {
                id: replyIndicator
                width: 3
                height: parent.height
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
            }

            Column {
                id: replyContentColumn
                x: replyIndicator.width + Theme.paddingMedium
                width: parent.width - x
                spacing: Theme.paddingSmall / 2

                // reply name
                Label {
                    id: replySenderNameLabel
                    text: replySenderName
                    font.bold: true
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                    truncationMode: TruncationMode.Fade
                    width: parent.width
                }

                // reply image
                Image {
                    id: postReplyImage
                    source: replyMessageType == ChatMessage.PhotoMessage ? replyMessageExtendedData : ""
                    width: parent.width
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    visible: replyMessageType == ChatMessage.PhotoMessage && replyMessageExtendedData
                    horizontalAlignment: Image.AlignLeft
                    verticalAlignment: Image.AlignTop

               	    layer.enabled: true
               	    layer.effect: OpacityMask {
                  		maskSource: Rectangle {
                  		    width: postReplyImage.width
                  		    height: postReplyImage.height
                  		    radius: 4
                  		}
               	    }
                }

                // reply text
                Label {
                    id: replyMessageTextLabel
                    text: EmojiFunc.convertToOriginalHtml(Utils.formatMessagePreview(Utils.formatLinks(messageText)))
                    visible: text.length > 0
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    width: parent.width
                    wrapMode: Text.Wrap
                }
            }
        }
        Image {
            id: postImage
            source: messageType == ChatMessage.PhotoMessage ? messageExtendedData : ""
            width: listItem.width * 0.6
            fillMode: Image.PreserveAspectFit
            visible: isPhotoMessage
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
                top: replyContainer.visible ? replyContainer.bottom : parent.top
                topMargin: Theme.paddingLarge
            }
        }

        Label {
            id: chatMessageText
            z:20
            text: EmojiFunc.convertToOriginalHtml(Utils.formatLinks(messageText))
            visible: text.length > 0
            width: listItem.width * 0.6
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
                top: isPhotoMessage ? postImage.bottom : (replyContainer.visible ? replyContainer.bottom : parent.top)
                topMargin: Theme.paddingLarge
            }
            onLinkActivated: Qt.openUrlExternally(link)

            textFormat: Text.RichText
            linkColor: Theme.rgba(Theme.secondaryHighlightColor, 0.7)
        }

        Label {
            id: timeLabel
            text: Utils.formatMessageDate(messageTime)
            font.pixelSize: Theme.fontSizeExtraSmall
            color: isMyMessage ? Theme.secondaryColor : Theme.secondaryColor
            anchors {
                bottom: parent.bottom
                bottomMargin: Theme.paddingSmall
                right: parent.right
                rightMargin: Theme.paddingMedium
            }
        }

        Item {
            id: reactionsCounter
            visible: reactionsCount > 0 && reactions.length > 0
            height: reactionRow.height
            width: reactionRow.width

            Row {
                id: reactionRow
                spacing: Theme.paddingSmall / 2
                layoutDirection: Qt.LeftToRight

                Repeater {
                    model: reactions

                    delegate: Rectangle {
                        id: reactionDelegate
                        height: reactionLabel.height + Theme.paddingSmall
                        width: reactionLabel.width + Theme.paddingMedium
                        radius: height / 2
                        color: Theme.rgba(Theme.secondaryColor, 0.1)

                        Label {
                            id: reactionLabel
                            text: EmojiFunc.convertToOriginalHtml(modelData.reaction) + " " + modelData.count
                            font.pixelSize: Theme.fontSizeExtraSmall
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
            anchors {
                top: chatMessageText.bottom
                topMargin: Theme.paddingLarge
                right: timeLabel.left
                rightMargin: Theme.paddingSmall
            }
        }
    }
}
