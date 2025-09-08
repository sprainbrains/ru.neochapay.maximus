TEMPLATE = lib
TARGET = qwebp
QT +=  core gui qml quick

SOURCES += \
    qwebp.cpp \
    qwebp.h \
    webpimageprovider.cpp \
    webpimageprovider.h

INCLUDEPATH += ../libwebp/src/

target.path = /usr/share/ru.neochapay.maximus/lib
INSTALLS += target
