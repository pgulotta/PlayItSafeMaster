import QtQuick 2.9
import QtQuick.Controls
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Rectangle {
    id: datePickerId

    signal dateChanged(date dateSelected)

    property string fieldLabel
    property string fieldText
    property bool isTextRequired: false
    property string previousText: ""
    property var dateSelected
    property var maximumDate

    width: fieldColumnWidth
    height: textWithTitleHeight
    radius: rectRadius
    color: fieldBackColor
    state: isTextRequired && textId.text.trim(
               ).length === 0 ? "" : validDataState
    border.color: isTextRequired ? requiredTextColor : darkTextColor
    border.width: isTextRequired ? fieldRectBorder : rectBorder
    Component.onCompleted: fadeInTextId.start()

    Dialog {
        id: datePickerDialogId
        title: fieldLabel
        onAccepted: {
            dateChanged(dateSelected)
            datePickerDialogId.close()
        }
        onRejected: setSelectedDate()
    }

    TitleTextLight {
        id: labelId
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

        onClicked: {
            setSelectedDate()
            datePickerDialogId.open()
            fadeInCalendartId.start()
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
            onClicked: {
                setSelectedDate()
                datePickerDialogId.open()
                fadeInCalendartId.start()
            }
        }
        AnimationFadeIn {
            id: fadeInTextId
            target: textId
        }
        AnimationFadeIn {
            id: fadeInCalendartId
            target: calendarPickerId
            longAnimation: false
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

    function setSelectedDate() {
        dateSelected = Date.fromLocaleString(Qt.locale(), fieldText,
                                             "dd MMM yyyy")
        datePickerDialogId.close()
    }
}
