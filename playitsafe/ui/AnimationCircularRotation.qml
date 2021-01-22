import QtQuick

RotationAnimator {
    property bool partialRotation: false

    id: circularRotationId
    running: false
    easing.type: Easing.Linear
    from: partialRotation ? 0 : 360
    to: partialRotation ? 270 : 0
    duration: shortAnimationDuration
}
