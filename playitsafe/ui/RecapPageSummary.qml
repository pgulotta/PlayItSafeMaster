import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import SwitchboardCategory
import "Functions.js" as Functions

Page {
    objectName: "RecapPageSummary"

    visible: true
    height: parent.height
    width: parent.width

    Rectangle {
        width: parent.width
        height: parent.height
        color: rootId.categoryRecapColor
        Column {
            spacing: rootId.largeMargin
            leftPadding: rootId.largeMargin
            topPadding: rootId.largeMargin
            Text {
                text: "Summary Total:  " + Functions.formatCurrencyString(
                          recapPageTabsId.summaryTotal)
                color: "black"
                font.pointSize: rootId.largeFontPointSize
            }

            Text {
                text: "    Bank Accounts Total:  " + Functions.formatCurrencyString(
                          recapPageTabsId.summaryBankAccounts)
                color: rootId.categoryBankAccountsColor
                font.pointSize: rootId.fontPointSize
            }
            Text {
                text: "    Investments Total:  " + Functions.formatCurrencyString(
                          recapPageTabsId.summaryInvestments)
                color: rootId.categoryInvestmentsColor
                font.pointSize: rootId.fontPointSize
            }
            Text {
                text: "    Real Assets Total:  " + Functions.formatCurrencyString(
                          recapPageTabsId.summaryRealAssets)
                color:  rootId.categoryAssetColor
                font.pointSize: fontPointSize
            }
            Text {
                text: "    Expenses Total:  (" + Functions.formatCurrencyString(
                          recapPageTabsId.summaryExpenses) + ")"
                color: "red"
                font.pointSize: rootId.fontPointSize
            }
        }
    }
}
