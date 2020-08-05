import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

ScrollablePage {
    id: aboutPageId
    objectName: "AboutPage"
    height: parent.height
    width: parent.width
    visible: true

    Component.onCompleted: {
        initializeToolbar(true, appNameVersion)
    }

    Grid {
        id: aboutGridId
        width: parent.width * 0.80
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: largeMargin
            rightMargin: isSmallScreenDevice ? largeIndent : 2 * largeIndent
            topMargin: largeMargin
            bottomMargin: largeMargin
        }
        columns: 1
        HtmlText {
            text: qsTr("About")
            isTitle: true
        }
        HtmlText {
            websiteLink: "https://sites.google.com/site/playitsafe26apps/"
            text: appNameVersion + qsTr(
                      " from 26Apps is a great tool that helps to easily manage finances by organizing savings and spending. " + " You can use this app on your mobile device, and on your computer as well since there are " + appName + " versions for mobile, PC, Mac, and Linux. For more details, please visit <a href=\""
                      + websiteLink + "\"> Play It Safe.</a>")
            isTitle: false
        }
        Rectangle {
            color: "transparent"
            height: largeMargin
            width: 1
            visible: true
        }
        HtmlText {
            text: qsTr("Feedback")
            isTitle: true
        }
        HtmlText {
            websiteLink: "https://play.google.com/store/apps/details?id=com.twentysixapps.playitsafe"
            text: qsTr("Leave feedback or rate " + appName + ", "
                       + "please visit <a href=\"" + websiteLink + "\"> Google Play</a>")
            isTitle: false
        }
        Rectangle {
            color: "transparent"
            height: largeMargin
            width: 1
            visible: true
        }
        HtmlText {
            isTitle: true
            text: qsTr("Privacy")
        }
        HtmlText {
            websiteLink: "https://sites.google.com/site/playitsafe26apps/"
            text: appName + qsTr(
                      " does not request or share any personal information with third parties. "
                      + "It does not request or know the user's physical location. "
                      + "To review the privacy policy, please visit <a href=\""
                      + websiteLink + "\"> Play It Safe.</a>")

            isTitle: false
        }
        Rectangle {
            color: "transparent"
            height: largeMargin
            width: 1
            visible: true
        }
        HtmlText {
            isTitle: true
            text: qsTr("Credits")
        }
        HtmlText {
            websiteLink: "https://iextrading.com/api-exhibit-a/"
            text: qsTr("Investment data provided for free by <a href=\"" + websiteLink + "\"> IEX.</a>")
            isTitle: false
        }
        Text {
            text: " "
        }
        HtmlText {
            websiteLink: "https://openclipart.org/"
            text: "<a href=\"" + websiteLink + "\">Openclipart</a>"
                  + " provides some graphics displayed in " + appName + "."
            isTitle: false
        }
        Text {
            text: " "
        }
        HtmlText {
            websiteLink: "https://www.qt.io/"
            text: "<a href=\"" + websiteLink + "\">Qt Company Tools and IDE</a>"
                  + "  are used to develop " + appName + "."
            isTitle: false
        }
        Text {
            text: " "
        }
        HtmlText {
            websiteLink: "https://www1.qt.io/qt-licensing-terms/"
            text: appName + qsTr(
                      " is developed under the Qt Company GNU Lesser General Public License v. 3 (“LGPL”) open-source license. For details, please visit, "
                      + "<a href=\"" + websiteLink + "\">Qt open source license terms.</a>")
            isTitle: false
        }

        Rectangle {
            color: "transparent"
            height: largeMargin
            width: 1
            visible: true
        }
        HtmlText {
            text: qsTr("Disclaimer")
            isTitle: true
        }
        HtmlText {
            websiteLink: "https://sites.google.com/site/playitsafe26apps/"
            text: appName + qsTr(
                      " provided by 26Apps is supplied 'AS IS' without any warranties and support. "
                      + "For details, please visit <a href=\"" + websiteLink
                      + "\"> Play It Safe website.</a>")
            isTitle: false
        }
    }
}
