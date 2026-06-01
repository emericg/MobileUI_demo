# MobileUI_demo

[![GitHub Action Workflow Status](https://img.shields.io/github/actions/workflow/status/emericg/MobileUI_demo/ci_builds.yml?branch=v0&style=flat-square)](https://github.com/emericg/MobileUI_demo/actions/)

A Qt6 / QML demo application for the [MobileUI](https://github.com/emericg/MobileUI/tree/v0) module.  

> [!IMPORTANT]
> This is the **LEGACY** 'v0' branch, with support for Qt6 and Qt5, as well as support for QMake and CMake build systems.

## Screenshots

![MobileUIs](https://raw.githubusercontent.com/emericg/screenshots_flathub/master/MobileUI/MobileUI.png)

## About

### Dependencies

You will need a C++14 compiler and Qt 6.5 LTS to run this demo as is, but you can easily adapt it up to Qt 6.8+ or down to Qt 5.15 if you want.  
For macOS and iOS builds, you'll need Xcode (13+) installed.  
For Android builds, you'll need the appropriates JDK (17) SDK (24+) and NDK (25+). You can customize Android build environment using the `assets/android/gradle.properties` file.  

#### Building

```bash
$ git clone https://github.com/emericg/MobileUI_demo.git --recursive
$ cd MobileUI_demo/
$ qmake . # configure with QMake
$ cmake . # OR configure with CMake
$ make
```

## License

The MobileUI_demo project, just like the MobileUI module, is licensed under the [MIT license](LICENSE).

> Emeric Grange <emeric.grange@gmail.com>
