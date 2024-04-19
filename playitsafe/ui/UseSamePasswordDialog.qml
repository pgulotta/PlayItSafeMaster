import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

Dialog {
    id: useSamePasswordDialogId
    objectName: "UseSamePasswordDialog"

    visible: true
    modal: true
    width: Math.min(fieldColumnWidth * 1.75, 400)
    title: qsTr("Import Data Store Password")
    parent: ApplicationWindow.overlay
    x: (parent.width - width) * .5
    y: (parent.height - height) * .5
    contentHeight: textWithTitleHeight
    standardButtons: Dialog.No | Dialog.Yes

    onAccepted: close()
    onRejected: close()

    RowLayout {
        id: rowLayoutId
        anchors.fill: parent
        anchors.right: parent.right
        anchors.left: parent.right
        anchors.leftMargin: itemMargin
        Text {
            id: useSamePasswordSwitchId
        //    font.pointSize: smallFontPointSize
            text: qsTr("Open using last password?")
        }
    }
}
