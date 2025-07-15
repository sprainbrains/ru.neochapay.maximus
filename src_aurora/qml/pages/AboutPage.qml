import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0


Page {
    id: aboutPage
    objectName: "aboutPage"

    property bool largeScreen: Screen.width > 540

    function banner(notificationType, message) {
        notification.close()
        notification.body = message
        notification.previewSummary = notificationType
        notification.publish()
    }
    Notification {
        id: notification
        itemCount: 1
    }

    SilicaFlickable {
        objectName: "flickable"
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height
        //        contentHeight: layout.height + Theme.paddingLarge
        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                objectName: "pageHeader"
            }
            SectionHeader {
                text: qsTr("About")
            }
            Label {
                text: qsTr("Maximus")
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source:  "/usr/share/icons/hicolor/128x128/apps/ru.neochapay.maximus.png"
              }
            Label {
                text: qsTr("Version") + " " + version
                //text: qsTr("Version") + " 0.0.7"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("Maximus not an official client for Max")
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                horizontalAlignment: Text.Center
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
            }

            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            SectionHeader {
                text: qsTr("Author")
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }

            Row {
                id: labelRow
                width: parent.width
                spacing: Theme.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter

                // Пустой элемент для центрирования
                Item {
                    width: (parent.width - interfaceLabel.width - copyrightLabel.width - parent.spacing) / 2
                    height: 1
                }

                Label {
                    id: interfaceLabel
                    text: qsTr("Main Developer")
                }

                Label {
                    id: copyrightLabel
                    text: qsTr("©Sergey Chuplygin(neochapay)")
                    color: Theme.highlightColor
                    anchors.verticalCenter: interfaceLabel.verticalCenter
                }
            }

            Row {
                id: labelRow2
                width: parent.width
                spacing: Theme.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter

                Item {
                    width: (parent.width - interfaceLabel2.width - copyrightLabel2.width - parent.spacing) / 2
                    height: 1
                }

                Label {
                    id: interfaceLabel2
                    text: qsTr("Minor interface edits")
                }

                Label {
                    id: copyrightLabel2
                    text: qsTr("© Leonid Yurasov ")
                    color: Theme.highlightColor
                    anchors.verticalCenter: interfaceLabel.verticalCenter
                }
            }


            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            SectionHeader {
                text: qsTr("Donate")
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("Your help allows us to make this project better.")
            }


            Button {
                text: "Boosty"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("https://boosty.to/neochapay/donate")
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            SectionHeader {
                text: qsTr("Source")
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("For suggestions, bugs and ideas visit ")
            }
            Button {
                text: "GitFlic"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("https://github.com/neochapay/ru.neochapay.maximus")
            }

        }
    }
}
