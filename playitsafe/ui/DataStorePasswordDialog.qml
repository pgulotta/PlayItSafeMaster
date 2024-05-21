import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: dataStorePasswordDialogId
    objectName: "DataStorePasswordDialog"

    property bool isImportDataStore: false
    property string state: "" // "new", "import" "change" "validate"
    readonly property string enterPassword: qsTr("Enter Data Store Password")

    visible: true
    modal: true
    width: Math.min(fieldColumnWidth * 1.75, 400)
    height: dialogHeight
    contentHeight: textWithTitleHeight
    title: getTitle()
    parent: ApplicationWindow.overlay
    x: (parent.width - width) * .5
    y: (parent.height - height) * .5

    standardButtons: Dialog.Cancel | Dialog.Ok
    onAccepted: {
        onPasswordChanged(passwordId.fieldText)
    }
    onRejected: {
        if (stackViewId.currentItem == null)
            Qt.quit()
        else {
            stackViewId.pop()
        }
    }

    Row {
        clip: true
        anchors.fill: parent
        Column {
            id: column

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
                    copyButtonVisible: true
                    onEditableTextChanged: accept()
                }
            }
        }
    }

    Timer {
        id: timerId
    }

    function delay(delayTime, cb) {
        timerId.interval = delayTime
        timerId.repeat = false
        timerId.triggered.connect(cb)
        timerId.start()
    }

    function getTitle() {
        if (state === "validate")
            return enterPassword
        else if (state === "import")
            return qsTr("Data Store Import")
        else if (state === "new")
            return qsTr("Create New Data Store Password")
        else if (state === "change")
            return qsTr("Update Data Store Password")
        else
            return enterPassword
    }

    function doImportPasswordChanged(password) {
        if (DataStoreManager.importDataStore(password)) {
            showTitledMessage(importTitle, importSuccessfulMessage)
        } else {
            showTitledMessage(importTitle, importFailedMessage)
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
            showTitledMessage(
                        qsTr("Data Store Password"),
                        qsTr("Open Data Store failed, password is invalid."))
            delay(2000, function () {
                Qt.quit()
            })
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
            dataStorePasswordDialogId.reject()
            return
        }
        password = password.trim()
        if (password === "") {
            dataStorePasswordDialogId.reject()
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
