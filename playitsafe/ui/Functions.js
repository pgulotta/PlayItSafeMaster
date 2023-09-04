function getListIndexFromUniqueId(uniqueId, list) {
    var index = 0
    for (var i = 0; i < list.size(); i++) {
        var item = list.get(i)
        if (item.uniqueId === uniqueId) {
            index = i
            break
        }
    }
    return index
}

function formatDateToString(dateValue) {
    if (isNaN(dateValue))
        dateValue = new Date()
    return dateValue.toLocaleDateString(Qt.locale(), "dd MMM yyyy")
}

function formattedNumeric(fieldToFormat, decimalPlaces) {
    return fieldToFormat.toFixed(decimalPlaces)
}

function formatUrlink(url) {
    if (url === null)
        return ""
    else
        return url.toLowerCase().startsWith("http") ? url : "http://" + url
}

function formatCurrencyString(amount) {
    return qsTr("%1").arg(amount.toLocaleString(Qt.locale(), 'f', 3))
}
