import QtQuick
import QtQuick.Controls
import QtQuick.Window

import MobileUI

Window {
    id: appWindow

    minimumWidth: 480
    minimumHeight: 960

    visible: true
    color: "#eee"

    // WINDOW MODE /////////////////////////////////////////////////////////////

    // START IN "REGULAR" MODE
    //flags: Qt.Window
    //visibility: Window.AutomaticVisibility
    //property int windowmode: 0

    // START IN "MAXIMIZED" MODE
    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    visibility: Window.Maximized
    property int windowmode: 1

    // START IN "FULLSCREEN" MODE
    //flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    //visibility: Window.FullScreen
    //property int windowmode: 2

    // WINDOW ORIENTATION //////////////////////////////////////////////////////

    // 1 = Qt.PortraitOrientation, 2 = Qt.LandscapeOrientation
    // 4 = Qt.InvertedPortraitOrientation, 8 = Qt.InvertedLandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation

    // SAFE AREAS //////////////////////////////////////////////////////////////

    property bool showSafeAreas: true

    ////////////////////////////////////////////////////////////////////////////

    MobileUI {
        id: mobileUI

        statusbarColor: "grey"
        statusbarTheme: MobileUI.Dark

        navbarColor: "grey"
        navbarTheme: MobileUI.Dark

        onSafeAreaUpdated: printSafeAreas()

        function setRegular() {
            if (Qt.platform.os === "android") { // hacks
                if (appWindow.windowmode === 2) return
            }
            if (appWindow.windowmode !== 0) { // not re-setting same flags/visibility is important
                appWindow.windowmode = 0
                appWindow.flags &= ~Qt.MaximizeUsingFullscreenGeometryHint
                appWindow.showMaximized()
            }
        }
        function setMaximized() {
            if (Qt.platform.os === "android") { // hacks
                if (appWindow.windowmode !== 1)
                    if (appWindow.windowmode === 0) appWindow.showFullScreen()
            }
            if (appWindow.windowmode !== 1) { // not re-setting same flags/visibility is important
                appWindow.windowmode = 1
                appWindow.flags |= Qt.MaximizeUsingFullscreenGeometryHint
                appWindow.showMaximized()
            }
        }
        function setFullScreen() {
            if (Qt.platform.os === "android") { // hacks
                if (appWindow.windowmode === 0) return
            }
            if (appWindow.windowmode !== 2) { // not re-setting same flags/visibility is important
                appWindow.windowmode = 2
                appWindow.flags |= Qt.MaximizeUsingFullscreenGeometryHint
                appWindow.showFullScreen()
            }
        }

        function printSafeAreas() {
            console.log("> printSafeAreas()")
            console.log("- window mode:         " + appWindow.visibility)
            console.log("- window flags:        " + appWindow.flags)
            console.log("- screen dpi:          " + Screen.devicePixelRatio)
            console.log("- screen width:        " + Screen.width)
            console.log("- screen width avail:  " + Screen.desktopAvailableWidth)
            console.log("- screen height:       " + Screen.height)
            console.log("- screen height avail: " + Screen.desktopAvailableHeight)
            console.log("- screen orientation (full):    " + Screen.orientation)
            console.log("- screen orientation (primary): " + Screen.primaryOrientation)
            console.log("- statusbarHeight: " + mobileUI.statusbarHeight)
            console.log("- navbarHeight:    " + mobileUI.navbarHeight)
            console.log("- safeAreaTop:     " + mobileUI.safeAreaTop)
            console.log("- safeAreaLeft:    " + mobileUI.safeAreaLeft)
            console.log("- safeAreaRight:   " + mobileUI.safeAreaRight)
            console.log("- safeAreaBottom:  " + mobileUI.safeAreaBottom)
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Connections {
        target: Qt.application
        function onStateChanged() {
            switch (Qt.application.state) {
                case Qt.ApplicationSuspended:
                    //console.log("Qt.ApplicationSuspended")
                    break
                case Qt.ApplicationHidden:
                    //console.log("Qt.ApplicationHidden")
                    break
                case Qt.ApplicationInactive:
                    //console.log("Qt.ApplicationInactive")
                    break
                case Qt.ApplicationActive:
                    //console.log("Qt.ApplicationActive")

                    // you should probably not switch your app theme while it's being used,
                    // only during an interaction like the app being brought back to the foreground,
                    // so this is a good place to check if the device theme has changed while on the background
                    deviceThemeButton.update()

                    break
            }
        }
    }

    onClosing: (close) => {
        if (Qt.platform.os === "android") {
            close.accepted = false
            mobileUI.backToHomeScreen()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: safeAreas
        anchors.fill: parent

        visible: appWindow.showSafeAreas

        Rectangle {
            id: topMarginVis

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: mobileUI.safeAreaTop
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: leftMarginVis

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            width: mobileUI.safeAreaLeft
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: rightMarginVis

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            width: mobileUI.safeAreaRight
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: bottomMarginVis

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: mobileUI.safeAreaBottom
            color: "red"
            opacity: 0.1
        }
    }

    ////////

    Item {
        id: systemBars
        anchors.fill: parent

        visible: appWindow.showSafeAreas

        Rectangle { // alwayse on top, otherwise part of the safeAreas
            id: statusbarVis
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: mobileUI.statusbarHeight
            color: "blue"
            opacity: 0.1
        }
        Rectangle { // always on bottom, otherwise part of the safeAreas
            id: navbarVis
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: mobileUI.navbarHeight
            color: "blue"
            opacity: 0.1
        }

        Rectangle {
            id: statusbarUnderlay
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            visible: (Qt.platform.os === "ios" || appWindow.windowmode === 1)
            height: mobileUI.statusbarHeight
            color: "grey"
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    FocusScope {
        id: appContent

        anchors.top: parent.top
        anchors.topMargin: Math.max(mobileUI.safeAreaTop, mobileUI.statusbarHeight)
        anchors.left: parent.left
        anchors.leftMargin: mobileUI.safeAreaLeft
        anchors.right: parent.right
        anchors.rightMargin: mobileUI.safeAreaRight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(mobileUI.safeAreaBottom, mobileUI.navbarHeight)

        Keys.onBackPressed: {
            mobileUI.backToHomeScreen()
        }

        ////////

        ComboBox { // this combobox handle the status bar color+theme
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16

            visible: {
                if (Qt.platform.os !== "android" && Qt.platform.os !== "ios") return false
                if (appWindow.visibility === Window.FullScreen) return false
                if (appWindow.visibility === Window.Maximized &&
                    appWindow.screenOrientation == Qt.LandscapeOrientation &&
                    Qt.platform.os === "ios" && mobileUI.isPhone) return false

                return true
            }

            model: ListModel {
                id: cbStatusbarColor
                ListElement { text: "grey"; }
                ListElement { text: "white"; }
                ListElement { text: "red"; }
                ListElement { text: "blue"; }
                ListElement { text: "transparent"; }
            }

            onActivated: {
                mobileUI.statusbarColor = currentText
                statusbarUnderlay.color = currentText
            }
        }

        ////////

        Column {
            anchors.centerIn: parent
            spacing: 16

            visible: !(Qt.platform.os === "android" || Qt.platform.os === "ios")

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                width: appContent.width * 0.75

                text: "MobileUI doesn't do much when used on a desktop OS.<br>" +
                      "Every functions and variables are available and can be used without" +
                      "conditional checks, but without any functionnality behind them."

                wrapMode: Text.WordWrap

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -16
                    z: -1
                    color: "white"
                }
            }
        }

        ////////

        Grid {
            anchors.centerIn: parent

            visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")
            columns: (appWindow.screenOrientation == Qt.PortraitOrientation) ? 1 : 2
            rows: 2
            spacing: (appWindow.screenOrientation == Qt.PortraitOrientation) ? 32 : 0

            Column {
                width: (appWindow.screenOrientation == Qt.PortraitOrientation)
                        ? appWindow.width : appWindow.width / 2

                visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")
                spacing: 8

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "regular"
                        highlighted: (appWindow.windowmode === 0)
                        onClicked: mobileUI.setRegular()
                    }
                    Button {
                        text: "maximized"
                        highlighted: (appWindow.windowmode === 1)
                        onClicked: mobileUI.setMaximized()
                    }
                    Button {
                        text: "fullscreen"
                        highlighted: (appWindow.windowmode === 2)
                        onClicked: mobileUI.setFullScreen()
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    property int forcedOrientation: MobileUI.Unlocked

                    Button {
                        text: "←"
                        highlighted: (parent.forcedOrientation === MobileUI.Landscape_left)
                        onClicked: {
                            mobileUI.setScreenOrientation(MobileUI.Landscape_left)
                            parent.forcedOrientation = MobileUI.Landscape_left
                        }
                    }
                    Button {
                        text: "↑"
                        highlighted: (parent.forcedOrientation === MobileUI.Portrait)
                        onClicked: {
                            mobileUI.setScreenOrientation(MobileUI.Portrait)
                            parent.forcedOrientation = MobileUI.Portrait
                        }
                    }
                    Button {
                        text: "auto"
                        highlighted: (parent.forcedOrientation === MobileUI.Unlocked)
                        onClicked: {
                            mobileUI.setScreenOrientation(MobileUI.Unlocked)
                            parent.forcedOrientation = MobileUI.Unlocked
                        }
                    }
                    Button {
                        text: "↓"
                        highlighted: (parent.forcedOrientation === MobileUI.Portrait_upsidedown)
                        onClicked: {
                            mobileUI.setScreenOrientation(MobileUI.Portrait_upsidedown)
                            parent.forcedOrientation = MobileUI.Portrait_upsidedown
                        }
                    }
                    Button {
                        text: "→"
                        highlighted: (parent.forcedOrientation === MobileUI.Landscape_right)
                        onClicked: {
                            mobileUI.setScreenOrientation(MobileUI.Landscape_right)
                            parent.forcedOrientation = MobileUI.Landscape_right
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "show unsafe areas"
                    highlighted: appWindow.showSafeAreas
                    onClicked: appWindow.showSafeAreas = !appWindow.showSafeAreas
                }
            }

            ////

            Column {
                width: (appWindow.screenOrientation == Qt.PortraitOrientation)
                        ? appWindow.width : appWindow.width / 2
                spacing: 8

                Button {
                    id: deviceThemeButton
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "device theme (?)"
                    onClicked: update()

                    function update() {
                        deviceThemeButton.text = "device theme (%1)".arg(mobileUI.deviceTheme ? "dark" : "light")
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "lock screensaver (disabled)"
                        highlighted: mobileUI.screenAlwaysOn

                        onClicked: {
                            mobileUI.setScreenAlwaysOn(!mobileUI.screenAlwaysOn)
                            text = "lock screensaver (%1)".arg(mobileUI.screenAlwaysOn ? "enabled" : "disabled")
                        }
                    }
                    Button {

                        visible: !(Qt.platform.os === "ios" && mobileUI.isTablet)

                        text: "vibrate"
                        onClicked: mobileUI.vibrate()
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        id: screenBrightnessButton
                        text: "brightness (" + mobileUI.screenBrightness + ")"
                        onClicked: text = "brightness (" + mobileUI.screenBrightness + ")"
                    }

                    Slider {
                        from: 0
                        to: 100
                        value: mobileUI.screenBrightness
                        onMoved: {
                            mobileUI.screenBrightness = value
                            screenBrightnessButton.text = "brightness (" + mobileUI.screenBrightness + ")"
                        }
                    }
                }
            }
        }

        ////////

        Column {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            spacing: 8

            Row {
                anchors.right: parent.right
                spacing: 8

                visible: appWindow.showSafeAreas

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Unsafe areas"
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 16
                    height: 16
                    color: "red"
                    opacity: 0.1
                }
            }

            Row {
                anchors.right: parent.right
                spacing: 8

                visible: appWindow.showSafeAreas

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "System bars areas"
                }
                Rectangle {
                    width: 16
                    height: 16
                    color: "blue"
                    opacity: 0.1
                }
            }

            ComboBox { // this combobox handle the navigation bar color+theme
                anchors.left: parent.left
                anchors.right: parent.right

                visible: (appWindow.windowmode === 0 && Qt.platform.os === "android")

                model: ListModel {
                    id: cbNavbarColor
                    ListElement { text: "grey"; }
                    ListElement { text: "white"; }
                    ListElement { text: "red"; }
                    ListElement { text: "blue"; }
                    ListElement { text: "transparent"; }
                }

                onActivated: {
                    mobileUI.navbarColor = currentText
                }
            }
        }

        ////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
