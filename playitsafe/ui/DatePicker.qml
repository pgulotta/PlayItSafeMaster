import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "Functions.js" as Functions

Rectangle {
    id: datePickerControlId

    signal dateChanged(date dateChanged)

    property string fieldLabel
    property var dateSelected: new Date()
    property var maximumDate
    property bool isTextRequired: true

    width: fieldColumnWidth
    height: textWithTitleHeight
    radius: rectRadius
    color: fieldBackColor
    state: isTextRequired && textId.text.trim(
               ).length === 0 ? "" : validDataState
    border.color: isTextRequired ? requiredTextColor : darkTextColor
    border.width: isTextRequired ? fieldRectBorder : rectBorder

    onDateSelectedChanged: {
        if (dateSelected === undefined)
            dateSelected = new Date()
        else
            textId.text = Functions.formatDate(dateSelected)
    }

    Dialog {
        id: datePickerDialogId
        title: fieldLabel
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 250
        height: 250
        modal: true
        onAccepted: {
            dateSelected = datePickerCalendarId.get()
            dateChanged(dateSelected)
        }
        onRejected: datePickerCalendarId.set(dateSelected)
        onOpened: datePickerCalendarId.set(dateSelected)

        DatePickerCalendar {
            id: datePickerCalendarId
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
        id: imageButtonId
        anchors {
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
            topMargin: isSmallScreenDevice ? rectBorder : itemMargin
            top: parent.top
        }
        icon.source: "qrc:/images/date.png"
        icon.color: lightTextColor
        onClicked: {
            datePickerDialogId.open()
        }
    }

    TextField {
        id: textId
        Layout.fillWidth: true
        enabled: true
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

        MouseArea {
            anchors.fill: parent
            onClicked: datePickerDialogId.open()
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
