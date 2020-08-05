#include "common.hpp"
#include <QDate>
#include <QUuid>

const QString Common::NewLine = QString("\n");

const QString Common::DateDisplayFormat{"dd MMM yyyy"};

const QString Common::WebsiteNoneText = {QObject::tr("None")};

const QString Common::WebsiteNoneId = {"c12a8a67-a3d5-45dd-9072-6d6da07b5c76"};

const QString Common::UndefinedWebsiteMessage = {
    QObject::tr("A website is not defined")};

const QString Common::DownloadsPathSettingsKey = {"DownloadsPath"};

const QString Common::AutoUpdateInvestmentPricesKey = {
    "autoUpdateInvestmentPrices"};

const std::string Common::Empty = {""};

const std::string Common::DeleteAllRecordsFrom{"DELETE FROM "};

QString Common::dateToInt64(const QDate &date) {
  return QString::number(date.toJulianDay());
}

QDate Common::int64ToDate(const QString &date) {
  return QDate::fromJulianDay(date.toLongLong());
}

QString Common::createUniqueId() {
  return QUuid::createUuid().toString().remove('{').remove('}');
}
