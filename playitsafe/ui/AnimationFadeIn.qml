import QtQuick

NumberAnimation {
    property bool longAnimation: true
    running: false
    loops: 1
    property: "opacity"
    from: 0.0
    to: 1.0
    duration: longAnimation ? longAnimationDuration : animationDuration
}
