# MobileUI_demo

[![GitHub action](https://img.shields.io/github/actions/workflow/status/emericg/MobileUI_demo/builds_desktop_qmake.yml?style=flat-square)](https://github.com/emericg/MobileUI_demo/actions/workflows/builds_desktop_qmake.yml)
[![GitHub action](https://img.shields.io/github/actions/workflow/status/emericg/MobileUI_demo/builds_desktop_cmake.yml?style=flat-square)](https://github.com/emericg/MobileUI_demo/actions/workflows/builds_desktop_cmake.yml)
[![GitHub action](https://img.shields.io/github/actions/workflow/status/emericg/MobileUI_demo/builds_mobile_qmake.yml?style=flat-square)](https://github.com/emericg/MobileUI_demo/actions/workflows/builds_mobile_qmake.yml)
[![GitHub action](https://img.shields.io/github/actions/workflow/status/emericg/MobileUI_demo/builds_mobile_cmake.yml?style=flat-square)](https://github.com/emericg/MobileUI_demo/actions/workflows/builds_mobile_cmake.yml)

A Qt6 / QML demo application for the [MobileUI](https://github.com/emericg/MobileUI) module.  

You can report bugs or request features directly on the [MobileUI issue page](https://github.com/emericg/MobileUI/issues).  

## About

### Dependencies

You will need a C++17 compiler and Qt 6.5+ to run this demo as is, but you can adapt it down to Qt 5.15 if you want.  
For macOS and iOS builds, you'll need Xcode (13+) installed.  
For Android builds, you'll need the appropriates JDK (11) SDK (24+) and NDK (25+). You can customize Android build environment using the `assets/android/gradle.properties` file.  

#### Building

```bash
$ git clone https://github.com/emericg/MobileUI_demo.git
$ cd MobileUI_demo/build/
$ qmake .. # configure with QMake
$ cmake .. # OR configure with CMake
$ make
```

## License

MobileUI_demo is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.  
Read the [LICENSE](LICENSE.md) file or [consult the license on the FSF website](https://www.gnu.org/licenses/gpl-3.0.txt) directly.

> Emeric Grange <emeric.grange@gmail.com>
