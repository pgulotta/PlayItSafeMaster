import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    property string websiteLink: ""
    property bool isTitle: false
    property alias text: textId.text
    width: parent.width
    implicitHeight: textId.height
    color: "transparent"
    Text {
        id: textId
        anchors.left: parent.left
        anchors.leftMargin: isTitle ? 0 : largeMargin
        width: parent.width
        Layout.fillWidth: true
        Layout.fillHeight: true
        wrapMode: Label.Wrap
        font.bold: isTitle ? true : false
        color: darkTextColor
        onLinkActivated: {
            if (websiteLink !== "")
                Qt.openUrlExternally(websiteLink)
        }
    }
}
