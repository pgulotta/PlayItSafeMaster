import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import SwitchboardCategory
import "Functions.js" as Functions

Page {
    //   id: recapPageSummaryId
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
                          summaryTotals)

                color: "black"
                font.pointSize: rootId.largeFontPointSize
            }

            Text {
                text: "    Bank Accounts Total:  " + Functions.formatCurrencyString(
                          summaryBankAccounts)
                color: "green"
                font.pointSize: rootId.fontPointSize
            }
            Text {
                text: "    Investments Total:  " + Functions.formatCurrencyString(
                          summaryInvestments)
                color: "green"
                font.pointSize: rootId.fontPointSize
            }
            Text {
                text: "    Real Assets Total:  " + Functions.formatCurrencyString(
                          summaryRealAssets)
                color: "green"
                font.pointSize: fontPointSize
            }
            Text {
                text: "    Expenses Total:  (" + Functions.formatCurrencyString(
                          summaryExpenses) + ")"
                color: "red"
                font.pointSize: rootId.fontPointSize
            }
        }
    }
}
