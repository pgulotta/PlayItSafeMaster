import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "Functions.js" as Functions

Rectangle {
    id: datePickerControlId

    signal dateChanged(date dateChanged)

    property string fieldLabel
    property var selectedDate: new Date()
    //property var maximumDate
    property bool isTextRequired: true
    property date previousDateText: new Date()

    width: fieldColumnWidth
    height: textWithTitleHeight
    radius: rectRadius
    color: fieldBackColor
    state: isTextRequired && textId.text.trim(
               ).length === 0 ? "" : validDataState
    border.color: isTextRequired ? requiredTextColor : darkTextColor
    border.width: isTextRequired ? fieldRectBorder : rectBorder

    onSelectedDateChanged: {
        if (selectedDate === undefined)
            selectedDate = new Date()

        textId.text = Functions.formatDateToString(selectedDate)
    }

    Dialog {
        id: dateEditDialogId
        title: fieldLabel
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 250
        height: 250
        modal: true
        onAccepted: {
            var acceptedDate = new Date(dateTextInputId.text)
            selectedDate = acceptedDate
            dateChanged(selectedDate)
        }
        onRejected: dateTextInputId.set(selectedDate)

        //    onOpened: dateTextInputId.set(selectedDate)
        TextInput {
            id: dateTextInputId

            inputMethodHints: Qt.ImhDate

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

            function set(dateText) {
                previousDateText = dateText
                dateTextInputId.text = Functions.formatDateToString(
                            new Date(dateText))
            }
        }

        AnimationFadeIn {
            id: fadeInTextId
            target: textId
        }
    }

    TitleTextLight {
        id: labelId
        text: fieldLabel
        width: categoryWidth * 1.25
        visible: true
        topPadding: itemMargin
    }

    ToolButton {
        id: editButtonId
        anchors {
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
        }
        icon.source: "qrc:/images/edit.png"
        width: buttonImageSize
        height: buttonImageSize
        icon.color: lightTextColor
        onClicked: {
            dateTextInputId.set(selectedDate)
            dateEditDialogId.open()
        }
    }

    TextField {
        id: textId
        Layout.fillWidth: true
        enabled: false
        readOnly: true
        font.pointSize: smallFontPointSize
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
    }

    property Gradient gradientFieldColor: Gradient {
        GradientStop {
            color: fieldBackColor
            position: 0
        }
        GradientStop {
            color: itemBackColor
            position: 0.25
        }
        GradientStop {
            color: itemBackColor
            position: 1
        }
    }
}
