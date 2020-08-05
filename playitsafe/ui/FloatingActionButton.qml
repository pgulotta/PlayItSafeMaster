import QtQuick 2.9
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1


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
