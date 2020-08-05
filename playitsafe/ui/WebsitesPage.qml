import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import Website 1.0
import SwitchboardCategory 1.0

Page {
    id: websitesPageId
    objectName: "WebsitesPage"

    property alias allWebsites: modelListViewId.listViewModel
    property alias allWebstesIndex: modelListViewId.listViewCurrentIndex
    property Website currentWebsite
    property string fieldBackColor
    property int initialWebsiteListIndex: 0
    property real field1Width: parent.width * .5
    property real field2Width: parent.width * .5
    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.Website)
    readonly property var noneUniqueId: DataStoreManager.websiteNoneUniqueId

    state: ""
    width: parent.width

    Component.onCompleted: {
        setcurrentWebsite(0)
        if (visible && category !== null) {
            initializeToolbar(true, category.title)
        }
        hideKeyboard()
    }

    onCategoryChanged: {
        if (category !== null) {
            fieldBackColor = getCategoryColor(category.group)
            initializeToolbar(true, category.title)
        }
    }
    onVisibleChanged: {
        if (visible) {
            setcurrentWebsite(initialWebsiteListIndex)
            initializeToolbar(true, category.title)
        }
    }
    Flickable {
        clip: false
        anchors.fill: parent
        contentHeight: parent.height * 1.5
        Layout.alignment: Qt.AlignHCenter
        Rectangle {
            height: parent.height
            width: parent.width
            color: appBackColor
            anchors.fill: parent
        }
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
                    height: listViewHeight
                    listViewModel: WebsitesWithoutNone
                    listViewDelegate: listViewDelegateId
                    onCurrentIndexChanged: setcurrentWebsite(allWebstesIndex)
                }
                Item {
                    height: largeMargin
                    width: parent.width
                    visible: true
                }
                EditableText {
                    id: websiteNameId
                    isTextRequired: true
                    fieldLabel: qsTr("Website Name")
                    fieldText: currentWebsite.title
                    width: isPortraitMode ? modelListViewId.width : notesId.width * .497
                    onEditableTextChanged: onFieldChanged(
                                               websiteNameId.fieldText,
                                               currentWebsite.title)
                }
                WebsiteText {
                    id: websiteUrlId
                    isTextRequired: true
                    fieldLabel: qsTr("Website")
                    fieldText: currentWebsite.url
                    width: websiteNameId.width
                    onEditableTextChanged: onFieldChanged(
                                               websiteUrlId.fieldText,
                                               currentWebsite.url)
                }

                EditableText {
                    id: userIdId
                    fieldLabel: qsTr("User Id")
                    fieldText: currentWebsite.userId
                    width: websiteNameId.width
                    onEditableTextChanged: onFieldChanged(userIdId.fieldText,
                                                          currentWebsite.userId)
                }
                PasswordText {
                    id: passwordId
                    fieldText: currentWebsite.password
                    width: userIdId.width
                    onEditableTextChanged: onFieldChanged(
                                               passwordId.fieldText,
                                               currentWebsite.password)
                }

                EditableText {
                    id: notesId
                    fieldLabel: qsTr("Notes")
                    fieldText: currentWebsite.notes
                    width: modelListViewId.width
                    onEditableTextChanged: onFieldChanged(notesId.fieldText,
                                                          currentWebsite.notes)
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
                    setcurrentWebsite(index)
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
                        text: model.title
                        Layout.fillHeight: true
                        Layout.preferredWidth: field1Width
                    }
                    TitleTextDark {
                        id: fieldId2
                        text: model.url
                        Layout.preferredWidth: field2Width
                        Layout.fillHeight: true
                        Layout.fillWidth: true
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
                setcurrentWebsite(allWebsites.size())
            } else if (buttonImage.indexOf("remove") >= 0) {
                doRemove()
            }
        }
    }

    function getItemIndex(uniqueId) {
        if (allWebsites === undefined || allWebsites.isEmpty())
            return invalidIndex
        var index = invalidIndex
        for (var i =0; index === invalidIndex && i < allWebsites.size(); i++) {
            var item = allWebsites.get(i)
            if (item.uniqueId === uniqueId)
                index = i
        }
        return index
    }

    function setcurrentWebsite(listViewIndex) {
        if (allWebsites === undefined || allWebsites.size() <= listViewIndex) {
            websitesPageId.state = addingNewState
            currentWebsite = DataStoreManager.newItem(
                        SwitchboardCategory.Website)
        } else {
            websitesPageId.state = ""
            modelListViewId.listViewCurrentIndex = listViewIndex
            currentWebsite = allWebsites.get(listViewIndex)
            modelListViewId.positionViewAtIndex(listViewIndex, ListView.Visible)
        }
        assigncurrentWebsite()
        setIsDirty(false)
        modelListViewId.forceActiveFocus()
    }

    function assigncurrentWebsite() {
        if (currentWebsite === null) {
            setcurrentWebsite(0)
        } else {
            websiteUrlId.fieldText = currentWebsite.url
            userIdId.fieldText = currentWebsite.userId
            passwordId.fieldText = currentWebsite.password
            notesId.fieldText = currentWebsite.notes
            websiteNameId.fieldText = currentWebsite.title
        }
    }
    function doRemove() {
        DataStoreManager.removeItem(SwitchboardCategory.Website,
                                    currentWebsite.uniqueId)
        setcurrentWebsite(0)
        setIsDirty(false)
        modelListViewId.positionViewAtBeginning()
    }

    function doCancel() {
        setcurrentWebsite(modelListViewId.listViewCurrentIndex)
        setIsDirty(false)
    }

    function doTrySave() {
        if (websiteNameId.state === validDataState
                && websiteUrlId.state === validDataState) {
            currentWebsite.url = websiteUrlId.fieldText
            currentWebsite.userId = userIdId.fieldText
            currentWebsite.password = passwordId.fieldText
            currentWebsite.notes = notesId.fieldText
            currentWebsite.title = websiteNameId.fieldText
            DataStoreManager.saveItem(SwitchboardCategory.Website,
                                      websitesPageId.state === addingNewState,
                                      currentWebsite)

            allWebstesIndex = getItemIndex(currentWebsite.uniqueId)
            setcurrentWebsite(allWebstesIndex)
            setIsDirty(false)
            websitesPageId.state = ""
        } else {
            showTitledMessage(unableSaveTitle, requiredMessage)
        }
    }

    function onFieldChanged(fieldValue,currentValue) {
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
}
