#include "tableinsert.hpp"
#include "datastoremanager.hpp"
#include "../model/version.hpp"
#include "../model/website.hpp"
#include "../model/expense.hpp"
#include "../model/realasset.hpp"
#include "../model/investment.hpp"
#include "../model/bankaccount.hpp"
#include "../model/common.hpp"
#include "../util/sqlite.hpp"
#include <QString>
#include <QDateTime>
#include <QUuid>

TableInsert::TableInsert()
{

}

void TableInsert::insertVersion( ConnectionPtr& connection )
{
  auto currentDateTime = DataStoreManager::convertToTimeNumeric( QDate::currentDate() );
  Execute( *connection.data(), "INSERT into Version (CreatedDate,LastUsedDate,ReleaseNumber) VALUES  (?,?,?)",
           currentDateTime, currentDateTime, 1 );
}

void TableInsert::insert( ConnectionPtr& connection, Website& website )
{
  website.setUniqueId( Common::createUniqueId() );
  Execute( *connection.data(), "INSERT into Website (UniqueId,Title,Url,UserId,Password,Notes) VALUES  (?,?,?,?,?,?)",
           website.uniqueId().toStdString().c_str(),
           website.title().toStdString().c_str(),
           website.url().toStdString().c_str(),
           website.userId().toStdString().c_str(),
           website.password().toStdString().c_str(),
           website.notes().toStdString().c_str() );
}

void TableInsert::insert( ConnectionPtr& connection, Expense& expense )
{
  expense.setUniqueId( Common::createUniqueId() );
  Execute( *connection.data(),
           "INSERT into Expense (Payee,NextPaymentDate,AutoPayment,AcountNumber,NameOnAccount,Amount,UniqueId,WebsiteId,Notes) VALUES (?,?,?,?,?,?,?,?,?)",
           expense.payee().toStdString().c_str(),
           Common::dateToInt64( expense.nextPaymentDate() ).toStdString().c_str(),
           expense.autoPayment().toStdString().c_str(),
           expense.accountNumber().toStdString().c_str(),
           expense.nameOnAccount().toStdString().c_str(),
           QString::number( expense.amount(), 'g', 8 ).toStdString().c_str(),
           expense.uniqueId().toStdString().c_str(),
           expense.websiteId().toStdString().c_str(),
           expense.notes().toStdString().c_str() );
}

void TableInsert::insert( ConnectionPtr& connection, RealAsset& realAsset )
{
  realAsset.setUniqueId( Common::createUniqueId() );
  Execute( *connection.data(),
           "INSERT into RealAsset (EffectiveDate,Description,Valuation,WebsiteId,UniqueId,Notes) VALUES  (?,?,?,?,?,?)",
           Common::dateToInt64( realAsset.effectiveDate() ).toStdString().c_str(),
           realAsset.description().toStdString().c_str(),
           QString::number( realAsset.valuation(), 'g', 8  ).toStdString().c_str(),
           realAsset.websiteId().toStdString().c_str(),
           realAsset.uniqueId().toStdString().c_str(),
           realAsset.notes().toStdString().c_str() );
}

void TableInsert::insert( ConnectionPtr& connection, Investment& investment )
{
  investment.setUniqueId( Common::createUniqueId() );
  Execute( *connection.data(),
           "INSERT into Investment (Issuer,IssueDate,PurchaseDate,RoutingNumber,AcountNumber,NameOnAccount,Shares,LastPrice,UniqueId,WebsiteId,Notes) VALUES  (?,?,?,?,?,?,?,?,?,?,?)",
           investment.issuer().toStdString().c_str(),
           Common::dateToInt64( investment.issueDate() ).toStdString().c_str(),
           Common::dateToInt64( investment.purchaseDate() ).toStdString().c_str(),
           investment.routingNumber().toStdString().c_str(),
           investment.accountNumber().toStdString().c_str(),
           investment.nameOnAccount().toStdString().c_str(),
           QString::number( investment.shares(), 'g', 8  ).toStdString().c_str(),
           QString::number( investment.lastPrice(), 'g', 8  ).toStdString().c_str(),
           investment.uniqueId().toStdString().c_str(),
           investment.websiteId().toStdString().c_str(),
           investment.notes().toStdString().c_str() );
}

void TableInsert::insert( ConnectionPtr& connection, BankAccount& bankAccount )
{
  bankAccount.setUniqueId( Common::createUniqueId() );
  Execute( *connection.data(),
           "INSERT into BankAccount (BankName,OpenedDate,RoutingNumber,AcountNumber,NameOnAccount,Amount,UniqueId,WebsiteId,Notes) VALUES  (?,?,?,?,?,?,?,?,?)",
           bankAccount.bankName().toStdString().c_str(),
           Common::dateToInt64( bankAccount.openedDate() ).toStdString().c_str(),
           bankAccount.routingNumber().toStdString().c_str(),
           bankAccount.accountNumber().toStdString().c_str(),
           bankAccount.nameOnAccount().toStdString().c_str(),
           QString::number( bankAccount.amount(), 'g', 8  ).toStdString().c_str(),
           bankAccount.uniqueId().toStdString().c_str(),
           bankAccount.websiteId().toStdString().c_str(),
           bankAccount.notes().toStdString().c_str() );
}
