cmake_minimum_required(VERSION 3.20)

project(MobileUI_demo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

################################################################################

message(STATUS "[CMAKE] CMAKE_VERSION               = ${CMAKE_VERSION}")
message(STATUS "[CMAKE] CMAKE_PREFIX_PATH           = ${CMAKE_PREFIX_PATH}")
message(STATUS "[SYSTEM] (HOST) SYSTEM NAME         = ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (HOST) SYSTEM VERSION      = ${CMAKE_HOST_SYSTEM_VERSION}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM NAME       = ${CMAKE_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM VERSION    = ${CMAKE_SYSTEM_VERSION}")
message(STATUS "[PROJECT] SOURCE_DIR                = ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "[PROJECT] BUILD_TYPE                = ${CMAKE_BUILD_TYPE}")
message(STATUS "[PROJECT] TOOLCHAIN_FILE            = ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "[PROJECT] QT_HOST_PATH              = ${QT_HOST_PATH}")

################################################################################

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(${CMAKE_PROJECT_NAME} src/main.cpp qml/qml.qrc)

# MobileUI
add_subdirectory(MobileUI/)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE MobileUI)

################################################################################

## Android
if(ANDROID)
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        QT_ANDROID_ABIS "armeabi-v7a;arm64-v8a;x86;x86_64"
        QT_ANDROID_BUILD_ALL_ABIS ON
        QT_ANDROID_MIN_SDK_VERSION 23
        QT_ANDROID_TARGET_SDK_VERSION 35
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/assets/android/"
    )
endif()

## iOS
if(IOS)
    set(CMAKE_OSX_ARCHITECTURES "arm64")
    set(CMAKE_OSX_SYSROOT "iphoneos")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "14.0")
    set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "14.0")
    set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2") # iPhone,iPad
    set(CMAKE_XCODE_ATTRIBUTE_INFOPLIST_FILE "${CMAKE_CURRENT_SOURCE_DIR}/assets/ios/Info.plist")

    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE ON
        # Old way ???
        MACOSX_BUNDLE_GUI_IDENTIFIER            "io.emeric.mobileuidemo"
        MACOSX_BUNDLE_BUNDLE_NAME               ${CMAKE_PROJECT_NAME}
        MACOSX_BUNDLE_INFO_PLIST                "${CMAKE_CURRENT_SOURCE_DIR}/assets/ios/Info.plist"
        #QT_IOS_LAUNCH_SCREEN                    "${CMAKE_CURRENT_SOURCE_DIR}/assets/ios/LaunchScreen.storyboard"
        # New Xcode attributes ???
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER           "io.emeric.mobileuidemo"
        XCODE_ATTRIBUTE_PRODUCT_NAME                        ${CMAKE_PROJECT_NAME}
        XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET          "14.0"
        XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY              "1,2"   # iPhone,iPad
    )
endif()

################################################################################

# MobileUI
add_subdirectory(MobileUI/)
target_link_libraries(MobileUI_demo PRIVATE MobileUI)

# Qt
target_link_libraries(MobileUI_demo PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
)

################################################################################

install(TARGETS ${CMAKE_PROJECT_NAME}
    BUNDLE DESTINATION .
    ARCHIVE DESTINATION .
    LIBRARY DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

################################################################################
