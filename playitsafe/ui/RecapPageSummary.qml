import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Recap
import "Functions.js" as Functions

Page {
    id: recapPageSummaryId
    objectName: "RecapPageSummary"

    property double summaryTotal

    visible: true
    height: parent.height
    width: parent.width

    Component.onCompleted: {
        for (var i = 0; i < RecapList.size(); i++) {
            summaryTotal += RecapList.get(i).amount
        }
    }

    Rectangle {
        color: rootId.categoryRecapColor
        anchors.fill: parent
        Column {
            anchors.centerIn: parent
            width: parent.width

            HtmlText {
                text: "Total " + Functions.formatCurrencyString(summaryTotal)
                isTitle: true
            }

            HtmlText {
                text: Functions.formatCurrencyString(summaryTotal)
                isTitle: true
            }
        }
    }
}
