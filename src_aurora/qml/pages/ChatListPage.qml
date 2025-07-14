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

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Logout")
                onClicked: userSession.logout()
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader {
                id: header
                objectName: "pageHeader"
                title: qsTr("Chats")
            }

            SilicaListView {
                width: parent.width
                height: contentHeight
                model: chatListModel
                delegate: ListItem {
                    id: listItem
                    width: parent.width - Theme.paddingSmall*2
                    contentHeight: Theme.itemSizeMedium
                    clip: true

                    Image{
                        id: chatIconImage
                        width: parent.height - Theme.paddingSmall * 2
                        height: parent.height - Theme.paddingSmall * 2
                        source: chatIcon
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
                        width: chatIconImage.width
                        height: chatIconImage.width
                        radius: chatIconImage.width/2
                        visible: chatIconImage.source == ""
                        anchors.centerIn: chatIconImage
                        color: "white"
                    }

                    Label {
                        id: chatName
                        text: title

                        anchors{
                            left: chatIconImage.right
                            leftMargin: Theme.paddingSmall
                            top: parent.top
                            topMargin: Theme.paddingSmall
                        }
                    }

                    Label {
                        id: chatDescriptionLabel
                        text: chatDescription
                        font.pixelSize: Theme.fontSizeSmall
                        width: listItem.width - chatIconImage.width - Theme.paddingSmall*3
                        anchors{
                            left: chatIconImage.right
                            leftMargin: Theme.paddingSmall
                            top: chatName.bottom
                            topMargin: Theme.paddingSmall
                        }
                    }

                    onClicked: pageStack.push(Qt.resolvedUrl("ChatPage.qml"),
                                              {
                                                  chatTitle: title,
                                                  currentChat: chatListModel.get(index)
                                              })
                }
            }
        }
    }
}
