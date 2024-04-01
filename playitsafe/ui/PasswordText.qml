import QtQuick
import QtQuick.Controls

Rectangle {
    id: passwordTextId

    signal editableTextChanged(string changedText)

    property alias fieldText: textId.text
    property alias echoMode: textId.echoMode
    property alias copyButtonVisible: copyButtonId.visible

    property string previousDateText: ""
    property bool isTextRequired: false
    property bool forceActiveFocus: false

    width: fieldColumnWidth
    implicitHeight: textWithTitleHeight
    radius: rectRadius
    color: fieldBackColor
    state: isTextRequired && textId.text.trim(
               ).length === 0 ? "" : validDataState
    border.color: isTextRequired ? requiredTextColor : darkTextColor
    border.width: isTextRequired ? fieldRectBorder : rectBorder

    Component.onCompleted: {
        fadeInTextId.start()
        if (forceActiveFocus)
            textId.forceActiveFocus()
    }

    TitleTextLight {
        id: labelId
        text: qsTr("Password")
        width: categoryWidth * 1.25
    }
    ToolButton {
        id: copyButtonId
        anchors {
            rightMargin: copyButtonId.width
            right: eyeButtonId.right
        }
        icon.source: "qrc:/images/copy.png"
        icon.color: lightTextColor
        width: buttonImageSize
        height: buttonImageSize
        onClicked: {
            if (fieldText === "")
                return
            var currentEchoMode = textId.echoMode
            textId.echoMode = TextInput.Normal
            textId.selectAll()
            textId.copy()
            textId.echoMode = currentEchoMode
            textId.forceActiveFocus()
            textId.deselect()
        }
    }
    ToolButton {
        id: eyeButtonId
        anchors {
            right: parent.right
        }
        icon.source: "qrc:/images/eye.png"
        icon.color: lightTextColor
        width: buttonImageSize
        height: buttonImageSize
        onClicked: {
            if (fieldText !== "")
                echoMode = (echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password)
            textId.forceActiveFocus()
            textId.deselect()
        }
    }

    TextInput {
        id: textId

        echoMode: TextInput.Password
        color: darkTextColor

        height: listViewDelegateHeight
        anchors {
            left: parent.left
            leftMargin: itemIndent
            right: parent.right
            rightMargin: itemIndent
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: itemMargin * 2
        }
        onActiveFocusChanged: activeFocus ? selectAll() : deselect()

        onAccepted: editableTextChanged(text)

        AnimationFadeIn {
            id: fadeInTextId
            target: textId
        }
    }
}
