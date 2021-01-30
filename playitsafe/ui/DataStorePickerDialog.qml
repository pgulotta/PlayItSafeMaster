import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.platform 1.1

FileDialog {
    id: dataStorePickerDialogId
    objectName: "DataStorePickerDialog"

    property string downloadsPath: ""
    property string titleText: qsTr("Import Data Store")

    visible: true
    folder: urlFilePrefix + downloadsPath
    title: titleText
    onAccepted: {
        console.log("DataStorePickerDialog.onAccepted:  file = " + file)
        DataStoreManager.onFileChooserResultReceived(file.toString().replace(
                                                         urlFilePrefix, ""))
    }
}
