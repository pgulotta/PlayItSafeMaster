import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "Functions.js" as Functions

Rectangle {
    id: websiteTextId

    signal editableTextChanged(string changedText)

    property alias fieldLabel: labelId.text
    property alias fieldText: textId.text
    property string previousText: ""
    property alias inputValidator: textId.validator
    property bool isTextRequired: false

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
        text: fieldLabel
        width: categoryWidth * 1.25
        topPadding: itemMargin
    }
    Button {
        id: imageButtonId
        anchors {
            topMargin: isSmallScreenDevice ? rectBorder : itemMargin
            top: parent.top
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
        }
        style: ButtonStyle {
            label: Image {
                source: "qrc:/images/www.png"
                fillMode: Image.PreserveAspectFit
            }
            background: Rectangle {
                color: imageButtonId.hovered ? (imageButtonId.pressed ? appToolbarColor : categoryHighlightColor) : "transparent"
            }
        }
        onClicked: {
            if (fieldText !== "")
                Qt.openUrlExternally(Functions.formatUrlink(fieldText))
        }
    }

    TextField {
        id: textId
        font.pointSize: isSmallScreenDevice ? verySmallFontPointSize : smallFontPointSize
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
