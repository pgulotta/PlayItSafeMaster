import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

Dialog {
    id: dataStoreClearDialogId

    property bool doExport: true

    objectName: "DataStoreClearDialog"
    visible: true
    modal: true
    width: isPortraitMode ? windowWidth * .85 : windowWidth * .6
    title: qsTr("Clear Data Store")
    parent: ApplicationWindow.overlay
    x: (parent.width - width) * .5
    y: (parent.height - height) * .5
    contentHeight: textWithTitleHeight * 2
    standardButtons: Dialog.No | Dialog.Yes
    onAccepted: DataStoreManager.clearAll()

    RowLayout {
        id: rowLayoutId
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
        //    font.pointSize: smallFontPointSize
            color: darkTextColor
            text: doExport ? qsTr("Data from the current data store will be exported to a new file and then cleared from current data store.  Continue?") : qsTr(
                                 "All data from the current data store will be cleared. This action cannot be undone. Continue?")
        }
    }

    function exportDataStore() {
        var filePath = DataStoreManager.exportDataStore()
        return (filePath !== "")
    }
}
