import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Particles
import ImportFileNotification
import PdfCreatedNotification

Drawer {
    id: appDrawerId
    objectName: "MainDrawer"
    width: drawerWidth
    height: rootId.height

    ImportFileNotification {
        id: importFileId
        importFilePath: ImportedFile.importFilePath
        onImportFilePathChanged: doImportFilePathChanged(this.importFilePath)
    }

    PdfCreatedNotification {
        id: pdfFileId
        pdfFilePath: SavedPdfFile.pdfFilePath
        onPdfFilePathChanged: doPdfFileCreated(SavedPdfFile.pdfFilePath)
    }

    Component {
        id: drawerHeaderId
        Rectangle {
            id: headerRectId
            width: drawerWidth
            height: isPortraitMode ? appDrawerId.height * .25 : drawerWidth * .5

            Image {
                width: parent.width
                height: parent.height
                fillMode: Image.Stretch
                source: "qrc:/images/drawerheader.jpg"
                opacity: .75
            }
            Column {
                width: parent.width
                spacing: itemMargin
                anchors.fill: parent
                anchors.top: headerRectId.top
                anchors.topMargin: mediumMargin
                Item {
                    id: fillerId
                    height: toolbarHeight
                    width: parent.width
                    visible: true
                }
                TitleTextDark {
                    text: qsTr("Play")
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: largeFontPointSize
                }
                TitleTextDark {
                    text: qsTr("It")
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: largeFontPointSize
                }
                TitleTextDark {
                    text: qsTr("Safe")
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: largeFontPointSize
                }
            }
        }
    }

    Component {
        id: itemDelegateId
        Item {
            id: itemId
            width: parent.width
            height: listViewDelegateHeight

            Text {
                id: textDelegateId
                width: parent.width - 100
                height: listViewDelegateHeight
                anchors.leftMargin: largeIndent
                anchors.left: parent.left
                //  font.pointSize: smallFontPointSize
                text: model.text
                color: darkTextColor
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onHoveredChanged: textDelegateId.font.bold = containsMouse ? true : false
                    onClicked: onSelected(model.text)
                }
            }
        }
    }
    ListView {
        id: drawerListViewId
        currentIndex: -1
        anchors.fill: parent
        header: drawerHeaderId
        clip: true
        focus: true
        snapMode: ListView.SnapToItem
        section.property: "category"
        section.delegate: Pane {
            width: drawerListViewId.width
            height: toolbarHeight
            TitleTextDark {
                id: sectionLabelId
                text: section
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
            }
        }

        delegate: itemDelegateId

        model: ListModel {
            id: listModelId
            ListElement {
                category: qsTr("About")
                text: qsTr("About")
            }
            ListElement {
                category: qsTr("Manage Data Store")
                text: qsTr("Change Password")
            }
            ListElement {
                category: qsTr("Manage Data Store")
                text: qsTr("Export")
            }
            ListElement {
                category: qsTr("Manage Data Store")
                text: qsTr("Import")
            }
            ListElement {
                category: qsTr("Manage Data Store")
                text: qsTr("Clear")
            }

            ListElement {
                category: qsTr("Manage Data Store")
                text: qsTr("Save as PDF")
            }
            ListElement {
                category: qsTr("Investment Prices")
                text: qsTr("App Startup")
            }
            ListElement {
                category: qsTr("Investment Prices")
                text: qsTr("Refresh Now")
            }
            ListElement {
                category: qsTr("Close")
                text: qsTr("App Drawer")
            }
            ListElement {
                category: qsTr("Close")
                text: qsTr("App Exit")
            }
        }
    }

    function onSelected(text) {
        switch (text) {
        case qsTr("Change Password"):
            loaderId.source = ""
            loaderId.source = "qrc:/ui/DataStorePasswordDialog.qml"
            loaderId.item.state = "change"
            loaderId.item.contentHeight = 220
            loaderId.item.visible = true
            appDrawerId.close()
            break
        case qsTr("App Startup"):
            loaderId.source = ""
            loaderId.source = "qrc:/ui/SettingsUpdatePricesDialog.qml"
            loaderId.item.visible = true
            break
        case qsTr("Clear"):
            loaderId.source = "qrc:/ui/DataStoreClearDialog.qml"
            loaderId.item.doExport = false
            loaderId.item.visible = true
            break
        case qsTr("Export"):
            doExport()
            break
        case qsTr("Import"):
            getImportFilePath()
            break
        case qsTr("Save as PDF"):
            loaderId.source = "qrc:/ui/SaveToPdfDialog.qml"
            loaderId.item.visible = true
            break
        case qsTr("Refresh Now"):
            DataStoreManager.freshInvestmentPrices()
            appDrawerId.close()
            break
        case qsTr("About"):
            stackViewId.push("qrc:/ui/AboutPage.qml")
            appDrawerId.close()
            break
        case qsTr("App Drawer"):
            appDrawerId.close()
            break
        case qsTr("App Exit"):
            Qt.quit()
            break
        default:
            console.assert("Invalid unsupported setting")
        }
    }

    Loader {
        id: loaderId
    }

    DataStorePasswordDialog {
        id: importPasswordDialogId
        visible: false
    }

    UseSamePasswordDialog {
        id: useSamePasswordDialogId
        visible: false
        onAccepted: if (DataStoreManager.importDataStore()) {
                        showTitledMessage(importTitle, importSuccessfulMessage)
                    } else {
                        showTitledMessage(importTitle, importFailedMessage)
                    }
        onRejected: {
            importPasswordDialogId.state = "import"
            importPasswordDialogId.visible = true
        }
    }

    function doPdfFileCreated(pdfFilePath) {
        if (pdfFilePath === "")
            return
        var message = (pdfFilePath === ImportedFile.unresolvedFilePathId) ? qsTr("Failed to save Data Store to a Pdf") : qsTr("Data Store saved to Pdf as \n") + pdfFilePath
        showTitledMessage(qsTr("Save to Pdf"), message)
    }

    function doImportFilePathChanged(importFilePath) {
        if (importFilePath === "")
            return
        if (importFilePath === ImportedFile.unresolvedFilePathId) {
            showTitledMessage(
                        importTitle, qsTr(
                            "Data Store was not imported. The selected Data Store path cannot be resolved."))
        } else {
            useSamePasswordDialogId.visible = true
        }
    }

    function getImportFilePath() {
        loaderId.source = "qrc:/ui/DataStorePickerDialog.qml"
        loaderId.item.downloadsPath = DataStoreManager.downloadsPath
        loaderId.item.visible = true
    }

    function doExport() {
        var filePath = DataStoreManager.exportDataStore()
        if (filePath === "") {
            showTitledMessage(qsTr("Export Unsuccessful"),
                              qsTr("Failed to export Data Store."))
        } else {
            showTitledMessage(qsTr("Export Successful"),
                              qsTr("Exported to: \n" + filePath))
        }
        appDrawerId.close()
    }
}
