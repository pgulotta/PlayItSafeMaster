import QtQuick
import QtQuick.Controls
import QtQuick.Window

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
            //  font.pointSize: smallFontPointSize
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
