import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import Investment 1.0
import SwitchboardCategory 1.0
import InvestmentPriceNotification 1.0
import "Functions.js" as Functions

Page {
    id: investmentsPageId
    objectName: "InvestmentsPage"

    property real field1Width: parent.width * .3
    property real field2Width: parent.width * .4
    property real amountWidth: parent.width * .15

    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.Investment)
    property alias allInvestments: modelListViewId.listViewModel
    property alias allInvestmentsIndex: modelListViewId.listViewCurrentIndex
    property string initialUniqueId: ""
    property int initialIndex: 0
    property int smallFieldColumnWidth: isPortraitMode ? fieldColumnWidth : fieldColumnWidth * .49
    property string fieldBackColor
    property Investment currentInvestment

    state: ""
    width: parent.width

    Component.onCompleted: {
        setCurrentInvestment(initialIndex)
        if (visible && category !== null) {
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
        hideKeyboard()
    }

    onInitialUniqueIdChanged: initialIndex = Functions.getListIndexFromUniqueId(
                                  initialUniqueId, AllInvestments)

    onCategoryChanged: {
        if (category !== null) {
            fieldBackColor = getCategoryColor(category.group)
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
    }

    onVisibleChanged: {
        if (visible) {
            websiteUrlId.setWebsiteTitle(currentInvestment.websiteId)
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    InvestmentPriceNotification {
        id: investmentPriceNotificationId
        updateSuccess: InvestmentPriceUpdate.updateSuccess
        onUpdateSuccessChanged: setCurrentInvestment(allInvestmentsIndex)
    }

    Rectangle {
        id: investmentsRectId
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
                    listViewModel: AllInvestments
                    listViewDelegate: listViewDelegateId
                    onCurrentIndexChanged: setCurrentInvestment(
                                               allInvestmentsIndex)
                }
                Item {
                    height: largeMargin
                    width: parent.width
                    visible: true
                }
                EditableText {
                    id: issuerId
                    isTextRequired: true
                    fieldLabel: qsTr("Issuer Symbol")
                    fontCapitaliztion: Font.AllUppercase
                    fieldText: currentInvestment.issuer
                    onEditableTextChanged: onFieldChanged(
                                               issuerId.fieldText.toLocaleUpperCase(
                                                   ), currentInvestment.issuer)
                }
                EditableText {
                    id: accountNumberId
                    isTextRequired: true
                    fieldLabel: qsTr("Account Number")
                    fieldText: currentInvestment.accountNumber
                    onEditableTextChanged: onFieldChanged(
                                               accountNumberId.fieldText,
                                               currentInvestment.accountNumber)
                }
                DatePicker {
                    id: issuerDatePickerId
                    isTextRequired: true
                    fieldLabel: qsTr("Last Updated")
                    dateSelected: currentInvestment.issueDate
                    onDateChanged: {
                        setIssuerDate(dateSelected)
                        onFieldChanged(dateSelected,
                                       currentInvestment.issueDate)
                    }
                }
                DatePicker {
                    id: purchasedDatePickerId
                    isTextRequired: true
                    fieldLabel: qsTr("Date Purchased")
                    dateSelected: currentInvestment.purchaseDate
                    onDateChanged: {
                        setPurchasedDate(dateSelected)
                        onFieldChanged(dateSelected,
                                       currentInvestment.purchaseDate)
                    }
                }
                EditableText {
                    id: sharesId
                    isTextRequired: true
                    width: smallFieldColumnWidth
                    inputHints: Qt.ImhFormattedNumbersOnly
                    fieldLabel: qsTr("Shares")
                    fieldText: Functions.formattedNumeric(
                                   currentInvestment.shares,
                                   currentInvestment.sharesDecimals)
                    inputValidator: DoubleValidator {
                    }
                    onEditableTextChanged: onFieldChanged(
                                               sharesId.fieldText,
                                               Functions.formattedNumeric(
                                                   currentInvestment.shares,
                                                   currentInvestment.sharesDecimals))
                }
                EditableText {
                    id: lastPriceId
                    isTextRequired: true
                    width: smallFieldColumnWidth
                    inputHints: Qt.ImhFormattedNumbersOnly
                    fieldLabel: qsTr("Last Price")
                    fieldText: Functions.formattedNumeric(
                                   currentInvestment.lastPrice,
                                   currentInvestment.lastPriceDecimals)
                    inputValidator: DoubleValidator {
                    }
                    onEditableTextChanged: onFieldChanged(
                                               lastPriceId.fieldText,
                                               Functions.formattedNumeric(
                                                   currentInvestment.lastPrice,
                                                   currentInvestment.lastPriceDecimals))
                }
                EditableText {
                    id: nameOnAccountId
                    isTextRequired: true
                    fieldLabel: qsTr("Name on Account")
                    fieldText: currentInvestment.nameOnAccount
                    onEditableTextChanged: onFieldChanged(
                                               nameOnAccountId.fieldText,
                                               currentInvestment.nameOnAccount)
                }
                EditableText {
                    id: routingNumberId
                    fieldLabel: qsTr("Routing Number")
                    fieldText: currentInvestment.routingNumber
                    inputHints: Qt.ImhDigitsOnly
                    inputValidator: RegExpValidator {
                        regExp: new RegExp(routingNumberRegExp)
                    }
                    onEditableTextChanged: onFieldChanged(
                                               routingNumberId.fieldText,
                                               currentInvestment.routingNumber)
                }
                EditableText {
                    id: notesId
                    fieldLabel: qsTr("Notes")
                    fieldText: currentInvestment.notes
                    width: websiteUrlId.width
                    onEditableTextChanged: onFieldChanged(
                                               notesId.fieldText,
                                               currentInvestment.notes)
                }
                WebsitePicker {
                    id: websiteUrlId
                    fieldLabel: qsTr("Website")
                    currentWebsiteUniqueId: currentInvestment.websiteId
                    width: isPortraitMode ? listViewWidth : fieldColumnWidth
                    onWebsiteChanged: {
                        onFieldChanged(websiteUniqueId,
                                       currentInvestment.websiteId)
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
                    setCurrentInvestment(index)
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
                        text: model.issuer
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
                        text: Functions.formatCurrencyString(
                                  model.shares * model.lastPrice)
                        clip: true
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
                setCurrentInvestment(allInvestments.size())
            } else if (buttonImage.indexOf("remove") >= 0) {
                doRemove()
            }
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    function getItemIndex(uniqueId) {
        if (allInvestments === undefined || allInvestments.isEmpty())
            return invalidIndex
        var index = invalidIndex
        for (var i =0; index === invalidIndex && i < allInvestments.size(); i++) {
            var item = allInvestments.get(i)
            if (item.uniqueId === uniqueId)
                index = i
        }
        return index
    }

    function assignCurrentInvestment() {
        if (currentInvestment === null) {
            setCurrentInvestment(0)
        } else {
            issuerId.fieldText = currentInvestment.issuer
            accountNumberId.fieldText = currentInvestment.accountNumber
            nameOnAccountId.fieldText = currentInvestment.nameOnAccount
            routingNumberId.fieldText = currentInvestment.routingNumber
            issuerDatePickerId.dateSelected = setIssuerDate(
                        currentInvestment.issueDate)
            purchasedDatePickerId.dateSelected = setPurchasedDate(
                        currentInvestment.purchaseDate)
            sharesId.fieldText = Functions.formattedNumeric(
                        currentInvestment.shares,
                        currentInvestment.sharesDecimals)
            lastPriceId.fieldText = Functions.formattedNumeric(
                        currentInvestment.lastPrice,
                        currentInvestment.lastPriceDecimals)
            notesId.fieldText = currentInvestment.notes
            websiteUrlId.setWebsiteTitle(currentInvestment.websiteId)
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
        setCurrentInvestment(modelListViewId.listViewCurrentIndex)
        setIsDirty(false)
    }

    function doRemove() {
        DataStoreManager.removeItem(SwitchboardCategory.Investment,
                                    currentInvestment.uniqueId)
        setCurrentInvestment(0)
        setIsDirty(false)
        modelListViewId.positionViewAtBeginning()
    }

    function doTrySave() {
        if (issuerId.state === validDataState
                && accountNumberId.state === validDataState
                && nameOnAccountId.state === validDataState) {
            currentInvestment.issuer = issuerId.fieldText.toLocaleUpperCase()
            currentInvestment.accountNumber = accountNumberId.fieldText
            currentInvestment.shares = sharesId.fieldText
            currentInvestment.lastPrice = lastPriceId.fieldText
            currentInvestment.nameOnAccount = nameOnAccountId.fieldText
            currentInvestment.routingNumber = routingNumberId.fieldText
            currentInvestment.issueDate = new Date()
            currentInvestment.purchaseDate = purchasedDatePickerId.dateSelected
            currentInvestment.notes = notesId.fieldText
            currentInvestment.websiteId = websiteUrlId.currentWebsiteUniqueId
            DataStoreManager.saveItem(
                        SwitchboardCategory.Investment,
                        investmentsPageId.state === addingNewState,
                        currentInvestment)
            allInvestmentsIndex = getItemIndex(currentInvestment.uniqueId)
            setCurrentInvestment(allInvestmentsIndex)
            setIsDirty(false)
            investmentsPageId.state = ""
        } else {
            showTitledMessage(unableSaveTitle, requiredMessage)
        }
    }

    function setIssuerDate(dateValue) {
        if (isNaN(dateValue))
            return
        issuerDatePickerId.dateSelected = dateValue
        issuerDatePickerId.fieldText = Functions.formatDate(dateValue)
    }

    function setPurchasedDate(dateValue) {
        if (isNaN(dateValue))
            return
        purchasedDatePickerId.dateSelected = dateValue
        purchasedDatePickerId.fieldText = Functions.formatDate(dateValue)
    }

    function setCurrentInvestment(listViewIndex) {
        if (allInvestments === undefined || allInvestments.size(
                    ) <= listViewIndex) {
            investmentsPageId.state = addingNewState
            currentInvestment = DataStoreManager.newItem(
                        SwitchboardCategory.Investment)
        } else {
            investmentsPageId.state = ""
            modelListViewId.listViewCurrentIndex = listViewIndex
            currentInvestment = allInvestments.get(listViewIndex)
            modelListViewId.positionViewAtIndex(listViewIndex, ListView.Visible)
        }

        assignCurrentInvestment()
        setIsDirty(false)
        modelListViewId.forceActiveFocus()
    }

    function getformattedToolbarTitle(categoryTitle) {
        if (allInvestments === undefined || allInvestments.isEmpty())
            return categoryTitle
        var total = 0.00
        for (var i=0; i < allInvestments.size(); i++) {
            var item = allInvestments.get(i)
            total += (item.shares * item.lastPrice)
        }

        return category.title + ": " + Functions.formatCurrencyString(total)
    }
}