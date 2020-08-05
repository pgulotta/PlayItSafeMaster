import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtCharts 2.0
import Recap 1.0
import SwitchboardCategory 1.0
import "Functions.js" as Functions

Page {
    id: chartPageId
    objectName: "ChartPage"

    property double bankAccountTotal: 0
    property double investmentTotal: 0
    property double expenseTotal: 0
    property double realAssetTotal: 0
    property double grandTotal: 0
    readonly property SwitchboardCategory category: AllCategories.get(
                                                        SwitchboardCategory.Recap)
    property string explodedPieSliceLabel: AllCategories.get(
                                               SwitchboardCategory.BankAccount).title

    height: parent.height
    width: parent.width
    visible: true

    Component.onCompleted: {
        initializeToolbar(true, category.title)
        calcCategoryTotals()
    }

    ChartView {
        width: parent.width
        height: parent.height
        backgroundColor: appBackColor
        anchors.fill: parent
    //    legend.visible: true
        title: Functions.formatCurrencyString(grandTotal)
        titleFont.pointSize: largeFontPointSize
        titleColor: grandTotal < 0 ? negativeNumberColor : darkTextColor
        antialiasing: isAndroid ? false : true
        animationOptions: ChartView.AllAnimations

        PieSeries {
            id: pieSeriesId

            onHovered: slice.exploded = state
            onPressed: slice.label = Functions.formatCurrencyString(slice.value)
            onReleased: slice.label = getTitle(slice)

            PieSlice {
                id: bankAccountSliceId
                label: getTitle(bankAccountSliceId)
                labelFont.pointSize: fontPointSize
                labelColor: darkTextColor
                labelVisible: true
                value: bankAccountTotal
                color: Qt.darker(
                           getCategoryColor(
                               AllCategories.get(
                                   SwitchboardCategory.BankAccount).group))
            }
            PieSlice {
                id: investmentSliceId
                label: getTitle(investmentSliceId)
                labelFont.pointSize: fontPointSize
                labelColor: darkTextColor
                labelVisible: true
                value: investmentTotal
                color: getCategoryColor(
                           AllCategories.get(
                               SwitchboardCategory.Investment).group)
            }
            PieSlice {
                id: realAssetSliceId
                label: getTitle(realAssetSliceId)
                labelFont.pointSize: fontPointSize
                labelColor: darkTextColor
                labelVisible: true
                value: realAssetTotal
                color: Qt.lighter(getCategoryColor(
                                      AllCategories.get(
                                          SwitchboardCategory.RealAsset).group))
            }
            PieSlice {
                id: expenseSliceId
                label: getTitle(expenseSliceId)
                labelFont.pointSize: fontPointSize
                labelColor: negativeNumberColor
                labelVisible: true
                value: expenseTotal
                color: getCategoryColor(AllCategories.get(
                                            SwitchboardCategory.Expense).group)
            }
        }
    }

    function getTitle(pieSlice) {
        var title
        switch (pieSlice) {
        case bankAccountSliceId:
            title = AllCategories.get(SwitchboardCategory.BankAccount).title
            break
        case investmentSliceId:
            title = AllCategories.get(SwitchboardCategory.Investment).title
            break
        case realAssetSliceId:
            title = AllCategories.get(SwitchboardCategory.RealAsset).title
            break
        case expenseSliceId:
            title = AllCategories.get(SwitchboardCategory.Expense).title
            break
        }
        return title
    }

    function calcCategoryTotals() {
        bankAccountTotal = 0
        investmentTotal = 0
        expenseTotal = 0
        realAssetTotal = 0
        grandTotal = 0
        for (var i = 0; i < RecapList.size(); i++) {
            var item = RecapList.get(i)
            if (item.enabled) {
                grandTotal += item.amount

                switch (item.section) {
                case AllCategories.get(SwitchboardCategory.BankAccount).title:
                    bankAccountTotal += item.amount
                    break
                case AllCategories.get(SwitchboardCategory.Investment).title:
                    investmentTotal += item.amount
                    break
                case AllCategories.get(SwitchboardCategory.RealAsset).title:
                    realAssetTotal += item.amount
                    break
                case AllCategories.get(SwitchboardCategory.Expense).title:
                    expenseTotal += item.amount
                    break
                default:
                    console.assert("Invalid unsupported setting")
                }
            }
        }
        if (bankAccountTotal === 0)
            pieSeriesId.remove(bankAccountSliceId)
        if (investmentTotal === 0)
            pieSeriesId.remove(investmentSliceId)
        if (realAssetTotal === 0)
            pieSeriesId.remove(realAssetSliceId)
        if (expenseTotal === 0)
            pieSeriesId.remove(expenseSliceId)
    }
}
