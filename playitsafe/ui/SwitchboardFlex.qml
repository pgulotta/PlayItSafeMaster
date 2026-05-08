import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SwitchboardCategory

Page {
    id: switchboardFlexId
    objectName: "SwitchboardFlex"

    visible: true
    width: rootId.width
    height: rootId.height

    readonly property int animationDeltaX: 3
    property real rectWidth: width * .3
    property real rectHeight: rectWidth * 1.1

    FlexboxLayout {
        id: flexLayout
        anchors.fill: parent
        wrap: FlexboxLayout.Wrap
        direction: FlexboxLayout.Row
        alignItems: FlexboxLayout.AlignCenter
        justifyContent: FlexboxLayout.JustifySpaceAround
        alignContent: FlexboxLayout.AlignStretch

        SwitchboardRectangle {
            category: AllCategories.get(SwitchboardCategory.BankAccount)
        }

        SwitchboardRectangle {
            category: AllCategories.get(SwitchboardCategory.Investment)
        }
        SwitchboardRectangle {
            category: AllCategories.get(SwitchboardCategory.RealAsset)
        }
        SwitchboardRectangle {
            category: AllCategories.get(SwitchboardCategory.Expense)
        }
        SwitchboardRectangle {
            category: AllCategories.get(SwitchboardCategory.Website)
        }
        SwitchboardRectangle {
            category: AllCategories.get(SwitchboardCategory.Recap)
        }
    }
}
