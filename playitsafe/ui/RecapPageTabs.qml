import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import SwitchboardCategory

Page {
    id: recapPageTabsId
    objectName: "RecapPageTabs"

    visible: true

    // Header with TabBar
    header: TabBar {
        id: tabBarId
        currentIndex: 0

        TabButton {
            text: qsTr("Summary")
        }
        TabButton {
            text: qsTr("Details")
        }
        TabButton {
            text: qsTr("Chart")
        }
    }

    // Content view managed by TabBar
    StackLayout {
        anchors.fill: parent
        currentIndex: tabBarId.currentIndex

        RecapPageSummary {}

        RecapPage {}

        Rectangle {
            color: "blue"
            Label {
                text: "Chart View"
                anchors.centerIn: parent
            }
        }
    }
}
