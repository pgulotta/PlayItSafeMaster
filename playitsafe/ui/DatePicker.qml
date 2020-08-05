import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.3

Rectangle {
    id: datePickerId

    signal dateChanged(date dateSelected)

    property alias fieldLabel: labelId.text
    property alias fieldText: textId.text
    property alias dateSelected: calendarPickerId.selectedDate
    property bool isTextRequired: false
    property string previousText: ""
    property alias maximumDate: calendarPickerId.maximumDate

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
        modality: Qt.NonModal
        title: fieldLabel
        onAccepted: {
            dateChanged(dateSelected)
            datePickerDialogId.close()
        }
        onRejected: setSelectedDate()

        contentItem: Calendar {
            id: calendarPickerId
            width: isPortraitMode ? windowWidth * 0.8 : windowWidth * 0.5
            maximumDate: new Date(Date.now())
            Keys.onEnterPressed: datePickerDialogId.accept()
            Keys.onEscapePressed: datePickerDialogId.reject()
            Keys.onBackPressed: datePickerDialogId.reject()
            onDoubleClicked: datePickerDialogId.click(StandardButton.Ok)
            onClicked: datePickerDialogId.click(StandardButton.Ok)

            style: CalendarStyle {
                gridVisible: false
                dayDelegate: Rectangle {
                    gradient: gradientFieldColor

                    Label {
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        font.pointSize: styleData.valid ? ((styleData.selected) ? 4 + smallFontPointSize : smallFontPointSize) : smallFontPointSize
                        font.bold: styleData.valid ? ((styleData.selected) ? true : false) : false
                        color: styleData.valid ? ((styleData.selected) ? actionMenuColor : darkTextColor) : categoryHighlightColor
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: darkTextColor
                        anchors.bottom: parent.bottom
                    }

                    Rectangle {
                        width: 1
                        height: parent.height
                        color: darkTextColor
                        anchors.right: parent.right
                    }
                }
            }
        }
    }

    TitleTextLight {
        id: labelId
        width: categoryWidth * 1.25
        visible: true
        topPadding: itemMargin
    }
    Button {
        id: imageButtonId
        anchors {
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
            topMargin: isSmallScreenDevice ? rectBorder: itemMargin
            top: parent.top
        }
        style: ButtonStyle {
            label: Image {
                source: "qrc:/images/date.png"
                fillMode: Image.PreserveAspectFit
            }
            background: Rectangle {
                color: imageButtonId.hovered ? (imageButtonId.pressed ? appToolbarColor : categoryHighlightColor) : "transparent"
            }
        }
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
