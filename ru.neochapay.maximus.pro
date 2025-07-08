TEMPLATE = subdirs

SUBDIRS = libs
greaterThan(QT_MAJOR_VERSION, 5) {
    SUBDIRS += src_nemo
} else {
    SUBDIRS += src_aurora
}

OTHER_FILES += \
    LICENSE \
    README.md \
    rpm/*.spec

CONFIG += ordered
