import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Website
import "Functions.js" as Functions

Rectangle {
    id: websitePickerId

    signal websiteChanged(string websiteUniqueId)

    property alias allWebsites: textComboBoxId.model
    property alias currentWebsiteIndex: textComboBoxId.currentIndex
    property alias websiteContentItem: contentItemTextId.text
    property string fieldLabel
    property string currentWebsiteUniqueId

    width: fieldColumnWidth
    //  height: textWithTitleHeight
    height: isAndroid ? 84 : textWithTitleHeight
    radius: rectRadius
    color: fieldBackColor
    border.color: darkTextColor
    border.width: rectBorder

    Component.onCompleted: fadeInTextId.start()

    TitleTextLight {
        id: labelId
        text: fieldLabel
        width: categoryWidth * 1.25
        topPadding: itemMargin
    }
    ToolButton {
        id: wwwButtonId
        z: 1
        anchors {
            rightMargin: itemIndent
            right: forwardButtonId.left
        }
        icon.source: "qrc:/images/www.png"
        icon.color: lightTextColor
        width: buttonImageSize
        height: buttonImageSize
        onClicked: {
            if (!allWebsites.isEmpty()) {
                var websiteItem = allWebsites.get(currentWebsiteIndex)
                if (websiteItem.url === "")
                    console.log("No website defined for selected item")
                else {
                    var theLink = Functions.formatUrlink(websiteItem.url)
                    console.log(theLink + " opening in browser")
                    Qt.openUrlExternally(theLink)
                }
            }
        }
    }

    ToolButton {
        id: forwardButtonId
        z: 1
        anchors {
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
        }
        icon.source: "qrc:/images/forward.png"
        icon.color: lightTextColor
        width: buttonImageSize
        height: buttonImageSize
        onClicked: {
            if (!allWebsites.isEmpty()) {
                var websiteItem = allWebsites.get(currentWebsiteIndex)
                if (websiteItem.url === "")
                    console.log("No website defined for selected item")
                else {
                    websitePageId.initialWebsiteListUniqeId = websiteItem.uniqueId
                    stackViewId.push(websitePageId)
                }
            }
        }
    }

    ComboBox {
        id: textComboBoxId
        model: AllWebsites
        spacing: isSmallScreenDevice ? smalltemMargin : itemIndent
        anchors.fill: parent
        anchors.margins: isSmallScreenDevice ? smalltemMargin : itemMargin
        anchors.topMargin: isSmallScreenDevice ? mediumMargin : largeMargin
        anchors.bottomMargin: itemMargin

        contentItem: Text {
            id: contentItemTextId
            text: getWebsiteTitle()
            color: darkTextColor
            topPadding: largeMargin
            padding: itemMargin
        }
        background: Rectangle {
            id: rectComboBoxId
            width: textComboBoxId.width
            anchors.bottom: parent.bottom
            radius: rectRadius
            color: itemBackColor
            border.color: darkTextColor
            border.width: rectBorder
        }

        delegate: ItemDelegate {
            text: model.title
            topPadding: 12
            highlighted: ListView.isCurrentItem
            onClicked: {
                websiteChanged(allWebsites.get(model.index).uniqueId)
                contentItemTextId.text = allWebsites.get(model.index).title
                currentWebsiteUniqueId = allWebsites.get(model.index).uniqueId
            }
        }
    }

    AnimationFadeIn {
        id: fadeInTextId
        target: textComboBoxId
    }
    WebsitesPage {
        id: websitePageId
        visible: false
    }

    function setWebsiteTitle(websiteUniqueId) {
        if (websiteUniqueId === null) {
            contentItemTextId.text = ""
        } else {
            currentWebsiteUniqueId = websiteUniqueId
            contentItemTextId.text = getWebsiteTitle()
        }
    }
    function getWebsiteTitle() {
        var title = ""
        if (allWebsites === undefined || allWebsites.isEmpty())
            return title
        for (var i = 0; i < allWebsites.size(); i++) {
            var website = allWebsites.get(i)
            if (website.uniqueId === currentWebsiteUniqueId) {
                title = website.title
                currentWebsiteIndex = i
                break
            }
        }
        return title
    }
}
