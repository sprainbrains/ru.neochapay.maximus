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

Page {
    id: chatListPage
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: chatListModel
        header: PageHeader {
            title: qsTr("Chats")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Logout")
                onClicked: userSession.logout()
            }
        }

        delegate: ListItem {
            id: listItem
            width: parent.width
            contentHeight: Theme.itemSizeLarge


            Rectangle {
                id: avatarContainer
                width: Theme.itemSizeMedium - Theme.paddingMedium
                height: width
                radius: width / 2
                color: Theme.rgba(Theme.secondaryHighlightColor, 0.2)
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }


                Loader {
                    anchors.fill: parent
                    active: chatIcon && chatIcon.toString() !== ""
                    sourceComponent: Image {
                        source: chatIcon
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: avatarContainer.width
                                height: avatarContainer.width
                                radius: avatarContainer.radius
                            }
                        }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: title.charAt(0).toUpperCase()
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    color: Theme.primaryColor
                    visible: !chatIcon || chatIcon.toString() === ""
                }
            }


            Column {
                id: contentColumn
                anchors {
                    left: avatarContainer.right
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
                        text: formatTime(lastMessageTime)
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors.verticalCenter: chatName.verticalCenter
                    }
                }


                Label {
                    id: messageLabel
                    width: parent.width
                    text: chatDescription || qsTr("No messages")
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    truncationMode: TruncationMode.Fade
                    maximumLineCount: 1
                }


                Label {
                    id: statusLabel
                    width: parent.width
                    text: canSendMessage ? qsTr("Can send messages") : qsTr("Can't send messages")
                    color: canSendMessage ? Theme.highlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeTiny
                    //visible: chatDescription && chatDescription.toString() !== ""
                    visible: false
                }
            }

            Separator {
                width: parent.width
                anchors.bottom: parent.bottom
                color: Theme.primaryColor
                opacity: 0.1
            }

            onClicked: pageStack.push(Qt.resolvedUrl("ChatPage.qml"), {
                chatTitle: title,
                currentChat: chatListModel.get(index)
            })
        }

        VerticalScrollDecorator {}
    }


    function formatTime(dateTimeString) {
            if (!dateTimeString) return "";


            var date = new Date(dateTimeString);
            if (isNaN(date.getTime())) return "";

            var now = new Date();
            var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            var yesterday = new Date(today);
            yesterday.setDate(yesterday.getDate() - 1);
            var lastWeek = new Date(today);
            lastWeek.setDate(lastWeek.getDate() - 7);


            if (date >= today) {
                return Qt.formatTime(date, "hh:mm");
            } else if (date >= yesterday) {
                return qsTr("yesterday");
            } else if (date >= lastWeek) {
                var days = [qsTr("Sun"), qsTr("Mon"), qsTr("Tue"), qsTr("Wed"),
                             qsTr("Thu"), qsTr("Fri"), qsTr("Sat")];
                return days[date.getDay()];
            } else {
                return Qt.formatDate(date, "dd.MM.yy");
            }
        }
}
