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

    property bool showHapticFeedbacks: false

    ////////////////////////////////////////////////////////////////////////////

    // MobileUI is a QML singleton, so it cannot (and should not) be instantiated.
    // Access its properties directly as MobileUI.*, set the initial bar colors imperatively,
    // and react to its signals through a Connections blocks or regular QML bindings.

    Component.onCompleted: {
        MobileUI.statusbarColor = "transparent"
        MobileUI.statusbarTheme = MobileUI.Dark

        MobileUI.navbarColor = "transparent"
        MobileUI.navbarTheme = MobileUI.Dark
    }

    Connections {
        target: MobileUI
        function onSafeAreaUpdated() { appWindow.printSafeAreas() }
    }

    function setRegular() {
        if (Qt.platform.os === "android") { // hacks
            if (appWindow.windowmode === 2) return
        }
        if (appWindow.windowmode !== 0) { // not re-setting same flags/visibility is important
            appWindow.windowmode = 0
            appWindow.flags &= ~Qt.MaximizeUsingFullscreenGeometryHint
            appWindow.showMaximized()

            // a flag-only change (regular <-> maximized) emits no QWindow signal,
            // so ask MobileUI to recompute the safe areas itself
            MobileUI.refreshMobileUI()
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

            // a flag-only change (regular <-> maximized) emits no QWindow signal,
            // so ask MobileUI to recompute the safe areas itself
            MobileUI.refreshMobileUI()
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

            // showFullScreen() does change visibility (so QWindow emits a signal),
            // but refresh explicitly too for parity with the other modes
            MobileUI.refreshMobileUI()
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
        console.log("- statusbarHeight: " + MobileUI.statusbarHeight)
        console.log("- navbarHeight:    " + MobileUI.navbarHeight)
        console.log("- safeAreaTop:     " + MobileUI.safeAreaTop)
        console.log("- safeAreaLeft:    " + MobileUI.safeAreaLeft)
        console.log("- safeAreaRight:   " + MobileUI.safeAreaRight)
        console.log("- safeAreaBottom:  " + MobileUI.safeAreaBottom)
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
                    break
            }
        }
    }

    onClosing: (close) => {
        if (Qt.platform.os === "android") {
            close.accepted = false
            MobileUI.backToHomeScreen()
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

            height: MobileUI.safeAreaTop
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: leftMarginVis

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            width: MobileUI.safeAreaLeft
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: rightMarginVis

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            width: MobileUI.safeAreaRight
            color: "red"
            opacity: 0.1
        }
        Rectangle {
            id: bottomMarginVis

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: MobileUI.safeAreaBottom
            color: "red"
            opacity: 0.1
        }
    }

    ////////////////

    Item {
        id: systemBars
        anchors.fill: parent

        visible: appWindow.showSafeAreas

        Rectangle { // alwayse on top, otherwise part of the safeAreas
            id: statusbarVis
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: MobileUI.statusbarHeight
            color: "blue"
            opacity: 0.1
        }
        Rectangle { // always on bottom, otherwise part of the safeAreas
            id: navbarVis
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: MobileUI.navbarHeight
            color: "blue"
            opacity: 0.1
        }

        Rectangle { // with Android API 35+, the actual status bar can't be colored anymore, this is an underlay backup
            id: statusbarUnderlay
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            visible: (Qt.platform.os === "ios" || appWindow.windowmode === 1)
            height: MobileUI.statusbarHeight
            color: "transparent"
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    FocusScope {
        id: appContent

        anchors.top: parent.top
        anchors.topMargin: Math.max(MobileUI.safeAreaTop, MobileUI.statusbarHeight)
        anchors.left: parent.left
        anchors.leftMargin: MobileUI.safeAreaLeft
        anchors.right: parent.right
        anchors.rightMargin: MobileUI.safeAreaRight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(MobileUI.safeAreaBottom, MobileUI.navbarHeight)

        Keys.onBackPressed: {
            MobileUI.backToHomeScreen()
        }

        ////////////////

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
                    Qt.platform.os === "ios" && MobileUI.isPhone) return false

                return true
            }

            model: ListModel {
                id: cbStatusbarColor
                ListElement { text: "transparent"; }
                ListElement { text: "grey"; }
                ListElement { text: "white"; }
                ListElement { text: "red"; }
                ListElement { text: "blue"; }
            }

            onActivated: {
                MobileUI.statusbarColor = currentText
                statusbarUnderlay.color = currentText
            }
        }

        ////////////////

        Column {
            anchors.centerIn: parent
            spacing: 16

            visible: !(Qt.platform.os === "android" || Qt.platform.os === "ios")

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                width: appContent.width * 0.75

                text: "MobileUI doesn't do much when used on a desktop OS.<br>" +
                      "Every function and variables are available and can be used without " +
                      "conditional checks, but without any functionality behind them."

                wrapMode: Text.WordWrap

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -16
                    z: -1
                    color: "white"
                }
            }
        }

        ////////////////

        Grid {
            anchors.centerIn: parent

            visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")
            spacing: (appWindow.screenOrientation == Qt.PortraitOrientation) ? 32 : 0

            columns: (appWindow.screenOrientation == Qt.PortraitOrientation) ? 1 : 2
            rows: 2

            ////////

            Column {
                width: (appWindow.screenOrientation == Qt.PortraitOrientation)
                        ? appWindow.width : appWindow.width / 2

                spacing: 8

                ////

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "regular"
                        highlighted: (appWindow.windowmode === 0)
                        onClicked: appWindow.setRegular()
                    }
                    Button {
                        text: "maximized"
                        highlighted: (appWindow.windowmode === 1)
                        onClicked: appWindow.setMaximized()
                    }
                    Button {
                        text: "fullscreen"
                        highlighted: (appWindow.windowmode === 2)
                        onClicked: appWindow.setFullScreen()
                    }
                }

                ////

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    property int lockedOrientation: MobileUI.Unlocked

                    Button {
                        text: "←"
                        highlighted: (parent.lockedOrientation === MobileUI.Landscape_left)
                        onClicked: {
                            MobileUI.screenLockOrientation = MobileUI.Landscape_left
                            parent.lockedOrientation = MobileUI.Landscape_left
                        }
                    }
                    Button {
                        text: "↑"
                        highlighted: (parent.lockedOrientation === MobileUI.Portrait)
                        onClicked: {
                            MobileUI.screenLockOrientation = MobileUI.Portrait
                            parent.lockedOrientation = MobileUI.Portrait
                        }
                    }
                    Button {
                        text: "auto"
                        highlighted: (parent.lockedOrientation === MobileUI.Unlocked)
                        onClicked: {
                            MobileUI.screenLockOrientation = MobileUI.Unlocked
                            parent.lockedOrientation = MobileUI.Unlocked
                        }
                    }
                    Button {
                        text: "↓"
                        highlighted: (parent.lockedOrientation === MobileUI.Portrait_upsidedown)
                        onClicked: {
                            MobileUI.screenLockOrientation = MobileUI.Portrait_upsidedown
                            parent.lockedOrientation = MobileUI.Portrait_upsidedown
                        }
                    }
                    Button {
                        text: "→"
                        highlighted: (parent.lockedOrientation === MobileUI.Landscape_right)
                        onClicked: {
                            MobileUI.screenLockOrientation = MobileUI.Landscape_right
                            parent.lockedOrientation = MobileUI.Landscape_right
                        }
                    }
                }

                ////

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "show unsafe areas"
                    highlighted: appWindow.showSafeAreas
                    onClicked: appWindow.showSafeAreas = !appWindow.showSafeAreas
                }

                ////
            }

            ////////

            Column {
                width: (appWindow.screenOrientation == Qt.PortraitOrientation)
                        ? appWindow.width : appWindow.width / 2
                spacing: 8

                ////

                Button {
                    id: deviceThemeButton
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "device theme (%1)".arg(MobileUI.deviceTheme ? "dark" : "light")
                }

                ////

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "screensaver (%1)".arg(MobileUI.screenAlwaysOn ? "disabled" : "enabled")
                        highlighted: MobileUI.screenAlwaysOn

                        onClicked: MobileUI.setScreenAlwaysOn(!MobileUI.screenAlwaysOn)
                    }

                    Button {
                        text: "secure (%1)".arg(MobileUI.screenSecure ? "on" : "off")
                        highlighted: MobileUI.screenSecure
                        onClicked: MobileUI.screenSecure = !MobileUI.screenSecure
                    }
                }

                ////

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        id: screenBrightnessButton
                        text: "brightness (" + MobileUI.screenBrightness + ")"
                        onClicked: MobileUI.screenBrightness = -1
                    }

                    Slider {
                        from: 0
                        to: 100
                        value: MobileUI.screenBrightness
                        onMoved: MobileUI.screenBrightness = value
                    }
                }

                ////

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    visible: !(Qt.platform.os === "ios" && MobileUI.isTablet)

                    Button {
                        text: "haptic feedback"
                        onClicked: MobileUI.hapticFeedback()
                    }
                    Button {
                        text: appWindow.showHapticFeedbacks ? "-" : "+"
                        onClicked: appWindow.showHapticFeedbacks = !appWindow.showHapticFeedbacks
                    }
                }
                Flow { // more haptic feedbacks...
                    width: parent.width
                    spacing: 4

                    visible: appWindow.showHapticFeedbacks && !(Qt.platform.os === "ios" && MobileUI.isTablet)

                    Button { text: "select"; onClicked: MobileUI.vibrate(MobileUI.HapticSelection) }
                    Button { text: "light";  onClicked: MobileUI.vibrate(MobileUI.HapticLight) }
                    Button { text: "medium"; onClicked: MobileUI.vibrate(MobileUI.HapticMedium) }
                    Button { text: "heavy";  onClicked: MobileUI.vibrate(MobileUI.HapticHeavy) }
                    Button { text: "success"; onClicked: MobileUI.vibrate(MobileUI.HapticSuccess) }
                    Button { text: "warning"; onClicked: MobileUI.vibrate(MobileUI.HapticWarning) }
                    Button { text: "error";  onClicked: MobileUI.vibrate(MobileUI.HapticError) }
                }

                ////
