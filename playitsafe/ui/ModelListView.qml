import QtQuick
import QtQuick.Window
import QtQuick.Controls

ListView {
    id: listViewId

    property alias listViewModel: listViewId.model
    property alias listViewCurrentIndex: listViewId.currentIndex
    property alias listViewDelegate: listViewId.delegate

    height: listViewHeight
    width: listViewWidth
    model: listViewModel
    visible: true
    clip: false
    focus: true
    spacing: rectBorder
    snapMode: ListView.SnapOneItem
    delegate: listViewDelegateId

    highlight: Rectangle {
        color: darkTextColor
        radius: rectRadius
    }
    ScrollBar.vertical: ScrollBar {
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
