import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Expense
import SwitchboardCategory
import "Functions.js" as Functions

Page {
    id: expensesPageId
    objectName: "ExpensesPage"

    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.Expense)
    property alias allExpenses: modelListViewId.listViewModel
    property alias allExpensesIndex: modelListViewId.listViewCurrentIndex
    property real field1Width: width * .45
    property real field2Width: width * .25
    property real amountWidth: width * .15
    property string initialUniqueId: ""
    property int initialIndex: 0
    property int smallFieldColumnWidth: isPortraitMode ? fieldColumnWidth : fieldColumnWidth * .49
    property string fieldBackColor
    property Expense currentExpense

    state: ""

    Component.onCompleted: {
        setCurrentExpense(initialIndex)
        if (visible && category !== null) {
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
        hideKeyboard()
    }

    onInitialUniqueIdChanged: initialIndex = Functions.getListIndexFromUniqueId(
                                  initialUniqueId, AllExpenses)

    onCategoryChanged: {
        if (category !== null) {
            fieldBackColor = getCategoryColor(category.group)
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
    }

    onVisibleChanged: {
        if (visible) {
            websiteUrlId.setWebsiteTitle(currentExpense.websiteId)
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    Rectangle {
        height: parent.height
        width: parent.width
        color: appBackColor
        anchors.fill: parent
    }
    Flickable {
        clip: false
        anchors.fill: parent
        contentHeight: parent.height * 1.5
        Layout.alignment: Qt.AlignHCenter
        Column {
            width: parent.width
            height: parent.height
            anchors.fill: parent
            spacing: isPortraitMode ? itemMargin * 2 : itemMargin
            anchors.margins: itemMargin
            anchors.leftMargin: isPortraitMode ? itemMargin : itemIndent
            anchors.topMargin: isPortraitMode ? itemIndent : itemMargin
            Flow {
                width: parent.width
                height: parent.height
                spacing: itemMargin
                ModelListView {
                    id: modelListViewId
                    listViewModel: AllExpenses
                    listViewDelegate: listViewDelegateId
                    onCurrentIndexChanged: setCurrentExpense(allExpensesIndex)
                }
                Item {
                    height: largeMargin
                    width: parent.width
                    visible: true
                }
                EditableText {
                    id: payeeId
                    isTextRequired: true
                    fieldLabel: qsTr("Payee")
                    fieldText: currentExpense.payee
                    onEditableTextChanged: onFieldChanged(payeeId.fieldText,
                                                          currentExpense.payee)
                }
                DatePickerDialog {
                    id: nextPaymentDatePickerId
                    fieldLabel: qsTr("Payment Date")
                    maximumDate: new Date(2050, 12, 1)
                    dateSelected: currentExpense.nextPaymentDate
                    onDateChanged: {
                        setNextPaymentDate(dateSelected)
                        onFieldChanged(dateSelected,
                                       currentExpense.nextPaymentDate)
                    }
                }

                EditableText {
                    id: accountNumberId
                    isTextRequired: true
                    fieldLabel: qsTr("Account Number")
                    fieldText: currentExpense.accountNumber
                    onEditableTextChanged: onFieldChanged(
                                               accountNumberId.fieldText,
                                               currentExpense.accountNumber)
                }

                EditableText {
                    id: nameOnAccountId
                    isTextRequired: true
                    fieldLabel: qsTr("Name on Account")
                    fieldText: currentExpense.nameOnAccount
                    onEditableTextChanged: onFieldChanged(
                                               nameOnAccountId.fieldText,
                                               currentExpense.nameOnAccount)
                }
                EditableText {
                    id: amountId
                    isTextRequired: true
                    inputHints: Qt.ImhFormattedNumbersOnly
                    fieldLabel: qsTr("Amount")
                    fieldText: formattedCurrentAmount()
                    inputValidator: DoubleValidator {
                    }
                    onEditableTextChanged: onFieldChanged(
                                               amountId.fieldText,
                                               formattedCurrentAmount())
                }
                EditableText {
                    id: autoPaymentId
                    fieldLabel: qsTr("Auto Payment")
                    fieldText: currentExpense.autoPayment
                    onEditableTextChanged: onFieldChanged(
                                               autoPaymentId.fieldText,
                                               currentExpense.autoPayment)
                }
                EditableText {
                    id: notesId
                    fieldLabel: qsTr("Notes")
                    fieldText: currentExpense.notes
                    width: websiteUrlId.width
                    onEditableTextChanged: onFieldChanged(notesId.fieldText,
                                                          currentExpense.notes)
                }
                WebsitePicker {
                    id: websiteUrlId
                    fieldLabel: qsTr("Website")
                    currentWebsiteUniqueId: currentExpense.websiteId
                    width: isPortraitMode ? listViewWidth : fieldColumnWidth * 1.52
                    onWebsiteChanged: {
                        onFieldChanged(websiteUniqueId,
                                       currentExpense.websiteId)
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
                    opacity: .66
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
                onClicked: {
                    itemId.ListView.view.currentIndex = index
                    itemId.forceActiveFocus()
                    setCurrentExpense(index)
                }
            }
            Rectangle {
                id: rowRectId
                height: field1Id.height + itemMargin
                width: modelListViewId.width
                border.width: rectBorder
                border.color: darkTextColor
                radius: rectRadius
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
                        text: model.payee
                        Layout.fillHeight: true
                        Layout.preferredWidth: field1Width
                    }
                    TitleTextDark {
                        id: fieldId2
                        text: Functions.formatDate(model.nextPaymentDate)
                        Layout.preferredWidth: field2Width
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    TitleTextDark {
                        id: fieldId3
                        text: Functions.formatCurrencyString(model.amount * -1)
                        clip: true
                        width: amountWidth
                        Layout.alignment: Qt.AlignRight
                        color: model.amount > 0 ? negativeNumberColor : darkTextColor
                    }
                }
            }
        }
    }

    FloatingActionMenu {
        id: floatingActionMenuId
        onButtonItemSelected: {
            if (buttonImage.indexOf("cancel") >= 0) {
                doCancel()
            } else if (buttonImage.indexOf("save") >= 0) {
                doTrySave()
            } else if (buttonImage.indexOf("add") >= 0) {
                setCurrentExpense(allExpenses.size())
            } else if (buttonImage.indexOf("remove") >= 0) {
                doRemove()
            }
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    function formattedCurrentAmount() {
        return currentExpense.amount.toFixed(3)
    }

    function getItemIndex(uniqueId) {
        if (allExpenses === undefined || allExpenses.isEmpty())
            return invalidIndex
        var index = invalidIndex
        for (var i =0; index === invalidIndex && i < allExpenses.size(); i++) {
            var item = allExpenses.get(i)
            if (item.uniqueId === uniqueId)
                index = i
        }
        return index
    }

    function assignCurrentExpense() {
        if (currentExpense === null) {
            setCurrentExpense(0)
        } else {
            payeeId.fieldText = currentExpense.payee
            accountNumberId.fieldText = currentExpense.accountNumber
            autoPaymentId.fieldText = currentExpense.autoPayment
            nameOnAccountId.fieldText = currentExpense.nameOnAccount
            nextPaymentDatePickerId.dateSelected = setNextPaymentDate(
                        currentExpense.nextPaymentDate)
            amountId.fieldText = Functions.formattedNumeric(
                        currentExpense.amount, 2)
            notesId.fieldText = currentExpense.notes
            websiteUrlId.setWebsiteTitle(currentExpense.websiteId)
        }
    }
    function onFieldChanged(fieldValue, currentValue) {
        if (isToolbarEnabled()) {
            if (fieldValue < currentValue || fieldValue > currentValue) {
                setIsDirty(true)
            }
        }
    }

    function setIsDirty(isDirty) {
        if (!modelListViewId.enabled === isDirty)
            return
        floatingActionMenuId.setActionButtonsState(isDirty)
        enableAppToolbar(!isDirty)
        modelListViewId.enabled = !isDirty
    }

    function doCancel() {
        setCurrentExpense(modelListViewId.listViewCurrentIndex)
        setIsDirty(false)
    }

    function doRemove() {
        DataStoreManager.removeItem(SwitchboardCategory.Expense,
                                    currentExpense.uniqueId)
        setCurrentExpense(0)
        setIsDirty(false)
        modelListViewId.positionViewAtBeginning()
    }

    function doTrySave() {
        if (payeeId.state === validDataState && payeeId.state === validDataState
                && nameOnAccountId.state === validDataState
                && accountNumberId.state === validDataState) {
            currentExpense.payee = payeeId.fieldText
            currentExpense.accountNumber = accountNumberId.fieldText
            currentExpense.autoPayment = autoPaymentId.fieldText
            currentExpense.amount = amountId.fieldText
            currentExpense.nameOnAccount = nameOnAccountId.fieldText
            currentExpense.nextPaymentDate = nextPaymentDatePickerId.dateSelected
            currentExpense.notes = notesId.fieldText
            currentExpense.websiteId = websiteUrlId.currentWebsiteUniqueId
            DataStoreManager.saveItem(SwitchboardCategory.Expense,
                                      expensesPageId.state === addingNewState,
                                      currentExpense)
            allExpensesIndex = getItemIndex(currentExpense.uniqueId)
            setCurrentExpense(allExpensesIndex)
            setIsDirty(false)
            expensesPageId.state = ""
        } else {
            showTitledMessage(unableSaveTitle, requiredMessage)
        }
    }

    function setNextPaymentDate(dateValue) {
        if (isNaN(dateValue))
            return
        nextPaymentDatePickerId.dateSelected = dateValue
        nextPaymentDatePickerId.fieldText = Functions.formatDate(dateValue)
    }

    function setCurrentExpense(listViewIndex) {
        if (allExpenses === undefined || allExpenses.size() <= listViewIndex) {
            expensesPageId.state = addingNewState
            currentExpense = DataStoreManager.newItem(
                        SwitchboardCategory.Expense)
            assignCurrentExpense()
        } else {
            expensesPageId.state = ""
            modelListViewId.listViewCurrentIndex = listViewIndex
            currentExpense = allExpenses.get(listViewIndex)
            modelListViewId.positionViewAtIndex(listViewIndex, ListView.Visible)
        }
        assignCurrentExpense()
        setIsDirty(false)
        modelListViewId.forceActiveFocus()
    }

    function getformattedToolbarTitle(categoryTitle) {
        if (allExpenses === undefined || allExpenses.isEmpty())
            return categoryTitle
        var total = 0.00
        for (var i=0; i < allExpenses.size(); i++) {
            var item = allExpenses.get(i)
            total += item.amount
        }
        return category.title + ": " + Functions.formatCurrencyString(
                    total * -1.0)
    }
}
