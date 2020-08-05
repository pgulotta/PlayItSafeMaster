import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0

Dialog {
  id: settingsUpdatePricesDialogId
  objectName: "SettingsUpdatePricesDialog"

  visible: true
  modal: true
  width: isPortraitMode ? windowWidth * .9 : windowWidth * .6
  title: qsTr("Update Investment Prices")
  parent: ApplicationWindow.overlay
  x: (parent.width - width) * .5
  y: (parent.height - height) * .5
  contentHeight: textWithTitleHeight
  standardButtons: Dialog.Cancel | Dialog.Ok
  onAccepted: settingsId.autoUpdateInvestmentPrices = autoUpdatePricesSwitchId.checked
  onRejected: close()

  Settings {
    id: settingsId
    property bool autoUpdateInvestmentPrices: true
  }

  RowLayout {
    id: rowLayoutId
    anchors.fill: parent
    anchors.right: parent.right
    anchors.left: parent.right
    anchors.leftMargin: itemMargin
    Switch {
      id: autoUpdatePricesSwitchId
      font.pointSize: smallFontPointSize
      text: qsTr("On startup, update prices?")
      checked: settingsId.autoUpdateInvestmentPrices
    }
  }
}
