#pragma once

#include <QObject>
#include <QString>

class QDate;


struct Common {
 public:
  static const QString NewLine;
  static const QString DateDisplayFormat;
  static const QString WebsiteNoneText;
  static const QString WebsiteNoneId;
  static const QString UndefinedWebsiteMessage;
  static const QString DownloadsPathSettingsKey;
  static const QString AutoUpdateInvestmentPricesKey;
  static const std::string Empty;
  static const std::string DeleteAllRecordsFrom;
  static QDate int64ToDate(const QString& date);
  static QString dateToInt64(const QDate& date);
  static QString createUniqueId();
};

