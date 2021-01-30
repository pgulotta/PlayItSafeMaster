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
    visible: true
    width: isPortraitMode ? rootId.width * .85 : rootId.width * .4
    folder: urlFilePrefix + downloadsPath
    title: titleText
    onAccepted: {
        console.log("SelectDownloadsFolderDialog:  folder = " + fileUrl)
        DataStoreManager.setDownloadsPath(fileUrl.toString().replace(
                                              urlFilePrefix, ""))
    }
}