/*
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: "torch (%1)".arg(MobileUI.torchEnabled ? "on" : "off")
                        highlighted: MobileUI.torchEnabled
                        onClicked: MobileUI.setTorchEnabled(!MobileUI.torchEnabled)
                    }

                    Button {
                        // updates automatically: keyboardHeight has a NOTIFY signal
                        text: "keyboard (%1)".arg(MobileUI.keyboardHeight)
                    }

                    TextField {
                        width: 96
                        placeholderText: "tap to type"
                    }
                }
*/
                ////

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    visible: (Qt.platform.os === "ios")

                    Button {
                        text: "badge +1 (%1)".arg(MobileUI.iconBadgeNumber)
                        onClicked: MobileUI.iconBadgeNumber = MobileUI.iconBadgeNumber + 1
                    }
                    Button {
                        text: "clear badge"
                        onClicked: MobileUI.iconBadgeNumber = 0
                    }
                }

                ////
            }

            ////////
        }

        ////////////////

        Column {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            spacing: 8

            ////

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

            ////

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

            ////

            ComboBox { // this combobox handle the navigation bar color+theme
                anchors.left: parent.left
                anchors.right: parent.right

                visible: (appWindow.windowmode === 0 && Qt.platform.os === "android")

                model: ListModel {
                    id: cbNavbarColor
                    ListElement { text: "transparent"; }
                    ListElement { text: "grey"; }
                    ListElement { text: "white"; }
                    ListElement { text: "red"; }
                    ListElement { text: "blue"; }
                }

                onActivated: {
                    MobileUI.navbarColor = currentText
                }
            }

            ////
        }

        ////////////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
