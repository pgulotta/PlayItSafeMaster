import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SwitchboardCategory

ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 640
    title: "QML Flexbox Layout"
    color: "green"
    FlexboxLayout {
        id: flexLayout
        anchors.fill: parent

        wrap: FlexboxLayout.Wrap
        direction: FlexboxLayout.Row
        alignItems: FlexboxLayout.AlignCenter
        justifyContent: FlexboxLayout.JustifySpaceAround
        alignContent: FlexboxLayout.AlignStretch

        Rectangle {
            color: 'teal'
            Text {
                text: AllCategories.get(SwitchboardCategory.BankAccount).title

                //  text: qsTr("teal")
            }
            implicitWidth: 100
            implicitHeight: 100
        }
        Rectangle {
            color: 'plum'
            implicitWidth: 100
            implicitHeight: 100
            Text {
                text: qsTr("plum")
            }
        }
        Rectangle {
            color: 'olive'
            implicitWidth: 100
            implicitHeight: 100
            Text {
                text: qsTr("olive")
            }
        }
        Rectangle {
            color: 'beige'
            implicitWidth: 100
            implicitHeight: 100
            Text {
                text: qsTr("beige")
            }
        }
        Rectangle {
            color: 'darkseagreen'
            implicitWidth: 100
            implicitHeight: 100
            Text {
                text: qsTr("darkseagreen")
            }
        }
    }
}
