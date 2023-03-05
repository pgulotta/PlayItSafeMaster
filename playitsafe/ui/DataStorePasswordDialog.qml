import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

Dialog {
    id: dataStorePasswordDialogId
    objectName: "DataStorePasswordDialog"

    property bool isImportDataStore: false
    property string state: "" // "new", "import" "change" "validate"
    property int validatePasswordAttemptsCounter: 0

    visible: true
    modal: true
    width: Math.min(fieldColumnWidth * 1.75, 400)
    contentHeight: textWithTitleHeight
    title: getTitle()
    parent: ApplicationWindow.overlay
    x: (parent.width - width) * .5
    y: (parent.height - height) * .5

    standardButtons: Dialog.Cancel | Dialog.Ok
    onAccepted: {
        if (validatePasswordAttemptsCounter > 3) {
            if (stackViewId.currentItem == null)
                Qt.quit()
            else {
                stackViewId.pop()
            }
        } else {
            onPasswordChanged(passwordId.fieldText)
            passwordId.fieldText = ""
        }
    }
    onRejected: {
        if (stackViewId.currentItem == null)
            Qt.quit()
        else {
            stackViewId.pop()
        }
    }

    onOpened: {
        validatePasswordAttemptsCounter += 1
    }

    onClosed: validatePasswordAttemptsCounter = 0

    Row {
        clip: true
        anchors.fill: parent
        Column {
            id: column
            spacing: largeMargin
            width: parent.width
            RowLayout {
                id: rowLayoutId
                anchors.fill: parent
                anchors.right: parent.right
                anchors.rightMargin: largeMargin
                anchors.left: parent.right
                anchors.leftMargin: largeMargin

                PasswordText {
                    id: passwordId
                    Layout.fillWidth: true
                    forceActiveFocus: true
                    visible: validatePasswordAttemptsCounter < 4
                    copyButtonVisible: false
                }

                Label {
                    id: invalidMessagedId
                    wrapMode: Label.Wrap
                    color: negativeNumberColor
                    font.pixelSize: smallFontPointSize
                    Layout.fillWidth: true
                    text: qsTr("Password attempts exceeds maximum. Password validation has failed.")
                    visible: validatePasswordAttemptsCounter > 3
                    onVisibleChanged: fadeInTextId.start()
                    AnimationFadeIn {
                        id: fadeInTextId
                        target: invalidMessagedId
                    }
                }
            }
        }
    }

    function getTitle() {
        validatePasswordAttemptsCounter = 0
        if (state === "validate")
            return qsTr("Enter Data Store Password")
        else if (state === "import")
            return qsTr("Enter Import Data Store Password")
        else if (state === "new")
            return qsTr("Create New Data Store Password")
        else if (state === "change")
            return qsTr("Update Data Store Password")
        else
            return qsTr("Enter Data Store Password")
    }

    function doImportPasswordChanged(password) {
        if (DataStoreManager.importDataStore(password)) {
            showTitledMessage(qsTr("Import Data Store"),
                              qsTr("The import was successful"))
        } else {
            showTitledMessage(
                        qsTr("Import Data Store"), qsTr(
                            "Import failed, perhaps the selected file or password are invalid."))
        }
        stackViewId.clear()
        stackViewId.push("qrc:/ui/SwitchboardPage.qml")
        dataStorePasswordDialogId.close()
        closeAppDrawer()
    }

    function doChangePasswordChanged(successful) {
        if (successful) {
            showTitledMessage(
                        qsTr("Change Data Store Password"),
                        qsTr("Data Store Password was successfully changed."))
        } else {
            dataStorePasswordDialogId.open()
        }
    }

    function doValidatePasswordChanged(successful) {
        if (successful) {
            dataStorePasswordDialogId.enabled = false
            stackViewId.clear()
            stackViewId.push("qrc:/ui/SwitchboardPage.qml")
            dataStorePasswordDialogId.close()
        } else {
            Qt.quit()
        }
    }

    function doNewPasswordChanged(successful) {
        if (successful) {
            stackViewId.clear()
            stackViewId.push("qrc:/ui/SwitchboardPage.qml")
            dataStorePasswordDialogId.close()
        } else {
            dataStorePasswordDialogId.open()
        }
    }

    function onPasswordChanged(password) {
        if (password === undefined || password === null) {
            dataStorePasswordDialogId.open()
            return
        }
        password = password.trim()
        if (password === "") {
            dataStorePasswordDialogId.open()
            return
        }

        if (state === "import") {
            doImportPasswordChanged(password)
            return
        }

        var successful = DataStoreManager.setDataStorePassword(password)

        if (state === "change") {
            doChangePasswordChanged(successful)
        } else if (state === "validate") {
            doValidatePasswordChanged(successful)
        } else if (state === "new") {
            doNewPasswordChanged(successful)
        }
        closeAppDrawer()
    }
}
