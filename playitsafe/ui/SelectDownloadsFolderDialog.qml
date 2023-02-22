import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.platform 1.1

FolderDialog {
    id: selectDownloadsFolderDialogId

    property string downloadsPath: ""

    objectName: "SelectDownloadsFolderDialog"
    property string titleText: qsTr("Export/Import Folder")
    options: FolderDialog.ShowDirsOnly
    visible: true
    folder: urlFilePrefix + downloadsPath
    title: titleText
    onAccepted: {
        console.log("SelectDownloadsFolderDialog:  folder = " + folder.toString(
                        ))
        DataStoreManager.setDownloadsPath(folder.toString().replace(
                                              urlFilePrefix, ""))
    }
}
