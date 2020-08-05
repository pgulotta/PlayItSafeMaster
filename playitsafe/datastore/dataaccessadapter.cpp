#include "dataaccessadapter.hpp"
#include "../model/switchboardcategory.hpp"
#include "../model/version.hpp"
#include "../model/recap.hpp"
#include "../model/bankaccount.hpp"
#include "../model/website.hpp"
#include "../model/investment.hpp"
#include "../model/realasset.hpp"
#include "../model/expense.hpp"
#include "../model/common.hpp"
#include <QString>

DataAccessAdapter::DataAccessAdapter() {

}

bool DataAccessAdapter::createDB(const QString& dbFileName) {
  qInfo() <<  "DataAccessAdapter::createDB: dbFileName=" << qPrintable(dbFileName);

  bool success = false;
  try {
    Connection connection = Connection::Memory();

    Execute(connection,
            "CREATE TABLE [Version]([CreatedDate] NUMERIC NOT NULL,[LastUsedDate] NUMERIC NOT NULL, [ReleaseNumber] INTEGER NOT NULL)");

    Execute(connection,
            "CREATE TABLE [Website]([UniqueId] TEXT PRIMARY KEY ON CONFLICT ABORT NOT NULL,[Title] TEXT(50) NOT NULL,"
            "[Url] TEXT(256) NOT NULL,[UserId] TEXT,[Password] TEXT,[Notes] TEXT(128))");

    auto empty = Common::Empty.c_str();
    Execute(connection, "INSERT into Website (UniqueId,Title,Url,UserId,Password,Notes) VALUES  (?,?,?,?,?,?)",
            Common::WebsiteNoneId.toStdString().c_str(), Common::WebsiteNoneText.toStdString().c_str(), empty, empty, empty,
            Common::UndefinedWebsiteMessage.toStdString().c_str());

    Execute(connection,
            "CREATE TABLE [RealAsset]([Description] TEXT(50) NOT NULL COLLATE NOCASE,[EffectiveDate] NUMERIC,[Valuation] DOUBLE,"
            "[UniqueId] TEXT PRIMARY KEY ON CONFLICT ABORT NOT NULL,"
            "[WebsiteId] TEXT REFERENCES Website([UniqueId]) ON DELETE SET NULL ON UPDATE NO ACTION, [Notes] TEXT(128))");

    Execute(connection,
            "CREATE TABLE [Expense]([Payee] TEXT(50) NOT NULL COLLATE NOCASE,[NextPaymentDate] NUMERIC,"
            "[AutoPayment] TEXT(50),[AcountNumber] TEXT(25),[NameOnAccount] TEXT,[Amount] REAL NOT NULL DEFAULT 0,"
            "[UniqueId] TEXT PRIMARY KEY ON CONFLICT ABORT NOT NULL,"
            "[WebsiteId] TEXT REFERENCES Website([UniqueId]) ON DELETE SET NULL ON UPDATE NO ACTION,[Notes] TEXT(128))");

    Execute(connection,
            "CREATE TABLE [Investment]([Issuer] TEXT(50) NOT NULL COLLATE NOCASE, [IssueDate] NUMERIC,"
            "[PurchaseDate] NUMERIC,[RoutingNumber] TEXT(9),[AcountNumber] TEXT(25)  NOT NULL,[NameOnAccount] TEXT,[Shares]  REAL NOT NULL DEFAULT 0,"
            "[LastPrice] REAL NOT NULL DEFAULT 0,[UniqueId] TEXT PRIMARY KEY ON CONFLICT ABORT NOT NULL,"
            "[WebsiteId] TEXT REFERENCES Website([UniqueId]) ON DELETE SET NULL ON UPDATE NO ACTION,[Notes] TEXT(128))");

    Execute(connection,
            "CREATE TABLE [BankAccount]([BankName] TEXT(50) NOT NULL COLLATE NOCASE,[OpenedDate] NUMERIC,[RoutingNumber] TEXT(9),"
            "[AcountNumber] TEXT(25) NOT NULL,[NameOnAccount] TEXT,[Amount] REAL NOT NULL DEFAULT 0,"
            "[UniqueId] TEXT PRIMARY KEY ON CONFLICT ABORT NOT NULL,"
            "[WebsiteId] TEXT REFERENCES Website([UniqueId]) ON DELETE SET NULL ON UPDATE NO ACTION, [Notes] TEXT(128))");

    saveDB(connection, dbFileName);
    success = true;
  } catch (const std::exception& e) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return success;
}

void DataAccessAdapter::clearAll(QMetaEnum enumerator) {
  try {
    std::string sql;
    int count = SwitchboardCategory::getTableCount();
    for (int index = 0; index < count; ++index ) {
      sql.append(Common::DeleteAllRecordsFrom);
      sql.append( enumerator.valueToKey(index));
      Execute(*mConnection,  sql.c_str());
      sql.clear();
    }
    qInfo( "DataAccessAdapter::clearAll successful");
  } catch (const std::exception& e) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void DataAccessAdapter::resetConnection(bool createNew) {
  try {
    mConnection.clear();
    if (createNew) {
      mConnection  = QSharedPointer<Connection>::create();
    }
    qInfo( "DataAccessAdapter::resetConnection complete");
  } catch (const std::exception& e) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void DataAccessAdapter::saveDB(Connection const& sourceConnection, const QString& dbFileName) {
  try {
    qInfo() <<  "DataAccessAdapter::saveDB: dbFileName=" << dbFileName;
    Connection destinationConnection(dbFileName.toStdString().c_str());
    Backup backup(destinationConnection, sourceConnection);
    backup.Step();
  } catch (const std::exception& e) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

bool DataAccessAdapter::openDB(const QString& filepath) {
  bool success = false;
  try {
    qInfo() <<  "DataAccessAdapter::openDB: Attempting to open database file path=" << filepath;
    mConnection->Open(filepath.toStdString().c_str());
    success = true;
  } catch (const std::exception& e) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
  qInfo() <<  "DataAccessAdapter::openDB: successfully opened " << qPrintable(filepath);
  return success;
}

Version* DataAccessAdapter::version() {
  Version* version = new Version {};
  mTableSelect.select(mConnection, version);
  return version;
}

void DataAccessAdapter::versionUpdate() {
  mTableUpdate.versionUpdate(mConnection);
}



