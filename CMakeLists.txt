cmake_minimum_required(VERSION 3.20)

project(MobileUI_demo VERSION 0.3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

################################################################################

message(STATUS ">>> BUILDING ${PROJECT_NAME} v${PROJECT_VERSION} >>>")
message(STATUS "[CMAKE] CMAKE_VERSION               = ${CMAKE_VERSION}")
message(STATUS "[CMAKE] CMAKE_PREFIX_PATH           = ${CMAKE_PREFIX_PATH}")
message(STATUS "[BUILD] QT_HOST_PATH                = ${QT_HOST_PATH}")
message(STATUS "[BUILD] TOOLCHAIN_FILE              = ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "[BUILD] BUILD_TYPE                  = ${CMAKE_BUILD_TYPE}")
message(STATUS "[SYSTEM] (HOST) SYSTEM NAME         = ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (HOST) SYSTEM VERSION      = ${CMAKE_HOST_SYSTEM_VERSION}")
message(STATUS "[SYSTEM] (HOST) SYSTEM PROCESSOR    = ${CMAKE_HOST_SYSTEM_PROCESSOR}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM NAME       = ${CMAKE_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM VERSION    = ${CMAKE_SYSTEM_VERSION}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM PROCESSOR  = ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "[TOP PROJECT] CMAKE_PROJECT_NAME    = ${CMAKE_PROJECT_NAME}")
message(STATUS "[TOP PROJECT] CMAKE_PROJECT_VERSION = ${CMAKE_PROJECT_VERSION}")
message(STATUS "[TOP PROJECT] CMAKE_SOURCE_DIR      = ${CMAKE_SOURCE_DIR}")
message(STATUS "[PROJECT] PROJECT_NAME              = ${PROJECT_NAME}")
message(STATUS "[PROJECT] PROJECT_VERSION           = ${PROJECT_VERSION}")
message(STATUS "[PROJECT] PROJECT_SOURCE_DIR        = ${PROJECT_SOURCE_DIR}")
message(STATUS "[PROJECT] CMAKE_CURRENT_SOURCE_DIR  = ${CMAKE_CURRENT_SOURCE_DIR}")

################################################################################

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(${PROJECT_NAME} src/main.cpp)

qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    NO_PLUGIN
    QML_FILES qml/MobileApplication.qml
)

# Qt
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
)

# MobileUI
add_subdirectory(MobileUI/)
target_link_libraries(${PROJECT_NAME} PRIVATE MobileUI MobileUI_plugin)

# Qt official hacks...
set(QML_IMPORT_PATH "${CMAKE_BINARY_DIR}/MobileUI" CACHE STRING "QML Modules import paths" FORCE)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

################################################################################

## Android
if(ANDROID)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        #QT_ANDROID_ABIS "armeabi-v7a;arm64-v8a;x86;x86_64"
        #QT_ANDROID_BUILD_ALL_ABIS ON
        QT_ANDROID_MIN_SDK_VERSION 28
        QT_ANDROID_TARGET_SDK_VERSION 36
        QT_ANDROID_PACKAGE_SOURCE_DIR "${PROJECT_SOURCE_DIR}/assets/android/"
    )

    # Support 16 KB page sizes / pre NDK28
    target_link_options(${PROJECT_NAME} PRIVATE "-Wl,-z,max-page-size=16384")
endif()

## iOS
if(IOS)
    set(CMAKE_OSX_ARCHITECTURES "arm64")
    set(CMAKE_OSX_SYSROOT "iphoneos")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "16.0")
    set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "16.0")
    set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2") # iPhone,iPad
    set(CMAKE_XCODE_ATTRIBUTE_INFOPLIST_FILE "${PROJECT_SOURCE_DIR}/assets/ios/Info.plist")

    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE ON
        MACOSX_BUNDLE_INFO_PLIST "${PROJECT_SOURCE_DIR}/assets/ios/Info.plist"
        # New Xcode attributes ???
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER           "io.emeric.mobileuidemo"
        XCODE_ATTRIBUTE_PRODUCT_NAME                        ${PROJECT_NAME}
        XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION             ${PROJECT_VERSION}
        XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET          "16.0"
        XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY              "1,2" # iPhone,iPad
    )
endif()

################################################################################

# Output (build)
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_INSTALL_BINDIR}
)

# Output (install)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION ${CMAKE_INSTALL_BINDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

################################################################################
