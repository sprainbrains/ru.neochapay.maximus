TARGET = ru.neochapay.maximus

QT += core gui qml quick

CONFIG += link_pkgconfig
PKGCONFIG += glacierapp6

INCLUDEPATH += ../libs/qtwebsockets6 \
               ../libs/qmaxmessenger

LIBS += -L../libs/qtwebsockets6 -lqtwebsockets \
        -L../libs/qmaxmessenger/ -lqmaxmessenger

SOURCES += \
    main.cpp

qmlfiles.files += qml/*
qmlfiles.files += qml/*/*
qmlfiles.path = /usr/share/ru.neochapay.maximus/qml

target.path = /usr/bin

INSTALLS += target qmlfiles
