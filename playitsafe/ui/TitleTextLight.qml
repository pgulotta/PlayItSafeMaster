import QtQuick
import QtQuick.Controls

Label {
    id: textTitleLabelId

    wrapMode: Label.NoWrap
    font.pointSize: smallFontPointSize
    color: lightTextColor
    clip: true
    elide: Qt.ElideRight
    anchors {
        left: parent.left
        leftMargin: itemMargin
    }
    verticalAlignment: Text.AlignVCenter
    onTextChanged: fadeInTextId.start()

    AnimationFadeIn {
        id: fadeInTextId
        target: textTitleLabelId
    }
}
