import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.3

Button {
    id: addButtonId

    signal buttonSelected

    property string textColor: lightTextColor

    width: buttonDimension
    height: buttonDimension

    style: ButtonStyle {
        background: Rectangle {
            color: "transparent"
            visible: false
        }
        label: Text {
            text: "   +   "
            color: textColor
            font.pointSize: smallFontPointSize
            font.bold: true
            anchors.top: parent.top
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: textColor = containsMouse ? darkTextColor : lightTextColor
        onClicked: buttonSelected()
    }
}
