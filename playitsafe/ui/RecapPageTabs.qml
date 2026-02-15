import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Recap
import BankAccount
import Investment
import RealAsset
import Expense

Page {
    id: recapPageTabsId
    objectName: "RecapPageTabs"
    visible: true

    property double summaryTotal
    property double summaryBankAccounts
    property double summaryInvestments
    property double summaryRealAssets
    property double summaryExpenses
    property double summaryTotals

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

    // Header with TabBar
    header: TabBar {
        id: tabBarId
        currentIndex: 0

        TabButton {
            text: qsTr("Summary")
        }
        TabButton {
            text: qsTr("Details")
        }
        TabButton {
            text: qsTr("Chart")
        }
    }

    // Content view managed by TabBar
    StackLayout {
        anchors.fill: parent
        currentIndex: tabBarId.currentIndex

        RecapPageSummary {}

        RecapPage {}

        Rectangle {
            color: "blue"
            Label {
                text: "Chart View"
                anchors.centerIn: parent
            }
        }
    }
}
