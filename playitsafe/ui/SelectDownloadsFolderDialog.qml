import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

FileDialog {
    id: selectDownloadsFolderDialogId

    property string downloadsPath: ""

    objectName: "SelectDownloadsFolderDialog"
    property string titleText: qsTr("Export/Import Folder")
    visible: true
    width: isPortraitMode ? rootId.width * .85 : rootId.width * .4
    folder: urlFilePrefix + downloadsPath
    selectFolder: true
    title: titleText
    onAccepted: {
        console.log("SelectDownloadsFolderDialog:  folder = " + fileUrl)
        DataStoreManager.setDownloadsPath(fileUrl.toString().replace(
                                              urlFilePrefix, ""))
    }
}
