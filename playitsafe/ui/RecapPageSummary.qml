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
    id: recapPageSummaryId
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
        console.log(" Component.onCompleted:   +++++++++++++++++++++++++++")
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

    Rectangle {
        color: rootId.categoryRecapColor
        anchors.fill: parent
        Column {
            anchors.centerIn: parent
            width: parent.width

            HtmlText {
                text: "Summary total:   " + Functions.formatCurrencyString(
                          summaryTotal)
                isTitle: true
            }

            HtmlText {
                text: "Bank Accounts total:  " + Functions.formatCurrencyString(
                          summaryBankAccounts)
                isTitle: true
            }

            HtmlText {
                text: "Investments total:  " + Functions.formatCurrencyString(
                          summaryInvestments)
                isTitle: true
            }

            HtmlText {
                text: "Real Assets total:  " + Functions.formatCurrencyString(
                          summaryRealAssets)
                isTitle: true
            }

            HtmlText {
                text: "Expenses total:  " + Functions.formatCurrencyString(
                          summaryExpenses)
                isTitle: true
            }

            HtmlText {
                text: "Total:  " + Functions.formatCurrencyString(summaryTotals)
                isTitle: true
            }
        }
    }
}
