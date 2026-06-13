# MobileUI_demo

[![GitHub Action Workflow Status](https://img.shields.io/github/actions/workflow/status/emericg/MobileUI_demo/ci_builds.yml?style=flat-square)](https://github.com/emericg/MobileUI_demo/actions/workflows/ci_builds.yml)

A Qt6 / QML demo application for the [MobileUI](https://github.com/emericg/MobileUI) module.  

You can report bugs or request features directly on the [MobileUI issue page](https://github.com/emericg/MobileUI/issues).  

> [!NOTE]
> The **LEGACY** 'v1' branch is available with modern architecture and requirements (Qt 6.8+ and CMake) but without the QML singleton for MobileUI. It could help you migrate your application from an older MobileUI version.

> [!NOTE]
> The **LEGACY** 'v0' branch is available with support for Qt6 and Qt5, as well as support for QMake and CMake build systems.

## Screenshots

![MobileUIs](https://raw.githubusercontent.com/emericg/screenshots_flathub/master/MobileUI/MobileUI.png)

## About

### Dependencies

You will need a C++17 compiler and Qt 6.8 LTS to run this demo.  
For macOS and iOS builds, you'll need Xcode (15+) installed.  
For Android builds, you'll need the appropriates JDK (17) SDK (28+) and NDK (26+). You can customize Android build environment using the `assets/android/gradle.properties` file.  

#### Building

```bash
$ git clone https://github.com/emericg/MobileUI_demo.git --recursive
$ cd MobileUI_demo/
$ cmake -B build/
$ cmake --build build/
```

## License

The MobileUI_demo project, just like the MobileUI module, is licensed under the [MIT license](LICENSE).

> Emeric Grange <emeric.grange@gmail.com>
