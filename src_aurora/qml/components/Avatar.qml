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

 Item {
     id: avatarRoot
     width: Theme.itemSizeMedium - Theme.paddingMedium
     height: width

     property string title: ""
     property string icon: ""
     property bool showInitials: !icon || icon.toString() === ""

     property var colors: [
         ["#FF6B6B", "#FF8E53"], // Красный-оранжевый
         ["#4ECDC4", "#556270"], // Бирюзовый-серый
         ["#834d9b", "#d04ed6"], // Фиолетовый
         ["#009FFF", "#ec2F4B"], // Синий-красный
         ["#654ea3", "#eaafc8"], // Пурпурный-розовый
         ["#00c6ff", "#0072ff"], // Голубой-синий
         ["#f46b45", "#eea849"], // Оранжевый-желтый
         ["#7F00FF", "#E100FF"], // Фиолетовый-розовый
         ["#11998e", "#38ef7d"], // Зеленый
         ["#FF416C", "#FF4B2B"]  // Розовый-красный
     ]

     Rectangle {
         id: container
         anchors.fill: parent
         radius: width / 2

         gradient: Gradient {
             GradientStop {
                position: 0.0
                color: {
                    if (title === "" || colors.length === 0) {
                        return Theme.primaryColor;
                    }

                    var idx = title.charCodeAt(0) % colors.length;
                    if (colors[idx] && colors[idx][0]) {
                        return colors[idx][0];
                    }
                    return Theme.primaryColor;
                }
             }
             GradientStop {
                position: 1.0
                 color: {
                    if (title === "" || colors.length === 0) {
                        return Theme.secondaryColor;
                    }

                    var idx = title.charCodeAt(0) % colors.length;
                    if (colors[idx] && colors[idx][1]) {
                        return colors[idx][1];
                    }
                    return Theme.secondaryColor;
                }
             }
         }

         Loader {
             anchors.fill: parent
             active: !avatarRoot.showInitials
             sourceComponent: Image {
                 source: icon
                 fillMode: Image.PreserveAspectCrop
                 layer.enabled: true
                 layer.effect: OpacityMask {
                     maskSource: Rectangle {
                         width: container.width
                         height: container.width
                         radius: container.radius
                     }
                 }
             }
         }

         Label {
             id: noIconLabel
             anchors.centerIn: parent
             text: Utils.getInitials(title)
             font.pixelSize: Theme.fontSizeLarge
             font.bold: true
             color: Theme.primaryColor
             visible: showInitials
         }
     }
 }
