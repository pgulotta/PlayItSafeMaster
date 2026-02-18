// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtQuick.Layouts
import QtCharts

Item {
    id: mainView
    width: 1280
    height: 720

    RowLayout {
        id: graphsRow

        readonly property real margin: mainView.width * 0.02

        anchors.fill: parent
        anchors.margins: margin
        spacing: margin

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            // border.width: 1
            radius: graphsRow.margin
            //! [bargraph]
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
                        color: "green"
                        exploded: true
                        //  onClicked: bankAccountsId.color = "yellow"
                    }
                    PieSlice {
                        //  labelPosition: LabelPosition.InsideHorizontal
                        id: investmentsSliceId
                        value: recapPageTabsId.summaryInvestments
                        label: "Investments"
                        color: "palegreen"
                        exploded: true
                        //  onHovered: investmentsSliceId.color = "gold"
                    }
                    PieSlice {
                        id: realAssetsSliceId
                        value: recapPageTabsId.summaryRealAssets
                        label: "Real Assets"
                        color: "seagreen"
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
