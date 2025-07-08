TEMPLATE = lib
TARGET = qtwebsockets
QT +=  core core_private network network_private

SOURCES += \
    qdefaultmaskgenerator_p.cpp \
    qmaskgenerator.cpp \
    qwebsocketcorsauthenticator.cpp \
    qwebsocket.cpp \
    qwebsocketdataprocessor.cpp \
    qwebsocketframe.cpp \
    qwebsockethandshakeoptions.cpp \
    qwebsockethandshakerequest.cpp \
    qwebsockethandshakeresponse.cpp \
    qwebsocket_p.cpp \
    qwebsocketprotocol.cpp \
    qwebsocketserver.cpp \
    qwebsocketserver_p.cpp

HEADERS += \
    qdefaultmaskgenerator_p.h \
    qmaskgenerator.h \
    qwebsocketcorsauthenticator.h \
    qwebsocketcorsauthenticator_p.h \
    qwebsocketdataprocessor_p.h \
    qwebsocketframe_p.h \
    qwebsocket.h \
    qwebsockethandshakeoptions.h \
    qwebsockethandshakeoptions_p.h \
    qwebsockethandshakerequest_p.h \
    qwebsockethandshakeresponse_p.h \
    qwebsocket_p.h \
    qwebsocketprotocol.h \
    qwebsocketprotocol_p.h \
    qwebsocketserver.h \
    qwebsocketserver_p.h \
    qwebsockets_global.h

target.path = /usr/lib

INSTALLS += target
