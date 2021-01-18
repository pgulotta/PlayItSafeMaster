import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls

Rectangle {
    id: passwordTextId

    signal editableTextChanged(string changedText)

    property alias fieldText: textId.text
    property alias echoMode: textId.echoMode
    property alias copyButtonVisible: copyButtonId.visible
    property string previousText: ""
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
        topPadding: itemMargin
        focus: false
    }
    ToolButton {
        id: copyButtonId
        focus: false
        anchors {
            topMargin: isSmallScreenDevice ? rectBorder : itemMargin
            top: parent.top
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: imageButtonId.left
        }
        icon.source: "qrc:/images/copy.png"

        background: Rectangle {
            color: copyButtonId.hovered ? (copyButtonId.pressed ? appToolbarColor : categoryHighlightColor) : "transparent"
        }

        onClicked: {
            if (fieldText === "")
                return
            var currentEchoMode = textId.echoMode
            textId.echoMode = TextInput.Normal
            textId.selectAll()
            textId.copy()
            textId.echoMode = currentEchoMode
        }
    }
    ToolButton {
        id: imageButtonId
        focus: false
        anchors {
            topMargin: isSmallScreenDevice ? rectBorder : itemMargin
            top: parent.top
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
        }
        icon.source: "qrc:/images/eye.png"

        background: Rectangle {
            color: imageButtonId.hovered ? (imageButtonId.pressed ? appToolbarColor : categoryHighlightColor) : "transparent"
        }

        onClicked: {
            if (fieldText !== "")
                echoMode = (echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password)
        }
    }

    TextField {
        id: textId
        focus: true
        echoMode: TextInput.Password
        font.pointSize: isSmallScreenDevice ? verySmallFontPointSize : smallFontPointSize
        color: darkTextColor
        placeholderText: labelId.text
        anchors {
            left: parent.left
            leftMargin: itemMargin
            right: parent.right
            rightMargin: itemMargin
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: itemMargin * 2
        }

        onActiveFocusChanged: activeFocus ? selectAll() : deselect()

        onTextChanged: {
            if (previousText !== text) {
                editableTextChanged(text)
            }
            previousText = text
        }
        AnimationFadeIn {
            id: fadeInTextId
            target: textId
        }
    }
}
