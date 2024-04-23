import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import SwitchboardCategory

ApplicationWindow {
    id: rootId
    objectName: "MainPage"

    readonly property int famAddNew: 1
    readonly property int famRemoveCurrent: 2
    readonly property int famSaveChanges: 3
    readonly property int famCancelChanges: 4
    readonly property int animationDuration: 500
    readonly property int shortAnimationDuration: 250
    readonly property int longAnimationDuration: 1000
    readonly property int buttonImageSize: 32
    readonly property int rectBorder: 1
    readonly property int fieldRectBorder: 2
    readonly property int verticalMargin: 4
    readonly property int smalltemMargin: 2
    readonly property int itemMargin: 6
    readonly property int rectRadius: 4
    readonly property int itemIndent: 12
    readonly property int mediumMargin: 16
    readonly property int largeMargin: 24
    readonly property int largeIndent: 40
    readonly property int buttonDimension: 100
    readonly property int invalidIndex: -1
    readonly property bool isAndroid: Qt.platform.os === "android"
    readonly property bool isLinux: Qt.platform.os === "linux"
    readonly property string urlFilePrefix: isLinux ? "file://" : "file:///"
    readonly property string importTitle: qsTr("Import Data Store")
    readonly property string importSuccessfulMessage: qsTr("The import was successful")
    readonly property string importFailedMessage: qsTr("Import failed, the selected file or password is not valid.")
    readonly property string validDataState: "valid"
    readonly property string addingNewState: "addNew"
    readonly property string routingNumberRegExp: "[0-9]{9}$"
    readonly property string lightTextColor: "white"
    readonly property string darkTextColor: "black"
    readonly property string categoryHighlightColor: "#D6D4C7"
    readonly property string appBackColor: "#FFF9C4"
    readonly property string appToolbarColor: "#979376"
    readonly property string categoryAssetColor: "#66BB6A"
    readonly property string categoryLiabilityColor: "#EF9A9A"
    readonly property string categoryWebColor: "#74bee1"
    readonly property string categoryRecapColor: "#CCC79C"
    readonly property string requiredTextColor: "#F44336"
    readonly property string itemBackColor: "#FFFFFF"
    readonly property string negativeNumberColor: "#FF0000"
    readonly property string actionMenuColor: darkTextColor
    readonly property string fieldBackColor: appToolbarColor
    readonly property string unableSaveTitle: qsTr("Unable to Save")
    readonly property string unableRemoveTitle: qsTr("Unable to Remove")
    readonly property string unableOpenTitle: qsTr("Unable to Open")
    readonly property string enterPasswrdMessage: qsTr("Please provide a valid password.")
    readonly property string requiredMessage: qsTr("Please provide required fields which are indicated with a red border.")
    readonly property string appName: SwitchboardManager.appName
    readonly property string appNameVersion: SwitchboardManager.appNameVersion
    readonly property date defaultDate: new Date()
    readonly property bool isSmallScreenDevice: Screen.devicePixelRatio >= 2
    property string toolbarTitle: SwitchboardManager.appName
    property bool isPortraitMode: Screen.height > Screen.width
    property string toolbarIcon: "qrc:/images/menu.png"
    property int windowHeight: isAndroid ? Screen.desktopAvailableHeight : Screen.desktopAvailableHeight * .8
    property int windowWidth: isAndroid ? Screen.width : Screen.width * .5
    property int toolbarHeight: isSmallScreenDevice ? 36 : 50
    property int listViewDelegateHeight: isSmallScreenDevice ? 32 : 36
    property int drawerWidth: isPortraitMode ? rootId.width * .75 : rootId.width * .4
    property int textWithTitleHeight: isSmallScreenDevice ? toolbarHeight
                                                            * 1.6 : toolbarHeight * 1.7
    property int listViewHeight: isSmallScreenDevice ? (isPortraitMode ? windowHeight * .24 : windowHeight * .18) : windowHeight * .5
    property int fabFontPointSize: 12
    property int checkboxBoxSize: isSmallScreenDevice ? 18 : 24
    property int verySmallFontPointSize: 10
    property int smallFontPointSize: 12
    property int fontPointSize: isSmallScreenDevice ? 18 : 16
    property int largeFontPointSize: fontPointSize + 4
    property int switchboardFontPointSize: isSmallScreenDevice
    property int switchboardColumnCount: isPortraitMode ? 2 : 3
    property int columnRowSpacing: isSmallScreenDevice ? (isPortraitMode ? 4 : 8) : 16
    property int categoryWidth: windowWidth / (1 + switchboardColumnCount)
    property int categoryHeight: isPortraitMode ? categoryWidth + 1.5 :categoryWidth
    property int switchboardHeight: categoryHeight
    property int drawerImageHeight: categoryHeight * 0.5
    property int fieldColumnWidth: isPortraitMode ? windowWidth * 0.475 : windowWidth * .315
    property int listViewWidth: isPortraitMode ? rootId.width * .96 : rootId.width
                                                 - (4 * itemMargin)

    height: windowHeight
    width: windowWidth
    visible: true
    color: appBackColor

    header: AppToolbar {
        id: appToolbarId
    }

    StackView {
        id: stackViewId
        anchors.fill: parent
    }

    Rectangle {
        Keys.onBackPressed: {
            event.accepted = true
            Qt.quit()
        }
    }

    MainDrawer {
        id: mainDrawerId
    }

    DataStorePasswordDialog {
        state: DataStoreManager.isPasswordNew() ? "new" : "validate"
    }

    Timer {
        id: hideKeyboardTImer
        interval: 10
        repeat: false
        running: false
        onTriggered: Qt.inputMethod.hide()
    }

    TitledMessageDialog {
        id: titledMessageDialogId
        visible: false
    }

    function showTitledMessage(dialogTitle, message) {
        titledMessageDialogId.title = dialogTitle
        titledMessageDialogId.dialogMessage = message
        titledMessageDialogId.open()
    }

    function hideKeyboard() {
        hideKeyboardTImer.start()
    }

    function closeAppDrawer() {
        mainDrawerId.close()
    }

    function initializeToolbar(isEnabled, title) {
        enableAppToolbar(isEnabled)
        toolbarIcon = "qrc:/images/back.png"
        toolbarTitle = title
    }

    function isToolbarEnabled() {
        return appToolbarId.enabled
    }

    function enableAppToolbar(shouldEnable) {
        appToolbarId.enabled = shouldEnable
    }

    function getCategoryColor(category) {
        var categoryGroup = Number(category)
        if (categoryGroup === SwitchboardCategory.Asset)
            return categoryAssetColor
        else if (categoryGroup === SwitchboardCategory.Liability)
            return categoryLiabilityColor
        else if (categoryGroup === SwitchboardCategory.Web)
            return categoryWebColor
        else if (categoryGroup === SwitchboardCategory.Reporting)
            return categoryRecapColor
        return Qt.darker(appBackColor)
    }
}
