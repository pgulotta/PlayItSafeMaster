import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Page {

    visible: true
    width: parent.height
    height: parent.height

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

        Rectangle {
            color: "red"
            Label {
                text: "Summary View"
                anchors.centerIn: parent
            }
        }
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
