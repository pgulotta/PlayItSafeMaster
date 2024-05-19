import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Recap
import InvestmentPriceNotification
import SwitchboardCategory

import "Functions.js" as Functions

Page {
    id: recapPageId
    objectName: "RecapPage"

    property real field1Width: width * 0.3
    property real field2Width: width * 0.4
    property real amountWidth: width * 0.15
    property real checkboxWidth: width * 0.1

    property real sectionTextHeight: toolbarHeight * .8
    readonly property int animationDeltaX: 3
    property alias recapList: modelListViewId.listViewModel
    property alias recapListIndex: modelListViewId.listViewCurrentIndex
    property double summaryTotal
    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.Recap)

    //   readonly property string assetsCategoryColor: getCategoryColor(0)
    readonly property string assetsCategoryColor: getCategoryColor(
                                                      SwitchboardCategory.Asset)
    readonly property string assetsColor: Qt.lighter(
                                              getCategoryColor(
                                                  SwitchboardCategory.Asset))
    readonly property string expensesCateoryColor: getCategoryColor(
                                                       SwitchboardCategory.Liability)
    readonly property string expensesColor: Qt.lighter(
                                                getCategoryColor(
                                                    SwitchboardCategory.Liability),
                                                1.2)

    visible: true

    onVisibleChanged: {
        if (visible) {
            initializeToolbar(true, category.title)
            calcSummaryTotal()
        }
    }

    Component.onCompleted: {
        initializeToolbar(true, category.title)
        clearEnabled()
        calcSummaryTotal()
        modelListViewId.forceActiveFocus()
    }

    InvestmentPriceNotification {
        id: investmentPriceNotificationId
        updateSuccess: InvestmentPriceUpdate.updateSuccess
        onUpdateSuccessChanged: calcSummaryTotal()
    }

    Rectangle {
        id: recapRectId
        height: parent.height
        width: parent.width
        color: appBackColor
        anchors.fill: parent
    }
    ScrollView {
        anchors.fill: parent
        ModelListView {
            id: modelListViewId
            listViewModel: RecapList
            anchors.fill: parent
            anchors.margins: isSmallScreenDevice ? itemMargin : itemIndent
            listViewDelegate: listViewDelegateId
            headerPositioning: ListView.InlineHeader
            header: Rectangle {
                id: summaryRectId
                radius: rectRadius
                width: modelListViewId.width
                height: textWithTitleHeight * .95
                color: categoryRecapColor
                border.color: darkTextColor
                border.width: rectBorder
                TitleTextDark {
                    id: summaryTotalId
                    anchors.centerIn: parent
                    text: Functions.formatCurrencyString(summaryTotal)
                    color: summaryTotal < 0 ? negativeNumberColor : darkTextColor
                }
            }

            section {
                id: listViewSectionId
                property: "section"
                labelPositioning: ViewSection.InlineLabels
                delegate: Rectangle {
                    id: listViewSectionDelegateId
                    width: modelListViewId.width
                    implicitHeight: sectionTitleId.height
                    color: (sectionTitleId.text
                            == "Expenses") ? expensesCateoryColor : assetsCategoryColor
                    radius: rectRadius
                    border.color: darkTextColor
                    border.width: rectBorder

                    TitleTextLight {
                        id: sectionTitleId
                        text: section
                        anchors.centerIn: parent
                        height: sectionTextHeight
                    }
                    MouseArea {
                        id: sectionMouseAreaId
                        z: 1
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            DataStoreManager.toggleRecapSectionEnabled(
                                        sectionTitleId.text)
                            calcSummaryTotal()
                        }
                        onHoveredChanged: {
                            if (containsMouse)
                                hoverAnimationId.running = true
                        }
                    }
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
                }
            }
        }
    }
    Component {
        id: listViewDelegateId
        Item {
            id: itemId
            height: rowRectId.height + rectBorder
            width: modelListViewId.width
            states: State {
                name: "Current"
                when: !itemId.ListView.isCurrentItem
                PropertyChanges {
                    target: itemId
                    opacity: 0.8
                }
            }
            transitions: Transition {
                NumberAnimation {
                    properties: "opacity"
                    duration: shortAnimationDuration
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: itemId.ListView.view.currentIndex = index
            }
            Rectangle {
                id: rowRectId
                height: field1Id.height + itemMargin
                width: modelListViewId.width
                border.width: rectBorder
                border.color: darkTextColor
                radius: rectRadius
                color: (section == "Expenses") ? expensesColor : assetsColor
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        modelListViewId.currentIndex = index
                    }
                    onPressAndHold: displayDetails(model.sectionUrl, index)
                    onDoubleClicked: displayDetails(model.sectionUrl, index)
                }
                RowLayout {
                    anchors {
                        leftMargin: itemMargin
                        left: parent.left
                        rightMargin: itemMargin
                        right: parent.right
                        verticalCenter: parent === null ? undefined : parent.verticalCenter
                    }
                    TitleTextDark {
                        id: field1Id
                        text: model.title
                        Layout.fillHeight: true
                        Layout.preferredWidth: field1Width
                    }
                    TitleTextDark {
                        id: fieldId2
                        text: model.description
                        Layout.preferredWidth: field2Width
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    TitleTextDark {
                        id: fieldId3
                        text: Functions.formatCurrencyString(model.amount)
                        clip: true
                        width: amountWidth
                        Layout.alignment: Qt.AlignRight
                        color: model.amount < 0 ? negativeNumberColor : darkTextColor
                    }
                    Text {
                        id: uniqueId
                        visible: false
                        text: model.uniqueId
                        verticalAlignment: Text.AlignBottom
                    }
                    Text {
                        visible: false
                        text: model.enabled
                        onTextChanged: rowSelectedId.checked = model.enabled
                    }
                    CheckBox {
                        id: rowSelectedId
                        width: checkboxWidth
                        Layout.alignment: Qt.AlignRight
                        onClicked: {
                            DataStoreManager.toggleRecapRowEnabled(
                                        uniqueId.text)
                            calcSummaryTotal()
                        }
                    }
                }
            }
        }
    }

    function displayDetails(sectionUrl, listIndex) {
        stackViewId.push({
                             "item": sectionUrl,
                             "properties": {
                                 "initialUniqueId": recapList.get(
                                                        listIndex).uniqueId
                             }
                         })
    }

    function clearEnabled() {
        for (var i = 0; i < recapList.size(); i++) {
            var item = recapList.get(i)
            item.enabled = true
        }
    }

    function calcSummaryTotal() {
        summaryTotal = 0
        for (var i = 0; i < recapList.size(); i++) {
            var item = recapList.get(i)
            if (item.enabled)
                summaryTotal += item.amount
        }
    }
}
