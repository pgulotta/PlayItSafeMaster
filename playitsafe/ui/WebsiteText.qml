import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "Functions.js" as Functions

Rectangle {
    id: websiteTextId

    signal editableTextChanged(string changedText)

    property alias fieldLabel: labelId.text
    property alias fieldText: textId.text
    property string previousDateText: ""
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
    ToolButton {
        id: imageButtonId
        z: 1
        anchors {
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
        }
        icon.source: "qrc:/images/www.png"
        icon.color: lightTextColor
        width: buttonImageSize
        height: buttonImageSize
        onClicked: {
            if (fieldText !== "")
                Qt.openUrlExternally(Functions.formatUrlink(fieldText))
        }
    }

    TextField {
        id: textId
        color: darkTextColor
        placeholderText: fieldLabel
        anchors {
            left: parent.left
            leftMargin: itemMargin
            right: parent.right
            rightMargin: itemMargin
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: itemMargin * 2
        }

        onActiveFocusChanged: deselect()
        onTextChanged: {
            if (previousDateText !== text) {
                editableTextChanged(text)
            }
            previousDateText = text
        }
        AnimationFadeIn {
            id: fadeInTextId
            target: textId
        }
    }
}
