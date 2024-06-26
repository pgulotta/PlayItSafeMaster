import QtQuick
import QtQuick.Controls

Dialog {
    id: messageDialogId

    property alias dialogMessage: messageId.text

    width: isPortraitMode ? windowWidth * .85 : windowWidth * .5
    height: isSmallScreenDevice ? toolbarHeight * 5 : toolbarHeight * 4
    parent: ApplicationWindow.overlay
    x: (parent.width - width) * .5
    y: (parent.height - height) * .5

    contentItem: Label {
        id: messageId
        wrapMode: Label.Wrap
        color: darkTextColor
        clip: true
        anchors {
            left: parent.left
            leftMargin: largeMargin
            right: parent.right
            rightMargin: itemIndent
        }
    }

    Timer {
        id: closeMessageDialogTimer
        interval: 3000
        repeat: false
        running: false
        onTriggered: messageDialogId.close()
    }

    onOpened: closeMessageDialogTimer.start()
}
