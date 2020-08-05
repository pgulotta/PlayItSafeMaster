import QtQuick 2.9
import QtQuick.Controls 2.2

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
