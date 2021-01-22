import QtQuick

Image {
    visible: true
    id: selectableImageId
    source: imageSource
    width: categoryWidth
    height: categoryHeight
    fillMode: Image.PreserveAspectFit
    horizontalAlignment: Image.AlignHCenter
    verticalAlignment: Image.AlignVCenter
}
