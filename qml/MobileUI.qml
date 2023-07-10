import QtQuick
import QtQuick.Controls
import QtQuick.Window

import MobileUI

ApplicationWindow {
    id: appWindow

    minimumWidth: 480
    minimumHeight: 960
    visible: true

    // Start on "MAXIMIZED" mode on iOS but "REGULAR" mode on Android
    flags: (Qt.platform.os === "ios") ? Qt.Window : Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    visibility: Window.AutomaticVisibility
    property int windowmode: (Qt.platform.os === "ios") ? 1 : 0 // this is important if you toggle between window flags/visibilities

    // START IN "REGULAR" MODE
    //flags: Qt.Window
    //property int windowmode: 0
    //visibility: Window.AutomaticVisibility

    // START IN "MAXIMIZED" MODE
    //flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    //property int windowmode: 1
    //visibility: Window.Maximized

    // START IN "FULLSCREEN" MODE
    //flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    //property int windowmode: 1
    //visibility: Window.FullScreen

    property string colorBackground: "#eee"
    color: colorBackground

    property int screenPaddingStatusbar: 0
    property int screenPaddingNavbar: 0

    property int screenPaddingTop: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    // 1 = Qt.PortraitOrientation, 2 = Qt.LandscapeOrientation
    // 4 = Qt.InvertedPortraitOrientation, 8 = Qt.InvertedLandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation

    onScreenOrientationChanged: handleSafeAreas()
    onVisibilityChanged: handleSafeAreas()

    function handleSafeAreas() {
        // safe areas handling is a work in progress /!\

        // safe areas are only taken into account when using maximized geometry / full screen mode

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
                if (Screen.primaryOrientation === Qt.PortraitOrientation) {
                    if (appWindow.visibility === Window.FullScreen) {
                        screenPaddingStatusbar = 0
                        screenPaddingNavbar = 0
                    } else {
                        screenPaddingStatusbar = mobileUI.safeAreaTop
                        screenPaddingTop = 0
                    }
                } else {
                    screenPaddingNavbar = 0
                }
            }
            // hacks
            if (Qt.platform.os === "ios") {
                if (appWindow.visibility === Window.FullScreen) {
                    screenPaddingStatusbar = 0
                } else {
                    screenPaddingStatusbar = mobileUI.safeAreaTop
                    screenPaddingTop = 0
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

    MobileUI {
        id: mobileUI

        statusbarColor: "grey"
        statusbarTheme: MobileUI.Dark
        navbarColor: "grey"
        navbarTheme: MobileUI.Dark
    }

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

    Item {
        id: appContent
        anchors.fill: parent

        ////////

        Item {
            id: safeAreas
            anchors.fill: parent

            Rectangle {
                id: topMarginVis

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                height: screenPaddingTop
                color: "red"
                opacity: 0.1
            }
            Rectangle {
                id: leftMarginVis

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                width: screenPaddingLeft
                color: "red"
                opacity: 0.1
            }
            Rectangle {
                id: rightMarginVis

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                width: screenPaddingRight
                color: "red"
                opacity: 0.1
            }
            Rectangle {
                id: bottomMarginVis

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: screenPaddingBottom
                color: "red"
                opacity: 0.1
            }
        }

        ////////

        Item {
            id: systemBars
            anchors.fill: parent

            Rectangle {
                id: iosStatusbar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                visible: (Qt.platform.os === "ios")
                height: screenPaddingStatusbar
                color: "grey"
                z: 10
            }

            Rectangle {
                id: statusbarVis
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                visible: (Qt.platform.os === "android")
                height: screenPaddingStatusbar
                color: "blue"
                opacity: 0.1
            }
            Rectangle {
                id: navbarVis
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                visible: (Qt.platform.os === "android")
                height: screenPaddingNavbar
                color: "blue"
                opacity: 0.1
            }
        }

        ////////

        ComboBox { // this combobox handle the status bar color+theme
            anchors.top: parent.top
            anchors.topMargin: 16 + screenPaddingStatusbar + screenPaddingTop
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16

            visible: (Qt.platform.os === "android" || Qt.platform.os === "ios") &&
                     (appWindow.visibility !== Window.FullScreen)

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
                iosStatusbar.color = currentText
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

                text: "MobileUI doesn't do much when used on a desktop OS.<br>
                       Every functions and variables are available and can be used without
                       conditional checks, but without any functionnality behind them."

                wrapMode: Text.WordWrap

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -16
                    z: -1
                    color: white
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

                    visible: (Qt.platform.os === "android")
                    text: "device theme (?)"
                    onClicked: update()

                    function update() {
                        deviceThemeButton.text = "device theme (%1)".arg(mobileUI.deviceTheme ? "dark" : "light")
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "keep screen on (disabled)"

                    onClicked: {
                        mobileUI.setScreenKeepOn(!mobileUI.screenAlwaysOn)
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
                            if (appWindow.windowmode !== 0) {
                                appWindow.windowmode = 0 // not re-setting same flags/visibility is important

                                appWindow.flags = Qt.Window
                                appWindow.visibility = Window.Maximized
                                mobileUI.refreshUI()
                                handleSafeAreas()
                            }
                        }
                    }
                    Button {
                        text: "maximized"
                        highlighted: (appWindow.windowmode === 1)
                        onClicked: {
                            if (appWindow.windowmode !== 1) {
                                appWindow.windowmode = 1 // not re-setting same flags/visibility is important

                                appWindow.flags = Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
                                appWindow.visibility = Window.Maximized
                                mobileUI.refreshUI()
                                handleSafeAreas()
                            }
                        }
                    }
                    Button {
                        text: "fullscreen"
                        highlighted: (appWindow.windowmode === 2)
                        onClicked: {
                            if (appWindow.windowmode !== 2) {
                                appWindow.windowmode = 2 // not re-setting same flags/visibility is important

                                appWindow.flags = Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
                                appWindow.visibility = Window.FullScreen
                                mobileUI.refreshUI()
                                handleSafeAreas()
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
                        text: "left"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Landscape_left)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Landscape_left)
                    }
                    Button {
                        text: "up"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Portrait)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Portrait)
                    }
                    Button {
                        text: "0"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Unlocked)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Unlocked)
                    }
                    Button {
                        text: "down"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Portrait_upsidedown)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Portrait_upsidedown)
                    }
                    Button {
                        text: "right"
                        highlighted: (mobileUI.screenOrientation === MobileUI.Landscape_right)
                        onClicked: mobileUI.setScreenOrientation(MobileUI.Landscape_right)
                    }
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
            anchors.bottomMargin: 16 + screenPaddingNavbar + screenPaddingBottom
            spacing: 8

            Row {
                anchors.right: parent.right
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Safe areas"
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

                visible: (appWindow.windowmode === 0 &&
                          Qt.platform.os === "android")

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
