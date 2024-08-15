import QtQuick
import QtQuick.Controls
import QtQuick.Window

import MobileUI

ApplicationWindow {
    id: appWindow

    minimumWidth: 480
    minimumHeight: 960

    visible: true
    color: "#eee"

    // WINDOW MODE /////////////////////////////////////////////////////////////

    // Start on "MAXIMIZED" mode on iOS but "REGULAR" mode on Android
    flags: (Qt.platform.os === "ios") ? Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint : Qt.Window
    visibility: Window.AutomaticVisibility

    property int windowmode: (Qt.platform.os === "ios") ? 1 : 0 // this is important if you toggle between window flags/visibilities

    // START IN "REGULAR" MODE
    //flags: Qt.Window
    //visibility: Window.AutomaticVisibility
    //property int windowmode: 0

    // START IN "MAXIMIZED" MODE
    //flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    //visibility: Window.Maximized
    //property int windowmode: 1

    // START IN "FULLSCREEN" MODE
    //flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    //visibility: Window.FullScreen
    //property int windowmode: 1

    // WINDOW ORIENTATION //////////////////////////////////////////////////////

    // 1 = Qt.PortraitOrientation, 2 = Qt.LandscapeOrientation
    // 4 = Qt.InvertedPortraitOrientation, 8 = Qt.InvertedLandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation

    onScreenOrientationFullChanged: handleSafeAreas()
    onVisibilityChanged: handleSafeAreas()
    onWindowmodeChanged: handleSafeAreas()

    // SAFE AREAS //////////////////////////////////////////////////////////////

    property bool showSafeAreas: true

    property int screenPaddingStatusbar: 0
    property int screenPaddingNavbar: 0

    property int screenPaddingTop: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    function handleSafeAreas() {
        // safe areas handling is a work in progress /!\
        // safe areas are only taken into account when using maximized geometry / full screen mode

        mobileUI.refreshUI() // hack

        if (appWindow.visibility === Window.FullScreen ||
            appWindow.flags & Qt.MaximizeUsingFullscreenGeometryHint) {

            screenPaddingStatusbar = mobileUI.statusbarHeight
            screenPaddingNavbar = mobileUI.navbarHeight

            screenPaddingTop = mobileUI.safeAreaTop
            screenPaddingLeft = mobileUI.safeAreaLeft
            screenPaddingRight = mobileUI.safeAreaRight
            screenPaddingBottom = mobileUI.safeAreaBottom

            // hacks
            if (Qt.platform.os === "android") {
                if (appWindow.visibility === Window.FullScreen) {
                    screenPaddingStatusbar = 0
                    screenPaddingNavbar = 0
                }
                if (appWindow.flags & Qt.MaximizeUsingFullscreenGeometryHint) {
                    if (Screen.orientation === Qt.LandscapeOrientation) {
                        screenPaddingLeft = screenPaddingStatusbar
                        screenPaddingRight = screenPaddingNavbar
                        screenPaddingNavbar = 0
                    } else if (Screen.orientation === Qt.InvertedLandscapeOrientation) {
                        screenPaddingLeft = screenPaddingNavbar
                        screenPaddingRight = screenPaddingStatusbar
                        screenPaddingNavbar = 0
                    }
                }
            }
            // hacks
            if (Qt.platform.os === "ios") {
                if (appWindow.visibility === Window.FullScreen) {
                    screenPaddingStatusbar = 0
                }
            }
        } else {
            screenPaddingStatusbar = 0
            screenPaddingNavbar = 0
            screenPaddingTop = 0
            screenPaddingLeft = 0
            screenPaddingRight = 0
            screenPaddingBottom = 0
        }

        console.log("> handleSafeAreas()")
        console.log("- window mode:         " + appWindow.visibility)
        console.log("- window flags:        " + appWindow.flags)
        console.log("- screen dpi:          " + Screen.devicePixelRatio)
        console.log("- screen width:        " + Screen.width)
        console.log("- screen width avail:  " + Screen.desktopAvailableWidth)
        console.log("- screen height:       " + Screen.height)
        console.log("- screen height avail: " + Screen.desktopAvailableHeight)
        console.log("- screen orientation (full): " + Screen.orientation)
        console.log("- screen orientation (primary): " + Screen.primaryOrientation)
        console.log("- screenSizeStatusbar: " + screenPaddingStatusbar)
        console.log("- screenSizeNavbar:    " + screenPaddingNavbar)
        console.log("- screenPaddingTop:    " + screenPaddingTop)
        console.log("- screenPaddingLeft:   " + screenPaddingLeft)
        console.log("- screenPaddingRight:  " + screenPaddingRight)
        console.log("- screenPaddingBottom: " + screenPaddingBottom)
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

    ////////////////////////////////////////////////////////////////////////////

    MobileUI {
        id: mobileUI

        statusbarColor: "grey"
        statusbarTheme: MobileUI.Dark
        navbarColor: "grey"
        navbarTheme: MobileUI.Dark
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

            height: appWindow.screenPaddingTop
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: leftMarginVis

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            width: appWindow.screenPaddingLeft
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: rightMarginVis

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            width: appWindow.screenPaddingRight
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: bottomMarginVis

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: appWindow.screenPaddingBottom
            color: "red"
            opacity: 0.1
        }
    }

    ////////

    Item {
        id: systemBars
        anchors.fill: parent

        visible: appWindow.showSafeAreas

        Rectangle { // alwayse on top
            id: statusbarVis
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: appWindow.screenPaddingStatusbar
            color: "blue"
            opacity: 0.1
        }
        Rectangle {
            id: navbarVis
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: appWindow.screenPaddingNavbar
            color: "blue"
            opacity: 0.1
        }

        Rectangle {
            id: statusbarUnderlay
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            visible: (Qt.platform.os === "ios" || appWindow.windowmode === 1)
            height: appWindow.screenPaddingStatusbar
            color: "grey"
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: appContent

        anchors.top: parent.top
        anchors.topMargin: Math.max(appWindow.screenPaddingTop, appWindow.screenPaddingStatusbar)
        anchors.left: parent.left
        anchors.leftMargin: appWindow.screenPaddingLeft
        anchors.right: parent.right
        anchors.rightMargin: appWindow.screenPaddingRight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(appWindow.screenPaddingBottom, appWindow.screenPaddingNavbar)

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
                if (appWindow.visibility === Window.Maximized && Qt.platform.os === "ios" &&
                    appWindow.screenOrientation == Qt.LandscapeOrientation) return false

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
            spacing: 16

            Column {
                width: (appWindow.screenOrientation == Qt.PortraitOrientation)
                        ? appWindow.width : appWindow.width / 2

                spacing: 16

                visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")

                Button {
                    id: deviceThemeButton
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "device theme (?)"
                    onClicked: update()

                    function update() {
                        deviceThemeButton.text = "device theme (%1)".arg(mobileUI.deviceTheme ? "dark" : "light")
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "keep screen on (disabled)"
                    highlighted: mobileUI.screenAlwaysOn

                    onClicked: {
                        mobileUI.setScreenAlwaysOn(!mobileUI.screenAlwaysOn)
                        text = "keep screen on (%1)".arg(mobileUI.screenAlwaysOn ? "enabled" : "disabled")
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "regular"
                        highlighted: (appWindow.windowmode === 0)
                        onClicked: {
                            if (appWindow.windowmode !== 0) { // not re-setting same flags/visibility is important
                                appWindow.windowmode = 0
                                appWindow.flags = Qt.Window
                                appWindow.visibility = Window.Maximized
                            }
                        }
                    }
                    Button {
                        text: "maximized"
                        highlighted: (appWindow.windowmode === 1)
                        onClicked: {
                            if (appWindow.windowmode !== 1) { // not re-setting same flags/visibility is important
                                appWindow.windowmode = 1
                                appWindow.flags = Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
                                appWindow.visibility = Window.Maximized
                            }
                        }
                    }
                    Button {
                        text: "fullscreen"
                        highlighted: (appWindow.windowmode === 2)
                        onClicked: {
                            if (appWindow.windowmode !== 2) { // not re-setting same flags/visibility is important
                                appWindow.windowmode = 2
                                appWindow.flags = Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
                                appWindow.visibility = Window.FullScreen
                            }
                        }
                    }
                }
            }

            ////

            Column {
                width: (appWindow.screenOrientation == Qt.PortraitOrientation)
                        ? appWindow.width : appWindow.width / 2
                spacing: 16

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "←"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Landscape_left)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Landscape_left)
                    }
                    Button {
                        text: "↑"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Portrait)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Portrait)
                    }
                    Button {
                        text: "auto"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Unlocked)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Unlocked)
                    }
                    Button {
                        text: "↓"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Portrait_upsidedown)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Portrait_upsidedown)
                    }
                    Button {
                        text: "→"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Landscape_right)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Landscape_right)
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "show unsafe areas"
                    highlighted: appWindow.showSafeAreas
                    onClicked: appWindow.showSafeAreas = !appWindow.showSafeAreas
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "vibrate"
                    onClicked: mobileUI.vibrate()
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
