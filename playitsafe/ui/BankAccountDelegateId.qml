import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import BankAccount 1.0
import SwitchboardCategory 1.0

Component {
    id: listViewDelegateId
    
    Item {
        id: itemId
        implicitHeight: rowRectId.height + rectBorder
        implicitWidth: rowRectId.width
        Rectangle {
            id: rowRectId
            height: field1Id.height + itemMargin
            width: modelListViewId.width
            border.width: rectBorder
            border.color: darkTextColor
            radius: rectRadius
            RowLayout {
                id: rowLayoutId
                anchors {
                    leftMargin: itemMargin
                    left: parent.left
                    rightMargin: itemMargin
                    right: parent.right
                    verticalCenter: parent === null ? undefined : parent.verticalCenter
                }
                TitleTextDark {
                    id: field1Id
                    text: model.bankName
                    width: modelListViewId.width * .40
                    Layout.minimumWidth: width
                    Layout.maximumWidth: width
                    Layout.alignment: Qt.AlignLeft
                }
                TitleTextDark {
                    id: fieldId2
                    text: model.accountNumber
                    width: modelListViewId.width * .35
                    Layout.minimumWidth: width
                    Layout.maximumWidth: width
                    anchors.left: field1Id.right
                }
                TitleTextDark {
                    id: fieldId3
                    text: formatCurrencyString(model.amount)
                    width: modelListViewId.width * .2
                    anchors.right: parent.right
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                setCurrentBankAccount(index)
            }
        }
    }
}
