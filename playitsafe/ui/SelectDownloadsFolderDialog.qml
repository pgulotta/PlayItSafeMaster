import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

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