import QtQuick
import QtQuick.Layouts
import QtCharts

Item {
    id: mainView
    width: 1280
    height: 720

    RowLayout {
        id: graphsRow

        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.width: 10
            border.color: rootId.categoryRecapColor

            ChartView {
                anchors.fill: parent
                backgroundColor: rootId.categoryRecapColor
                legend.visible: true
                antialiasing: true

                PieSeries {
                    PieSlice {
                        id: bankAccountsId
                        value: recapPageTabsId.summaryBankAccounts
                        label: "Bank Accounts"
                        color: rootId.categoryBankAccountsColor
                        exploded: true
                    }
                    PieSlice {
                        id: investmentsSliceId
                        value: recapPageTabsId.summaryInvestments
                        label: "Investments"
                        color: rootId.categoryInvestmentsColor
                        exploded: true
                    }
                    PieSlice {
                        id: realAssetsSliceId
                        value: recapPageTabsId.summaryRealAssets
                        label: "Real Assets"
                        color: rootId.categoryAssetColor
                        exploded: true
                    }
                    PieSlice {
                        //     labelPosition: LabelPosition.InsideHorizontal
                        value: recapPageTabsId.summaryExpenses
                        label: "Expenses"
                        exploded: true
                        color: "red"
                    }
                }
            }
        }
    }
}
