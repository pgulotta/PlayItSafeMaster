import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: scrollablePageId

    default property alias content: pane.contentItem

    Flickable {
        anchors.fill: parent
        contentHeight: pane.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded

        Pane {
            id: pane
            width: parent.width
        }

        ScrollIndicator.vertical: ScrollIndicator {
        }
    }
}
