import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: saveToPdfDialogId
    objectName: "SaveToPdfDialog"

    property alias includePasswords: includePasswordsSwitchId.checked

    visible: true
    modal: true
    width: isPortraitMode ? windowWidth * .9 : windowWidth * .6
    title: qsTr("Save to Pdf")
    parent: ApplicationWindow.overlay
    x: (parent.width - width) * .5
    y: (parent.height - height) * .5
    contentHeight: textWithTitleHeight + toolbarHeight
    standardButtons: Dialog.Cancel | Dialog.Ok
    onAccepted: DataStoreManager.saveToPdf(includePasswords)
    onRejected: close()

    RowLayout {
        id: rowLayoutId
        anchors.fill: parent
        anchors.right: parent.right
        anchors.left: parent.right
        anchors.leftMargin: itemMargin

        Switch {
            id: includePasswordsSwitchId
            text: qsTr("Include websites' passwords?")
            checked: false
            Layout.fillWidth: true
        }
    }
}
