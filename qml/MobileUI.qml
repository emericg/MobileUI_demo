import QtQuick
import QtQuick.Controls
import QtQuick.Window

import MobileUI

ApplicationWindow {
    id: appWindow
    minimumWidth: 480
    minimumHeight: 960

    flags: (Qt.platform.os === "ios") ? Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint : Qt.Window
    visibility: Window.AutomaticVisibility
    visible: true

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
                        screenPaddingStatusbar = screenPaddingTop
                        screenPaddingTop = 0
                    }
                } else {
                    screenPaddingNavbar = 0
                }
            }
            // hacks
            if (Qt.platform.os === "ios") {
                //
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

        statusbarTheme: MobileUI.Light
        statusbarColor: "grey"
        navbarTheme: MobileUI.Light
        navbarColor: "grey"
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

    Item {
        id: appContent
        anchors.fill: parent

        ////

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

        ////

        Item {
            id: systemBars
            anchors.fill: parent

            Rectangle {
                id: statusbarVis

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                height: screenPaddingStatusbar
                color: "blue"
                opacity: 0.1
            }
            Rectangle {
                id: navbarVis

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: screenPaddingNavbar
                color: "blue"
                opacity: 0.1
            }
        }

        ////

        ComboBox { // this combobox handle the status bar theme
            anchors.top: parent.top
            anchors.topMargin: 16 + screenPaddingStatusbar + screenPaddingTop
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16

            visible: (appWindow.visibility !== Window.FullScreen)

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
            }
        }

        ////

        Column {
            anchors.centerIn: parent
            spacing: 16

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
                    onClicked: {
                        appWindow.flags = Qt.Window
                        appWindow.visibility = Window.FullScreen
                        appWindow.visibility = Window.AutomaticVisibility
                        mobileUI.refreshUI()
                        handleSafeAreas()
                    }
                }
                Button {
                    text: "maximized"
                    onClicked: {
                        appWindow.flags = Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
                        appWindow.visibility = Window.FullScreen
                        appWindow.visibility = Window.AutomaticVisibility
                        //mobileUI.refreshUI() // DO NOT
                        handleSafeAreas()
                    }
                }
                Button {
                    text: "fullscreen"
                    onClicked: {
                        appWindow.flags = Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
                        appWindow.visibility = Window.FullScreen
                        //mobileUI.refreshUI() // DO NOT
                        handleSafeAreas()
                    }
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Button {
                    text: "left"
                    onClicked: mobileUI.lockScreenOrientation(MobileUI.Landscape_left)
                }
                Button {
                    text: "up"
                    onClicked: mobileUI.lockScreenOrientation(MobileUI.Portrait)
                }
                Button {
                    text: "0"
                    onClicked: mobileUI.lockScreenOrientation(MobileUI.Unlocked)
                }
                Button {
                    text: "down"
                    onClicked: mobileUI.lockScreenOrientation(MobileUI.Portrait_upsidedown)
                }
                Button {
                    text: "right"
                    onClicked: mobileUI.lockScreenOrientation(MobileUI.Landscape_right)
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter

                text: "vibrate"
                onClicked: mobileUI.vibrate()
            }
        }

        ////

        ComboBox { // this combobox handle the navigation bar theme
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16 + screenPaddingNavbar + screenPaddingBottom

            visible: (appWindow.visibility !== Window.FullScreen &&
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

        ////
    }
}
