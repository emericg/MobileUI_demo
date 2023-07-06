TARGET  = MobileUI_demo
VERSION = 0.1

DEFINES+= APP_NAME=\\\"$$TARGET\\\"
DEFINES+= APP_VERSION=\\\"$$VERSION\\\"

CONFIG += c++17
QT     += core qml quick quickcontrols2 svg

!versionAtLeast(QT_VERSION, 6.0) : error("You need Qt6 to run this demo. The MobileUI component itself can run with Qt5.")

# MobileUI submodule
include(MobileUI/MobileUI.pri)

# Project files
SOURCES     += src/main.cpp
RESOURCES   += qml/qml.qrc

OTHER_FILES += README.md  \
               .gitignore \
               .github/workflows/builds_desktop_qmake.yml \
               .github/workflows/builds_desktop_cmake.yml \
               .github/workflows/builds_mobile_qmake.yml \
               .github/workflows/builds_mobile_cmake.yml

# Application deployment and installation steps:

linux:!android {
    TARGET = $$lower($${TARGET})
}

macx {
    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = mobileuidemo

    # Target OS
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.15

    # Target architecture(s)
    QMAKE_APPLE_DEVICE_ARCHS = x86_64 arm64
}

win32 {
    #
}

android {
    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = mobileuidemo

    DISTFILES += $${PWD}/assets/android/AndroidManifest.xml \
                 $${PWD}/assets/android/gradle.properties \
                 $${PWD}/assets/android/build.gradle

    ANDROID_PACKAGE_SOURCE_DIR = $${PWD}/assets/android
}

ios {
    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = mobileuidemo

    QMAKE_INFO_PLIST = $${PWD}/assets/ios/Info.plist

    # Target OS
    QMAKE_IOS_DEPLOYMENT_TARGET = 11.0
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2 # 1: iPhone / 2: iPad / 1,2: Universal
}
