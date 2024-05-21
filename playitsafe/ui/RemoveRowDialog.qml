import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: removeRowDialogId
    property string currentItemTitle

    objectName: "RemoveRowDialog.qml"
    visible: false
    modal: true
    width: Math.min(fieldColumnWidth * 1.75, 400)
    title: qsTr("Remove Current Item")
    parent: ApplicationWindow.overlay
    contentHeight: textWithTitleHeight
    standardButtons: Dialog.No | Dialog.Yes

    RowLayout {
        anchors.fill: parent
        anchors.right: parent.right
        anchors.rightMargin: largeMargin
        anchors.left: parent.right
        anchors.leftMargin: largeMargin
        Label {
            Layout.fillWidth: true
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignLeft
            text: currentItemTitle
                  == null ? qsTr("Removing the current item cannot be undone. Remove anyway?") : qsTr(
                                "Removing the current item ") + currentItemTitle + qsTr(
                                " cannot be undone. Continue?")
        }
    }
}
