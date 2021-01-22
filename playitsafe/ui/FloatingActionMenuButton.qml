import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

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
        width: fabWidth
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
            height: 40
            width: 40
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
