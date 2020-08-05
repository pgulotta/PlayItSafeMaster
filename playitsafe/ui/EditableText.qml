import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: editableTextId

    signal editableTextChanged(string changedText)

    property alias fontCapitaliztion: textId.font.capitalization
    property alias fieldLabel: labelId.text
    property alias fieldText: textId.text
    property alias inputHints: textId.inputMethodHints
    property alias echoMode: textId.echoMode
    property alias inputValidator: textId.validator
    property bool isTextRequired: false
    property string previousText: ""

    width: fieldColumnWidth
    height: textWithTitleHeight
    radius: rectRadius
    color: fieldBackColor
    state: isTextRequired && textId.text.trim(
               ).length === 0 ? "" : validDataState
    border.color: isTextRequired ? requiredTextColor : darkTextColor
    border.width: isTextRequired ? fieldRectBorder : rectBorder

    Component.onCompleted: fadeInTextId.start()

    TitleTextLight {
        id: labelId
        width: categoryWidth * 1.25
        visible: true
        topPadding: itemMargin
    }

    TextField {
        id: textId
        Layout.fillWidth: true
        font.pointSize: smallFontPointSize
        textColor: darkTextColor
        placeholderText: fieldLabel
        anchors {
            left: parent.left
            leftMargin: itemMargin
            right: parent.right
            rightMargin: itemMargin
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: itemMargin * 2
        }
        style: TextFieldStyle {
            background: Rectangle {
                radius: rectRadius
                border.width: rectBorder
                border.color: darkTextColor
                height: textId.height
            }
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
