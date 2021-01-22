import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Repeater {
    id: floatingActionButtonsId

    signal selected(int modelIndex, string buttonImage)

    RowLayout {
        id: fabsRowId
        state: famRootId.state

        states: [
            State {
                name: famOpenState
                PropertyChanges {
                    target: fabsRowId
                    opacity: 1
                }
                PropertyChanges {
                    target: fabsRowId
                    enabled: true
                }
            },
            State {
                name: famCloseState
                PropertyChanges {
                    target: fabsRowId
                    opacity: 0
                }
                PropertyChanges {
                    target: fabsRowId
                    enabled: false
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    properties: "opacity"
                    duration: famIsClosed() ? 100 * (floatingActionButtonsId.model.count
                                                    - index) : 100 * index
                    easing.type: Easing.Linear
                }
            }
        ]

        FloatingActionLabel {
            id: labelButtonId
            visible: true
        }
        FloatingActionButton {
            id: fabId
        }
    }

}
