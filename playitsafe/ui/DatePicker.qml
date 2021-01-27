import QtQuick

ListView {
    id: datePickerId

    // public
    function set(date) {
        selectedDate = new Date(date)
        positionViewAtIndex((selectedDate.getFullYear(
                                 )) * 12 + selectedDate.getMonth(),
                            ListView.Center) // index from month year
    }

    signal clicked(date date)

    // onClicked: print('onClicked', date.toDateString())

    // private
    property var selectedDate: new Date()
    width: 200
    height: 150 // default size
    snapMode: ListView.SnapOneItem
    orientation: Qt.Horizontal
    clip: true

    model: 3000 * 12 // index == months since January of the year 0

    delegate: Item {
        property int year: Math.floor(index / 12)
        property int month: index % 12 // 0 January
        property int firstDay: new Date(year, month,
                                        1).getDay() // 0 Sunday to 6 Saturday

        width: datePickerId.width
        height: datePickerId.height

        Column {
            Item {
                // month year header
                width: datePickerId.width
                height: datePickerId.height - grid.height

                Text {
                    // month year
                    anchors.centerIn: parent
                    text: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][month] + ' ' + year
                    font {
                        pixelSize: 0.5 * grid.cellHeight
                    }
                }
            }

            Grid {
                // 1 month calender
                id: grid

                width: datePickerId.width
                height: 0.875 * datePickerId.height
                property real cellWidth: width / columns
                property real cellHeight: height
                                          / rows // width and height of each cell in the grid.

                columns: 7 // days
                rows: 7

                Repeater {
                    model: grid.columns * grid.rows // 49 cells per month

                    delegate: Rectangle {
                        // index is 0 to 48
                        property int day: index - 7 // 0 = top left below Sunday (-7 to 41)
                        property int date: day - firstDay + 1 // 1-31

                        width: grid.cellWidth
                        height: grid.cellHeight
                        border.width: 0.3 * radius
                        border.color: new Date(year, month, date).toDateString(
                                          ) == selectedDate.toDateString()
                                      && text.text
                                      && day >= 0 ? 'black' : 'transparent' // selected
                        radius: 0.02 * datePickerId.height
                        opacity: !mouseArea.pressed ? 1 : 0.3 //  pressed state

                        Text {
                            id: text

                            anchors.centerIn: parent
                            font.pixelSize: 0.5 * parent.height
                            font.bold: new Date(year, month, date).toDateString(
                                           ) == new Date().toDateString(
                                           ) // today
                            text: {
                                if (day < 0)
                                    ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index] // Su-Sa
                                else if (new Date(year, month,
                                                  date).getMonth() == month)
                                    date // 1-31
                                else
                                    ''
                            }
                        }

                        MouseArea {
                            id: mouseArea

                            anchors.fill: parent
                            enabled: text.text && day >= 0

                            onClicked: {
                                selectedDate = new Date(year, month, date)
                                datePickerId.clicked(selectedDate)
                            }
                        }
                    }
                }
            }
        }
    }

    // Component.onCompleted: set(new Date()) // today (otherwise Jan 0000)
}
