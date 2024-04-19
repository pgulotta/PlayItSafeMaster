import QtQuick
import QtQuick.Window
import QtQuick.Controls

ToolBar {
    id: mainToolBarId
    height: toolbarHeight

    onEnabledChanged: enabled ? opacityEnabledId.start(
                                    ) : opacityDisabledId.start()

    OpacityAnimator on opacity {
        id: opacityEnabledId
        from: 0.5
        to: 1.0
        running: false
        duration: animationDuration
    }
    OpacityAnimator on opacity {
        id: opacityDisabledId
        from: 1.0
        to: 0.5
        running: false
        duration: animationDuration
    }
    Rectangle {
        id: toolbarRectId
        anchors.fill: parent
        height: parent.height
        width: parent.width
        color: appToolbarColor
        border.color: darkTextColor
        border.width: 0

        ToolButton {
            id: mainToolButtonId
            anchors {
                left: parent.left
                leftMargin: itemMargin
                top: parent.top
                topMargin: 1
                bottom: parent.bottom
                bottomMargin: 1
            }

            icon.source: toolbarIcon
            icon.color: lightTextColor

            onClicked: {
                if (stackViewId.currentItem == null
                        || stackViewId.currentItem.objectName === "")
                    return
                if (stackViewId.currentItem.objectName === "SwitchboardPage") {
                    mainDrawerId.open()
                } else {
                    stackViewId.pop()
                    if (stackViewId.currentItem.objectName === "SwitchboardPage") {
                        toolbarIcon = "qrc:/images/menu.png"
                        toolbarTitle = SwitchboardManager.appName
                    }
                }
            }
        }

        TitleTextLight {
            id: titleTextLightId
            text: toolbarTitle
            anchors.centerIn: parent
            //  font.pointSize: smallFontPointSize
        }
    }
}
