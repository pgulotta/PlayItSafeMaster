import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import RealAsset
import SwitchboardCategory
import "Functions.js" as Functions

Page {
    id: realAssetsPageId
    objectName: "RealAssetsPage"

    property real field1Width: width * .5
    property real field2Width: width * .2
    property real amountWidth: width * .15
    property alias allRealAssets: modelListViewId.listViewModel
    property alias allRealAssetsIndex: modelListViewId.listViewCurrentIndex
    property string initialUniqueId: ""
    property int initialIndex: 0
    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.RealAsset)
    property string fieldBackColor
    property RealAsset currentRealAsset

    state: ""

    Component.onCompleted: {
        setcurrentRealAsset(initialIndex)
        if (visible && category !== null) {
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
        hideKeyboard()
    }

    onInitialUniqueIdChanged: initialIndex = Functions.getListIndexFromUniqueId(
                                  initialUniqueId, AllRealAssets)

    onCategoryChanged: {
        if (category !== null) {
            fieldBackColor = getCategoryColor(category.group)
            initializeToolbar(true, getformattedToolbarTitle(category.title))
        }
    }

    onVisibleChanged: {
        if (visible) {
            websiteUrlId.setWebsiteTitle(currentRealAsset.websiteId)
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    Rectangle {
        id: cashHoldingsRectId
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
                    listViewModel: AllRealAssets
                    listViewDelegate: listViewDelegateId
                    onCurrentIndexChanged: setcurrentRealAsset(
                                               allRealAssetsIndex)
                }
                Item {
                    height: largeMargin
                    width: parent.width
                    visible: true
                }
                EditableText {
                    id: descriptionId
                    isTextRequired: true
                    width: isPortraitMode ? listViewWidth : fieldColumnWidth
                    fieldLabel: qsTr("Description")
                    fieldText: currentRealAsset.description
                    onEditableTextChanged: onFieldChanged(
                                               descriptionId.fieldText,
                                               currentRealAsset.description)
                }
                DatePicker {
                    id: lastUpdatedId
                    fieldLabel: qsTr("Last Updated")
                    dateSelected: currentRealAsset.effectiveDate
                    onDateChanged: {
                        setEffectiveDate(dateSelected)
                        onFieldChanged(dateSelected,
                                       currentRealAsset.effectiveDate)
                    }
                }
                EditableText {
                    id: valuationId
                    isTextRequired: true
                    inputHints: Qt.ImhFormattedNumbersOnly
                    fieldLabel: qsTr("Valuation")
                    fieldText: formattedCurrentValuation()
                    inputValidator: DoubleValidator {}
                    onEditableTextChanged: onFieldChanged(
                                               valuationId.fieldText,
                                               formattedCurrentValuation())
                }
                EditableText {
                    id: notesId
                    fieldLabel: qsTr("Notes")
                    fieldText: currentRealAsset.notes
                    width: websiteUrlId.width
                    onEditableTextChanged: onFieldChanged(
                                               notesId.fieldText,
                                               currentRealAsset.notes)
                }
                WebsitePicker {
                    id: websiteUrlId
                    fieldLabel: qsTr("Website")
                    currentWebsiteUniqueId: currentRealAsset.websiteId
                    width: isPortraitMode ? listViewWidth : fieldColumnWidth * 1.51
                    onWebsiteChanged: {
                        onFieldChanged(websiteUniqueId,
                                       currentRealAsset.websiteId)
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
                    setcurrentRealAsset(index)
                }
            }
            Rectangle {
                id: rowRectId
                height: field1Id.height + itemMargin
                width: modelListViewId.width
                border.width: rectBorder
                border.color: darkTextColor
                radius: rectRadius
                color: fieldBackColor
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
                        text: model.description
                        Layout.fillHeight: true
                        Layout.preferredWidth: field1Width
                    }
                    TitleTextDark {
                        id: fieldId2
                        text: Functions.formatDate(model.effectiveDate)
                        Layout.preferredWidth: field2Width
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    TitleTextDark {
                        id: fieldId3
                        text: Functions.formatCurrencyString(model.valuation)
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
                setcurrentRealAsset(allRealAssets.size())
            } else if (buttonImage.indexOf("remove") >= 0) {
                doRemove()
            }
            initializeToolbar(modelListViewId.enabled,
                              getformattedToolbarTitle(category.title))
        }
    }

    function getItemIndex(uniqueId) {
        if (allRealAssets === undefined || allRealAssets.isEmpty())
            return invalidIndex
        var index = invalidIndex
        for (var i = 0; index === invalidIndex
             && i < allRealAssets.size(); i++) {
            var item = allRealAssets.get(i)
            if (item.uniqueId === uniqueId)
                index = i
        }
        return index
    }

    function formattedCurrentValuation() {
        return currentRealAsset.valuation.toFixed(3)
    }

    function setcurrentRealAsset(listViewIndex) {
        if (allRealAssets === undefined || allRealAssets.size(
                    ) <= listViewIndex) {
            realAssetsPageId.state = addingNewState
            currentRealAsset = DataStoreManager.newItem(
                        SwitchboardCategory.RealAsset)
        } else {
            realAssetsPageId.state = ""
            modelListViewId.listViewCurrentIndex = listViewIndex
            currentRealAsset = allRealAssets.get(listViewIndex)
            modelListViewId.positionViewAtIndex(listViewIndex, ListView.Visible)
        }
        assigncurrentRealAsset()
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

    function assigncurrentRealAsset() {
        if (currentRealAsset === null) {
            setcurrentRealAsset(0)
        } else {
            descriptionId.fieldText = currentRealAsset.description
            valuationId.fieldText = formattedCurrentValuation()
            setEffectiveDate(currentRealAsset.effectiveDate)
            notesId.fieldText = currentRealAsset.notes
            websiteUrlId.setWebsiteTitle(currentRealAsset.websiteId)
        }
    }

    function doRemove() {
        DataStoreManager.removeItem(SwitchboardCategory.RealAsset,
                                    currentRealAsset.uniqueId)
        setcurrentRealAsset(0)
        setIsDirty(false)
        modelListViewId.positionViewAtBeginning()
    }

    function doCancel() {
        setcurrentRealAsset(modelListViewId.listViewCurrentIndex)
        setIsDirty(false)
    }

    function doTrySave() {
        if (descriptionId.state === validDataState
                && valuationId.state === validDataState) {
            currentRealAsset.description = descriptionId.fieldText
            currentRealAsset.valuation = valuationId.fieldText
            currentRealAsset.effectiveDate = lastUpdatedId.dateSelected
            currentRealAsset.notes = notesId.fieldText
            currentRealAsset.websiteId = websiteUrlId.currentWebsiteUniqueId
            DataStoreManager.saveItem(
                        SwitchboardCategory.RealAsset,
                        realAssetsPageId.state === addingNewState,
                        currentRealAsset)
            allRealAssetsIndex = getItemIndex(currentRealAsset.uniqueId)
            setcurrentRealAsset(allRealAssetsIndex)
            setIsDirty(false)
            realAssetsPageId.state = ""
        } else {
            showTitledMessage(unableSaveTitle, requiredMessage)
        }
    }

    function onFieldChanged(fieldValue, currentValue) {
        if (isToolbarEnabled()) {
            if (fieldValue < currentValue || fieldValue > currentValue) {
                setIsDirty(true)
            }
        }
    }

    function setEffectiveDate(dateValue) {
        if (isNaN(dateValue))
            dateValue = new Date()
        lastUpdatedId.dateSelected = dateValue
    }

    function getformattedToolbarTitle(categoryTitle) {
        if (allRealAssets === undefined || allRealAssets.isEmpty())
            return categoryTitle
        var total = 0.00
        for (var i = 0; i < allRealAssets.size(); i++) {
            var item = allRealAssets.get(i)
            total += item.valuation
        }

        return category.title + ": " + Functions.formatCurrencyString(total)
    }
}
