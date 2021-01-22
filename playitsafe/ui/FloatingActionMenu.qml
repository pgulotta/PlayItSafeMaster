import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Column {
    readonly property string famCloseState: "close"
    readonly property string famOpenState: "open"

    property int famWidth: 76
    property int famMargin: famWidth * .2
    property int fabWidth: famWidth * .7
    property int fabMargin: fabWidth * .2
    property int labelWidth: categoryWidth
    property string famImage: "qrc:/images/more.png"
    property string famLabelBackColor: itemBackColor
    property ListModel fabModel: null
    property int famHeight: fabsId.model === null || fabsId.model.count
                            === 0 ? famWidth + famMargin : famWidth * fabsId.model.count + famMargin
    property int famLabelHeight: fabWidth - 2 * fabMargin

    property alias fabsState: fabsId.state
    property alias floatingActionMenuUpRotation: famsUpId.floatingActionMenuUpRotation
    property alias floatingActionMenuDownRotation: famsUpId.floatingActionMenuDownRotation

    signal menuItemSelected(bool isClosed, string buttonImage)
    signal buttonItemSelected(int modelIndex, string buttonImage)

    id: famRootId
    visible: true
    width: famWidth + labelWidth
    height: famHeight
    anchors.right: parent.right
    anchors.rightMargin: famMargin
    anchors.bottom: parent.bottom
    anchors.bottomMargin: fabWidth
    state: "close"

    Component.onCompleted: famStartAnimations()

    FloatingActionButtons {
        id: fabsId
        model: fabModel
        state: "view"
        onSelected: buttonItemSelected(modelIndex, buttonImage)
        states: [
            State {
                name: "new"
                PropertyChanges {
                    target: fabsId
                    model: newItemModelId
                }
            },
            State {
                name: "view"
                PropertyChanges {
                    target: fabsId
                    model: viewingModelItemId
                }
            },
            State {
                name: "update"
                PropertyChanges {
                    target: fabsId
                    model: updatingModelItemId
                }
            }
        ]
    }

    FloatingActionMenuButton {
        id: famsUpId
        visible: true
        onSelected: menuItemSelected(famIsClosed, buttonImage)
        anchors.right: parent.right
        anchors.rightMargin: famMargin
    }

    ListModel {
        id: viewingModelItemId
        ListElement {
            description: qsTr("Add New")
            iconUrl: "qrc:/images/add.png"
        }
        ListElement {
            description: qsTr("Remove Current")
            iconUrl: "qrc:/images/remove.png"
        }
    }

    ListModel {
        id: updatingModelItemId
        ListElement {
            description: qsTr("Save Changes")
            iconUrl: "qrc:/images/save.png"
        }
        ListElement {
            description: qsTr("Cancel Changes")
            iconUrl: "qrc:/images/cancel.png"
        }
    }

    ListModel {
        id: newItemModelId
        ListElement {
            description: qsTr("Add New")
            iconUrl: "qrc:/images/add.png"
        }
    }

    function setActionButtonsState(isDirty) {
        if (isDirty) {
            fabsState = "update"
        } else {
            fabsState = fabsId.model === null
                    || fabsId.model.count === 0 ? fabsState = "new" : fabsState = "view"
        }
    }

    function famIsOpen() {
        return famRootId.state === famOpenState
    }

    function famIsClosed() {
        return famRootId.state === famCloseState
    }

    function famOpen() {
        famRootId.state = famOpenState
    }

    function famClose() {
        famRootId.state = famCloseState
    }

    function famToggleOpenClose() {
        famRootId.state = famRootId.state === famCloseState ? famOpenState : famCloseState
    }

    function famStartAnimations() {
        if (famIsClosed())
            floatingActionMenuDownRotation.start()
        else
            floatingActionMenuUpRotation.start()
    }
}
