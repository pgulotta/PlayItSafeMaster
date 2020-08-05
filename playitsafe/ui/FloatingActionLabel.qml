import QtQuick 2.9
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Rectangle {
    id: fabLabelId
    Layout.preferredWidth: labelWidth
    Layout.preferredHeight: famLabelHeight
    radius: 6
    color: famLabelBackColor
    border.color: actionMenuColor
    border.width: rectBorder
    opacity: model.description === "" ? 0 : 1
    Label {
        id: floatingActionLabelId
        text: model.description
        color: actionMenuColor
        Layout.preferredWidth: fabLabelId.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
        elide: Text.ElideRight
        width: fabLabelId.width
        padding: 8
        font.pointSize: fabFontPointSize
    }
}
