import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import BankAccount 1.0
import SwitchboardCategory 1.0
import "Functions.js" as Functions

Page {
    id: bankAccountsPageId
    objectName: "BankAccountsPage"

    property alias allBankAccounts: modelListViewId.listViewModel
    property alias allBankAccountsIndex: modelListViewId.listViewCurrentIndex
    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.BankAccount)
    property string fieldBackColor
    property BankAccount currentBankAccount
    property string initialUniqueId: ""
    property int initialIndex: 0
    property real field1Width: parent.width * .3
    property real field2Width: parent.width * .4
    property real amountWidth: parent.width * .15

    state: ""
    width: parent.width

    Component.onCompleted: {
        setCurrentBankAccount(initialIndex)
        if (visible && category !== null) {
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
        hideKeyboard()
    }

    onInitialUniqueIdChanged: initialIndex = Functions.getListIndexFromUniqueId(
                                  initialUniqueId, AllBankAccounts)

    onCategoryChanged: {
        if (category !== null) {
            fieldBackColor = getCategoryColor(category.group)
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
    }

    onVisibleChanged: {
        if (visible) {
            websiteUrlId.setWebsiteTitle(currentBankAccount.websiteId)
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    Rectangle {
        id: bankAccountsRectId
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
            anchors.margins: itemMargin
            anchors.leftMargin: isPortraitMode ? itemMargin : itemIndent
            anchors.topMargin: isPortraitMode ? itemIndent : itemMargin
            Flow {
                width: parent.width
                height: parent.height
                spacing: itemMargin

                ModelListView {
                    id: modelListViewId
                    listViewModel: AllBankAccounts
                    focus: true
                    listViewDelegate: listViewDelegateId
                    onCurrentIndexChanged: setCurrentBankAccount(
                                               allBankAccountsIndex)
                }
                Item {
                    height: largeMargin
                    width: parent.width
                    visible: true
                }
                EditableText {
                    id: bankNameId
                    isTextRequired: true
                    fieldLabel: qsTr("Bank Name")
                    fieldText: currentBankAccount.bankName
                    onEditableTextChanged: onFieldChanged(
                                               bankNameId.fieldText,
                                               currentBankAccount.bankName)
                }
                EditableText {
                    id: accountNumberId
                    isTextRequired: true
                    fieldLabel: qsTr("Account Number")
                    fieldText: currentBankAccount.accountNumber
                    onEditableTextChanged: onFieldChanged(
                                               accountNumberId.fieldText,
                                               currentBankAccount.accountNumber)
                }
                DatePicker {
                    id: openDatePickerId
                    isTextRequired: true
                    fieldLabel: qsTr("Last Updated")
                    dateSelected: currentBankAccount.openedDate
                    onDateChanged: {
                        setOpenedDate(dateSelected)
                        onFieldChanged(dateSelected,
                                       currentBankAccount.openedDate)
                    }
                }
                EditableText {
                    id: routingNumberId
                    inputHints: Qt.ImhDigitsOnly
                    fieldLabel: qsTr("Routing Number")
                    fieldText: currentBankAccount.routingNumber
                    inputValidator: RegularExpressionValidator {
                        regExp: new RegExp(routingNumberRegExp)
                    }
                    onEditableTextChanged: {
                        onFieldChanged(routingNumberId.fieldText,
                                       currentBankAccount.routingNumber)
                    }
                }
                EditableText {
                    id: amountId
                    inputHints: Qt.ImhFormattedNumbersOnly
                    fieldLabel: qsTr("Amount")
                    fieldText: formattedCurrentAmount()
                    inputValidator: DoubleValidator {}
                    onEditableTextChanged: {
                        onFieldChanged(amountId.fieldText,
                                       formattedCurrentAmount())
                    }
                }
                EditableText {
                    id: nameOnAccountId
                    isTextRequired: true
                    fieldLabel: qsTr("Name on Account")
                    fieldText: currentBankAccount.nameOnAccount
                    onEditableTextChanged: onFieldChanged(
                                               nameOnAccountId.fieldText,
                                               currentBankAccount.nameOnAccount)
                }
                EditableText {
                    id: notesId
                    fieldLabel: qsTr("Notes")
                    fieldText: currentBankAccount.notes
                    width: isPortraitMode ? listViewWidth : listViewWidth * 0.485
                    onEditableTextChanged: onFieldChanged(
                                               notesId.fieldText,
                                               currentBankAccount.notes)
                }
                WebsitePicker {
                    id: websiteUrlId
                    fieldLabel: qsTr("Website")
                    currentWebsiteUniqueId: currentBankAccount.websiteId
                    width: notesId.width
                    onWebsiteChanged: {
                        onFieldChanged(websiteUniqueId,
                                       currentBankAccount.websiteId)
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
                    setCurrentBankAccount(index)
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
                        Layout.fillHeight: true
                        Layout.preferredWidth: field1Width
                    }
                    TitleTextDark {
                        id: fieldId2
                        text: model.nameOnAccount
                        Layout.preferredWidth: field2Width
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    TitleTextDark {
                        id: fieldId3
                        text: Functions.formatCurrencyString(model.amount)
                        width: amountWidth
                        Layout.alignment: Qt.AlignRight
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
                setCurrentBankAccount(allBankAccounts.size())
            } else if (buttonImage.indexOf("remove") >= 0) {
                doRemove()
            }
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    function getItemIndex(uniqueId) {
        if (allBankAccounts === undefined || allBankAccounts.isEmpty())
            return invalidIndex
        var index = invalidIndex
        for (var i = 0; index === invalidIndex
             && i < allBankAccounts.size(); i++) {
            var item = allBankAccounts.get(i)
            if (item.uniqueId === uniqueId)
                index = i
        }
        return index
    }

    function formattedCurrentAmount() {
        return currentBankAccount.amount.toFixed(3)
    }

    function setCurrentBankAccount(listViewIndex) {
        if (allBankAccounts === undefined || allBankAccounts.size(
                    ) <= listViewIndex) {
            bankAccountsPageId.state = addingNewState
            currentBankAccount = DataStoreManager.newItem(
                        SwitchboardCategory.BankAccount)
        } else {
            bankAccountsPageId.state = ""
            modelListViewId.listViewCurrentIndex = listViewIndex
            currentBankAccount = allBankAccounts.get(listViewIndex)
            modelListViewId.positionViewAtIndex(listViewIndex, ListView.Visible)
        }
        assignCurrentBankAccount()
        setIsDirty(false)
        modelListViewId.forceActiveFocus()
    }

    function setIsDirty(isDirty) {
        if (!modelListViewId.enabled === isDirty)
            return
        floatingActionMenuId.setActionButtonsState(isDirty)
        enableAppToolbar(!isDirty)
        modelListViewId.enabled = !isDirty
    }

    function onFieldChanged(fieldValue, currentValue) {
        if (isToolbarEnabled()) {
            if (fieldValue < currentValue || fieldValue > currentValue) {
                setIsDirty(true)
            }
        }
    }

    function assignCurrentBankAccount() {
        if (currentBankAccount === null) {
            setCurrentBankAccount(0)
        } else {
            bankNameId.fieldText = currentBankAccount.bankName
            nameOnAccountId.fieldText = currentBankAccount.nameOnAccount
            accountNumberId.fieldText = currentBankAccount.accountNumber
            routingNumberId.fieldText = currentBankAccount.routingNumber
            amountId.fieldText = formattedCurrentAmount()
            openDatePickerId.dateSelected = setOpenedDate(
                        currentBankAccount.openedDate)
            notesId.fieldText = currentBankAccount.notes
            websiteUrlId.setWebsiteTitle(currentBankAccount.websiteId)
        }
    }

    function doRemove() {
        DataStoreManager.removeItem(SwitchboardCategory.BankAccount,
                                    currentBankAccount.uniqueId)
        setCurrentBankAccount(0)
        setIsDirty(false)
        modelListViewId.positionViewAtBeginning()
    }

    function doCancel() {
        setCurrentBankAccount(modelListViewId.listViewCurrentIndex)
        setIsDirty(false)
    }

    function doTrySave() {
        if (bankNameId.state === validDataState
                && nameOnAccountId.state === validDataState
                && accountNumberId.state === validDataState) {
            currentBankAccount.bankName = bankNameId.fieldText
            currentBankAccount.nameOnAccount = nameOnAccountId.fieldText
            currentBankAccount.accountNumber = accountNumberId.fieldText
            currentBankAccount.routingNumber = routingNumberId.fieldText
            currentBankAccount.amount = amountId.fieldText
            currentBankAccount.openedDate = new Date(Date.now())
            currentBankAccount.notes = notesId.fieldText
            currentBankAccount.websiteId = websiteUrlId.currentWebsiteUniqueId
            DataStoreManager.saveItem(
                        SwitchboardCategory.BankAccount,
                        bankAccountsPageId.state === addingNewState,
                        currentBankAccount)
            allBankAccountsIndex = getItemIndex(currentBankAccount.uniqueId)
            setCurrentBankAccount(allBankAccountsIndex)
            setIsDirty(false)
            bankAccountsPageId.state = ""
        } else {
            showTitledMessage(unableSaveTitle, requiredMessage)
        }
    }

    function setOpenedDate(dateValue) {
        if (isNaN(dateValue))
            return
        openDatePickerId.dateSelected = dateValue
        openDatePickerId.fieldText = Functions.formatDate(dateValue)
    }

    function getformattedToolbarTitle(categoryTitle) {
        if (allBankAccounts === undefined || allBankAccounts.isEmpty())
            return categoryTitle
        var total = 0.00
        for (var i = 0; i < allBankAccounts.size(); i++) {
            var item = allBankAccounts.get(i)
            total += item.amount
        }

        return category.title + ": " + Functions.formatCurrencyString(total)
    }
}
