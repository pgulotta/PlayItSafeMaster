import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts


RoundButton {
    Layout.preferredWidth: fabWidth
    Layout.preferredHeight: fabWidth
    highlighted: true
    hoverEnabled: true
    opacity: 1.0

    onClicked: {
        famClose()
        famStartAnimations()
        floatingActionButtonsId.selected(index, fabImageId.source)
    }
    Image {
        id: fabImageId
        anchors.fill: parent
        anchors.margins: fabMargin
        source: model.iconUrl
    }
}
