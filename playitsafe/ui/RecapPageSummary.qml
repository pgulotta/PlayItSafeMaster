import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Recap
import BankAccount
import Investment
import RealAsset
import Expense
import "Functions.js" as Functions

Page {
    //   id: recapPageSummaryId
    objectName: "RecapPageSummary"

    property double summaryTotal
    property double summaryBankAccounts
    property double summaryInvestments
    property double summaryRealAssets
    property double summaryExpenses
    property double summaryTotals

    visible: true
    height: parent.height
    width: parent.width

    Component.onCompleted: {
        for (var i = 0; i < RecapList.size(); i++) {
            summaryTotal += RecapList.get(i).amount
        }
        for (i = 0; i < AllBankAccounts.size(); i++) {
            summaryBankAccounts += AllBankAccounts.get(i).amount
        }
        for (i = 0; i < AllInvestments.size(); i++) {
            summaryInvestments += AllInvestments.get(
                        i).shares * AllInvestments.get(i).lastPrice
        }
        for (i = 0; i < AllRealAssets.size(); i++) {
            summaryRealAssets += AllRealAssets.get(i).valuation
        }
        for (i = 0; i < AllExpenses.size(); i++) {
            summaryExpenses += AllExpenses.get(i).amount
        }

        summaryTotals = summaryBankAccounts + summaryInvestments
                + summaryRealAssets - summaryExpenses
    }

    id: textPage
    Rectangle {
        width: parent.width
        height: parent.height
        color: rootId.categoryRecapColor
        Column {
            spacing: 40
            leftPadding: 50
            topPadding: 50
            Text {
                text: "Summary Total:  " + Functions.formatCurrencyString(
                          summaryTotals)
                font.bold: true
            }

            Text {
                text: "    Bank Accounts Total:  " + Functions.formatCurrencyString(
                          summaryBankAccounts)
            }
            Text {
                text: "    Investments Total:  " + Functions.formatCurrencyString(
                          summaryInvestments)
            }
            Text {
                text: "    Real Assets Total:  " + Functions.formatCurrencyString(
                          summaryRealAssets)
                color: "blue"
            }
            Text {
                text: "    Expenses Total:  (" + Functions.formatCurrencyString(
                          summaryExpenses) + ")"
            }
        }
    }
}
