import QtQuick
import QtQuick.Controls

Label {
    id: textTitleLabelId

    wrapMode: Label.NoWrap

    topPadding: 4
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
