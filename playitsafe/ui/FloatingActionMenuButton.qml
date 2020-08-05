import QtQuick 2.9
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Rectangle {
    id: famRowId

    signal selected(bool famIsClosed, string buttonImage)

    property alias floatingActionMenuDownRotation: famDownRotationId
    property alias floatingActionMenuUpRotation: famUpRotationId
    property alias floatingActionMenuAnimation: famAnimationId
    property int animationDuration: 300

    implicitWidth: roundButtonId.width
    implicitHeight: roundButtonId.height
    color: "transparent"

    RoundButton {
        id: roundButtonId
        highlighted: true
        hoverEnabled: true
        opacity: 1.0
        width:fabWidth
        height: width
        onClicked: {
            famToggleOpenClose()
            famStartAnimations()
            famRowId.selected(famIsClosed(), famImage)
        }

        Image {
            id: famImageId
            anchors.centerIn: parent
            source: famImage
            height: 32
            width: 32
            AnimationCircularRotation {
                id: famDownRotationId
                target: famImageId
                partialRotation: true
            }

            AnimationCircularRotation {
                id: famUpRotationId
                target: famImageId
            }

            AnimationFadeIn {
                id: famAnimationId
                target: famImageId
            }
        }
    }
}
