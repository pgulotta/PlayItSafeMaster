import QtQuick 2.9

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
