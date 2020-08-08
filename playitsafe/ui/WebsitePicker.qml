import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as ButtonControl
import QtQuick.Controls.Styles 1.4
import Website 1.0
import "Functions.js" as Functions

Rectangle {
    id: websitePickerId

    signal websiteChanged(string websiteUniqueId)

    property alias allWebsites: textComboBoxId.model
    property alias currentWebsiteIndex: textComboBoxId.currentIndex
    property alias websiteContentItem: contentItemTextId.text
    property string fieldLabel
    property string currentWebsiteUniqueId
    property int initialWebsiteListIndex: 0

    width: fieldColumnWidth
    height: textWithTitleHeight
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
    ButtonControl.Button {
        id: wwwButtonId
        anchors {
            rightMargin: itemIndent
            right: forwardButtonId.left
            topMargin: isSmallScreenDevice ? rectBorder: itemMargin
            top: parent.top
        }
        style: ButtonStyle {
            label: Image {
                source: "qrc:/images/www.png"
                fillMode: Image.PreserveAspectFit
            }
            background: Rectangle {
                color: wwwButtonId.hovered ? (wwwButtonId.pressed ? appToolbarColor : categoryHighlightColor) : "transparent"
            }
        }
        onClicked: {
            if (!allWebsites.isEmpty()) {
                var websiteItem = allWebsites.get(currentWebsiteIndex)
                if (websiteItem.url !== "")
                    Qt.openUrlExternally(Functions.formatUrlink(
                                             websiteItem.url))
            }
        }
    }
    ButtonControl.Button {
        id: forwardButtonId
        anchors {
            rightMargin: isSmallScreenDevice ? itemMargin : itemIndent
            right: parent.right
            topMargin: isSmallScreenDevice ? rectBorder: itemMargin
            top: parent.top
        }
        style: ButtonStyle {
            label: Image {
                source: "qrc:/images/forward.png"
                fillMode: Image.PreserveAspectFit
            }
            background: Rectangle {
                color: forwardButtonId.hovered ? (forwardButtonId.pressed ? appToolbarColor : categoryHighlightColor) : "transparent"
            }
        }
        onClicked: {
            websitePageId.initialWebsiteListIndex = currentWebsiteIndex
            stackViewId.push(websitePageId)
        }
    }

    ComboBox {
        id: textComboBoxId
        model: AllWebsites
        spacing: isSmallScreenDevice ? smalltemMargin : itemIndent
        anchors.fill: parent
        anchors.margins: isSmallScreenDevice ? smalltemMargin :itemMargin
        anchors.topMargin: isSmallScreenDevice ? mediumMargin : largeMargin

        contentItem: Text {
            id: contentItemTextId
            text: getWebsiteTitle()
            font.pointSize: smallFontPointSize
            color: darkTextColor
            topPadding: isSmallScreenDevice ? mediumMargin : largeMargin
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
            width: parent.width
            highlighted: ListView.isCurrentItem
            font.pointSize: smallFontPointSize
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
        for (var i=0; i < allWebsites.size(); i++) {
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