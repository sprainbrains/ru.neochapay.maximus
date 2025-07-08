import QtQuick
import QtQuick.Window
import Nemo
import Nemo.Controls

import ru.neochapay.maximus 1.0

ApplicationWindow {
    id: appWindow

    initialPage: Page {
        id: root

        headerTools: HeaderToolsLayout { title: "Maximus" }

        Spinner {
            id: spinner
            width: (Theme.itemHeightExtraSmall + Theme.itemSpacingMedium)*2
            height: (Theme.itemHeightExtraSmall + Theme.itemSpacingMedium)*2
            anchors.centerIn: parent
            clip: true
            enabled: true
        }
    }

    ServerConnection{
        id: serverConnection
        onReadyToLogin: {
            spinner.enabled = false
            if(userSession.storeToken.lenght == 0) {
                pageStack.replace(Qt.resolvedUrl("pages/EntherPhonePage.qml"))
                userSession.coldStart()
            } else {
                //refreshToken();
                requestDataSync();
            }
        }
        onTokenReady: {
            userSession.storeToken(token)
            pageStack.push(Qt.resolvedUrl("pages/EntherCodePage.qml"))
        }
    }

    UserSession{
        id: userSession
        onUserIdChanged: {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("pages/ChatListPage.qml"))
        }
    }

    ChatsListModel{
        id: chatListModel
    }
}
