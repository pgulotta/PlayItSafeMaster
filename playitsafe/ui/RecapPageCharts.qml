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
                axisX: BarCategoryAxis {
                    categories: [2024, 2025, 2026]
                    gridVisible: false
                    subGridVisible: false
                }
                axisY: ValueAxis {
                    min: 20
                    max: 100
                    tickInterval: 10
                    subTickCount: 9
                }
                theme: GraphsTheme {
                    colorScheme: GraphsTheme.ColorScheme.Dark
                    theme: GraphsTheme.Theme.QtGreen
                }
                //! [bargraph]
                //! [barseries]
                BarSeries {
                    //! [barseries]
                    //! [barset]
                    BarSet {
                        values: [82, 50, 75]
                        borderWidth: 2
                        color: "#373F26"
                        borderColor: "#DBEB00"
                    }
                    //! [barset]
                }
            }
        }
    }
}
