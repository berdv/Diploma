TEMPLATE = app

QT += sql qml quick widgets gui declarative

SOURCES += main.cpp \
    database.cpp \
    mainwindow.cpp \
    check.cpp

RESOURCES += qml.qrc

HEADERS += \
    database.h \
    mainwindow.h \
    check.h

FORMS += \
    mainwindow.ui

# - setup the correct location to install to and load from
android {
    # android platform
    # From: http://community.kde.org/Necessitas/Assets
    EXTRASOURCES_INSTALL_PATH=/assets/ExtraSources
} else {
    # other platforms
    EXTRASOURCES_INSTALL_PATH=$$OUT_PWD/ExtraSources
}

# - setup the 'make install' step
extrasources.path = $$EXTRASOURCES_INSTALL_PATH
extrasources.files += dbinitial.txt#da_db.sqlite
extrasources.files += props.txt
#samples.depends += FORCE

INSTALLS += extrasources

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
