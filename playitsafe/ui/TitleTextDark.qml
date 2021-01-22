import QtQuick
import QtQuick.Controls

Label {
    id: textTitleLabelId

    wrapMode: Label.NoWrap
    font.pointSize: smallFontPointSize
    color: darkTextColor
    clip: true
    elide: Qt.ElideRight
    verticalAlignment: Text.AlignVCenter
    onTextChanged: fadeInTextId.start()

    AnimationFadeIn {
        id: fadeInTextId
        target: textTitleLabelId
    }
}
