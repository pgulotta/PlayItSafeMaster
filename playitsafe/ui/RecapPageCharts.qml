// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtQuick.Layouts
import QtGraphs

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
            color: "#262626"
            border.color: "#4d4d4d"
            border.width: 1
            radius: graphsRow.margin
            //! [bargraph]
            GraphsView {
                anchors.fill: parent
                anchors.margins: 16

                theme: GraphsTheme {
                    colorScheme: GraphsTheme.ColorScheme.Dark
                }

                PieSeries {
                    PieSlice {
                        //   labelPosition: LabelPosition.InsideHorizontal
                        value: recapPageTabsId.summaryBankAccounts
                        label: "Bank Accounts"
                    }
                    PieSlice {
                        ///     labelPosition: LabelPosition.InsideHorizontal
                        value: recapPageTabsId.summaryInvestments
                        label: "Investments"
                    }
                    PieSlice {
                        //    labelPosition: LabelPosition.InsideHorizontal
                        value: recapPageTabsId.summaryRealAssets
                        label: "Real Assets"
                    }
                    PieSlice {
                        // labelPosition: LabelPosition.InsideHorizontal
                        value: recapPageTabsId.summaryExpenses
                        label: "Expenses"
                    }
                }
            }
        }
    }
}
