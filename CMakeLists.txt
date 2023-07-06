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
message(STATUS "[SYSTEM] (TARGET) SYSTEM NAME       = ${CMAKE_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM VESRION    = ${CMAKE_SYSTEM_VERSION}")
message(STATUS "[PROJECT] SOURCE_DIR                = ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "[PROJECT] BUILD_TYPE                = ${CMAKE_BUILD_TYPE}")
message(STATUS "[PROJECT] TOOLCHAIN_FILE            = ${CMAKE_TOOLCHAIN_FILE}")

################################################################################

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Svg)

qt_standard_project_setup()

qt_add_executable(MobileUI_demo src/main.cpp qml/qml.qrc)

target_include_directories(MobileUI_demo PRIVATE src)
target_include_directories(MobileUI_demo PUBLIC src/thirdparty)

################################################################################

## Android
if(ANDROID)
    #set(QT_ANDROID_ABIS "armeabi-v7a;arm64-v8a;x86;x86_64")
    #set(QT_ANDROID_BUILD_ALL_ABIS "ON")

    set_target_properties(MobileUI_demo PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/assets/android"
    )

    target_link_libraries(MobileUI_demo PRIVATE Qt::CorePrivate)
endif()

## macOS
if(APPLE AND NOT IOS)
    set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15")
endif()

## iOS
if(IOS)
    target_link_libraries(MobileUI_demo PRIVATE
        Qt::GuiPrivate
        "-framework UIKit"
    )
endif()

################################################################################

# MobileUI
add_subdirectory(src/thirdparty/MobileUI)
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

install(TARGETS QmlAppTemplate
    BUNDLE DESTINATION .    # used by macOS
    ARCHIVE DESTINATION .
    LIBRARY DESTINATION .   # used by Android
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

################################################################################
