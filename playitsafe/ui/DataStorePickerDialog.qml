import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

FileDialog {
    id: dataStorePickerDialogId
    objectName: "DataStorePickerDialog"

    property string downloadsPath: ""
    property string titleText: qsTr("Import Data Store")

    visible: true
    // width: isPortraitMode ? rootId.width * .85 : rootId.width * .4
    folder: urlFilePrefix + downloadsPath
    selectFolder: false
    title: titleText
    onAccepted: {
        console.log("DataStorePickerDialog.onAccepted:  file = " + fileUrl)
        DataStoreManager.onFileChooserResultReceived(fileUrl.toString().replace(
                                                         urlFilePrefix, ""))
    }
}
