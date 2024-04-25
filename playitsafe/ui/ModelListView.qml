import QtQuick
import QtQuick.Window
import QtQuick.Controls

ListView {
    id: listViewId

    property alias listViewModel: listViewId.model
    property alias listViewCurrentIndex: listViewId.currentIndex
    property alias listViewDelegate: listViewId.delegate

    width: windowWidth * .96
    height: windowHeight * 0.5

    model: listViewModel
    visible: true
    clip: true
    focus: true
    spacing: rectBorder
    snapMode: ListView.SnapOneItem
    highlightMoveDuration: 5
    delegate: listViewDelegateId

    highlight: Rectangle {
        color: darkTextColor
        radius: rectRadius
    }
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AlwaysOn | ScrollBar.SnapAlways
    }

    onEnabledChanged: {
        enabled ? opacityEnabledId.start() : opacityDisabledId.start()
    }
    OpacityAnimator on opacity {
        id: opacityEnabledId
        from: 0.4
        to: 1.0
        running: false
        duration: shortAnimationDuration
    }
    OpacityAnimator on opacity {
        id: opacityDisabledId
        from: 1.0
        to: 0.4
        running: false
        duration: shortAnimationDuration
    }

    function positionViewAtBeginning() {
        listViewCurrentIndex = -1
        if (!listViewModel.isEmpty())
            listViewCurrentIndex = 0
    }
}
