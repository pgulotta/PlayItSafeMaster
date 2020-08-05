#include "tableupdate.hpp"
#include "datastoremanager.hpp"
#include "../model/version.hpp"
#include "../model/website.hpp"
#include "../model/realasset.hpp"
#include "../model/expense.hpp"
#include "../model/investment.hpp"
#include "../model/bankaccount.hpp"
#include "../util/sqlite.hpp"
#include <QDateTime>
#include <QUuid>
#include <QStringBuilder>


TableUpdate::TableUpdate()
{

}
void TableUpdate::versionUpdate( ConnectionPtr& connection )
{
  QString sql  = QString( "UPDATE Version SET LastUsedDate = %1" ).arg( ( DataStoreManager::convertToTimeText(
                                                                            QDate::currentDate() ) ) );
  Execute( *connection.data(), sql.toStdString().c_str() );
}

void TableUpdate::update( ConnectionPtr& connection, const Website& website )
{
  QString sql =
    QString( "UPDATE Website SET Title='%1', Url='%2',UserId='%3',Password='%4', Notes='%5' WHERE UniqueId='%6' " ).
    arg( website.title().replace( "'", "''" ),
         website.url(),
         website.userId().replace( "'", "''" ),
         website.password().replace( "'", "''" ),
         website.notes().replace( "'", "''" ),
         website.uniqueId() );
  Execute( *connection.data(), sql.toStdString().c_str() );
}

void TableUpdate::update( ConnectionPtr& connection, const RealAsset& realAsset )
{
  QString sql =
    QString( "UPDATE RealAsset SET EffectiveDate='%1', Description='%2', Valuation='%3', WebsiteId='%4', Notes='%5' WHERE UniqueId='%6' " ).arg(
      Common::dateToInt64( realAsset.effectiveDate() ),
      realAsset.description().replace( "'", "''" ),
      QString::number( realAsset.valuation(), 'g', 8 ),
      realAsset.websiteId(),
      realAsset.notes().replace( "'", "''" ),
      realAsset.uniqueId() );
  Execute( *connection.data(), sql.toStdString().c_str() );
}

void TableUpdate::update( ConnectionPtr& connection, const Expense& expense )
{
  QString sql0 =
    QString( "UPDATE Expense SET Payee='%1', NextPaymentDate='%2',  AutoPayment='%3', AcountNumber='%4', NameOnAccount='%5', " ).
    arg( expense.payee().replace( "'", "''" ),
         Common::dateToInt64( expense.nextPaymentDate() ),
         expense.autoPayment().replace( "'", "''" ),
         expense.accountNumber().replace( "'", "''" ),
         expense.nameOnAccount().replace( "'", "''" ) );

  QString sql = QString( " %1 Amount='%2', WebsiteId='%3', Notes='%4' WHERE UniqueId='%5' " ).
                arg( sql0,
                     QString::number( expense.amount(), 'g', 8  ),
                     expense.websiteId(),
                     expense.notes().replace( "'", "''" ),
                     expense.uniqueId() );
  Execute( *connection.data(), sql.toStdString().c_str() );
}
void TableUpdate::updateInvestment( ConnectionPtr& connection, const QString& investmentUniqueId, double lastPrice )
{
  QString sql = QString( "UPDATE Investment SET IssueDate='%1', LastPrice='%2' WHERE UniqueId='%3' " ).
                arg( Common::dateToInt64( QDate::currentDate() ),
                     QString::number( lastPrice, 'g', 8  ), investmentUniqueId );

  Execute( *connection.data(), sql.toStdString().c_str() );
}

void TableUpdate::update( ConnectionPtr& connection, const Investment& investment )
{
  QString sql0 =
    QString( "UPDATE Investment SET Issuer='%1', IssueDate='%2', PurchaseDate='%3', RoutingNumber='%4', AcountNumber='%5', NameOnAccount='%6', Shares='%7', " ).
    arg( investment.issuer().replace( "'", "''" ),
         Common::dateToInt64( investment.issueDate() ),
         Common::dateToInt64( investment.purchaseDate() ),
         investment.routingNumber(),
         investment.accountNumber().replace( "'", "''" ),
         investment.nameOnAccount().replace( "'", "''" ),
         QString::number( investment.shares(), 'g', 8 ) );

  QString sql = QString( " %1 LastPrice='%2', WebsiteId='%3', Notes='%4' WHERE UniqueId='%5' " ).
                arg( sql0,
                     QString::number( investment.lastPrice(), 'g', 8 ),
                     investment.websiteId(),
                     investment.notes().replace( "'", "''" ),
                     investment.uniqueId() );
  Execute( *connection.data(), sql.toStdString().c_str() );
}

void TableUpdate::update( ConnectionPtr& connection, const BankAccount& bankAccount )
{
  QString sql0 =
    QString( "UPDATE BankAccount SET BankName='%1', OpenedDate=%2, RoutingNumber='%3', AcountNumber='%4', NameOnAccount='%5', " ).
    arg( bankAccount.bankName().replace( "'", "''" ),
         Common::dateToInt64( bankAccount.openedDate() ),
         bankAccount.routingNumber(),
         bankAccount.accountNumber().replace( "'", "''" ),
         bankAccount.nameOnAccount().replace( "'", "''" ) );

  QString sql = QString( "%1 Amount=%2, WebsiteId='%3', Notes='%4' WHERE UniqueId='%5' " ).
                arg( sql0,
                     QString::number( bankAccount.amount(), 'g', 8 ),
                     bankAccount.websiteId(),
                     bankAccount.notes().replace( "'", "''" ),
                     bankAccount.uniqueId() );

  Execute( *connection.data(), sql.toStdString().c_str() );
}
