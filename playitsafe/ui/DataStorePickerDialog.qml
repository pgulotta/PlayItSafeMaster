import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

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
