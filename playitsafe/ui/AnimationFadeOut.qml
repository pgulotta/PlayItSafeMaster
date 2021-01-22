import QtQuick

NumberAnimation {
    property bool longAnimation: true
    running: false
    loops: 1
    property: "opacity"
    from: 1.0
    to: 0.0
    duration: longAnimation ? longAnimationDuration : animationDuration
}
