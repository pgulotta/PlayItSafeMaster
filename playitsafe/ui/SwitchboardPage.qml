import QtQuick
import QtQuick.Controls

GridView {
    id: switchboardPageId
    objectName: "SwitchboardPage"

    cellWidth: categoryWidth + itemMargin
    cellHeight: switchboardHeight + itemMargin
    width: Math.min(model.count, switchboardColumnCount) * cellWidth
    model: AllCategories
    anchors.leftMargin: (windowWidth + itemMargin - (cellWidth * switchboardColumnCount)) / 2
    anchors.topMargin: itemMargin
    anchors.top: parent.top
    opacity: 0

    Component.onCompleted: state = "opening"

    transitions: [
        Transition {
            NumberAnimation {
                target: switchboardPageId
                from: 0
                to: 1
                properties: "opacity"
                duration: longAnimationDuration
                easing.type: Easing.Linear
            }
        }
    ]

    delegate: Component {
        Rectangle {
            id: gridViewDelegateId
            width: categoryWidth
            height: switchboardHeight
            visible: true
            color: getCategoryColor(model.group)
            radius: rectRadius
            readonly property int animationDeltaX: 3

            SequentialAnimation on x {
                id: hoverAnimationId
                running: false
                loops: 1
                NumberAnimation {
                    from: x
                    to: x + animationDeltaX
                    duration: 50
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    from: x + animationDeltaX
                    to: x - animationDeltaX
                    duration: 100
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    from: x - animationDeltaX
                    to: x
                    duration: 50
                    easing.type: Easing.Linear
                }
            }

            MouseArea {
                height: parent.height
                width: parent.width
                hoverEnabled: true
                onClicked: {
                    stackViewId.push(model.pageSource)
                }
                onHoveredChanged: {
                    if (containsMouse)
                        hoverAnimationId.running = true
                    gridViewDelegateId.color
                            = containsMouse ? categoryHighlightColor : getCategoryColor(
                                                  model.group)
                }
            }
            Column {
                id: columnDelegateId
                width: parent.width
                //  spacing: columnRowSpacing
                anchors.fill: parent
                anchors.topMargin: columnRowSpacing
                anchors.bottomMargin: columnRowSpacing
                SelectableImage {
                    id: selectableImageId
                    source: model.imageSource
                    height: categoryWidth * .96
                    width: height
                    anchors.horizontalCenter: columnDelegateId.horizontalCenter
                }
                Label {
                    text: model.title
                    font.pointSize: switchboardFontPointSize
                    color: darkTextColor
                    wrapMode: Label.WordWrap
                    width: categoryWidth
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
