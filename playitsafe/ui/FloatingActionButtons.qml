import QtQuick 2.9
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

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
