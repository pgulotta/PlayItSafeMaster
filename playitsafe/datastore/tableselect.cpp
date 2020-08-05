#include "tableselect.hpp"
#include "datastoremanager.hpp"
#include "../model/version.hpp"
#include "../model/website.hpp"
#include "../model/realasset.hpp"
#include "../model/expense.hpp"
#include "../model/realasset.hpp"
#include "../model/investment.hpp"
#include "../model/bankaccount.hpp"
#include "../util/sqlite.hpp"
#include <QDateTime>


TableSelect::TableSelect()
{

}

void TableSelect::select(ConnectionPtr& connection, Version* version)
{
    for (Row row : Statement(*connection.data(), "SELECT * FROM Version"))
    {
        version->setCreatedDate( QDateTime::fromTime_t(static_cast<uint>(row.GetInt(0))));
        version->setLastUsedDate(QDateTime::fromTime_t(static_cast<uint>(row.GetInt(1))));
        version->setReleaseNumber(row.GetInt(2));
    }
    qInfo() << "DataStoreManager::version:   createdDate:" << version->createdDate() << "  lastUsedDate:" << version->lastUsedDate()<< "  releaseNumber:" << version->releaseNumber();
}

void TableSelect::select(ConnectionPtr& connection, QQmlObjectListModel<Expense>& list )
{
    list.clear();
    for (Row row : Statement(*connection.data(), "SELECT E.*, W.Url FROM Expense E LEFT OUTER JOIN Website W on  E.WebsiteId = W.UniqueId ORDER BY E.Payee"))
    {
        int index = 0;
        auto expense = new Expense();
        expense->setPayee(row.GetString(index++));
        expense->setNextPaymentDate(Common::int64ToDate(QString(row.GetString(index++))));
        expense->setAutoPayment(row.GetString(index++));
        expense->setAccountNumber(row.GetString(index++));
        expense->setNameOnAccount(row.GetString(index++));
        expense->setAmount(QString(row.GetString(index++)).toDouble());
        expense->setUniqueId(row.GetString(index++));
        expense->setWebsiteId(row.GetString(index++));
        expense->setNotes(row.GetString(index++));
        expense->setWebsiteUrl(row.GetString(index++));
        list.append(expense);
    }
}

void TableSelect::select(ConnectionPtr& connection, QQmlObjectListModel<RealAsset>& list)
{
    list.clear();
    for (Row row : Statement(*connection.data(), "SELECT R.* , W.Url FROM RealAsset R LEFT OUTER JOIN Website W on R.WebsiteId = W.UniqueId ORDER BY Description"))
    {
        int index = 0;
        auto realAsset = new RealAsset();
        realAsset->setDescription(row.GetString(index++));
        realAsset->setEffectiveDate(Common::int64ToDate(QString(row.GetString(index++))));
        realAsset->setValuation(QString(row.GetString(index++)).toDouble());
        realAsset->setUniqueId(row.GetString(index++));
        realAsset->setWebsiteId(row.GetString(index++));
        realAsset->setNotes(row.GetString(index++));
        realAsset->setWebsiteUrl(row.GetString(index++));
        list.append(realAsset);
    }
}

void TableSelect::select(ConnectionPtr& connection, QQmlObjectListModel<BankAccount>& list)
{
    list.clear();
    for (Row row : Statement(*connection.data(), "select BA.*, W.Url FROM BankAccount BA LEFT OUTER JOIN Website W on  BA.WebsiteId = W.UniqueId ORDER BY BA.BankName"))
    {
        int index = 0;
        auto bankAccount = new BankAccount();
        bankAccount->setBankName(row.GetString(index++));
        bankAccount->setOpenedDate(Common::int64ToDate(QString(row.GetString(index++))));
        bankAccount->setRoutingNumber(row.GetString(index++));
        bankAccount->setAccountNumber(row.GetString(index++));
        bankAccount->setNameOnAccount(row.GetString(index++));
        bankAccount->setAmount(QString(row.GetString(index++)).toDouble());
        bankAccount->setUniqueId(row.GetString(index++));
        bankAccount->setWebsiteId(row.GetString(index++));
        bankAccount->setNotes(row.GetString(index++));
        bankAccount->setWebsiteUrl(row.GetString(index++));
        list.append(bankAccount);
    }
}

void TableSelect::select(ConnectionPtr& connection, QQmlObjectListModel<Investment>& list )
{
    list.clear();
    for (Row row : Statement(*connection.data(), "SELECT I.*, W.Url FROM Investment I LEFT OUTER JOIN Website W on I.WebsiteId = W.UniqueId  ORDER BY Issuer"))
    {
        int index = 0;
        auto investment = new Investment();
        investment->setIssuer(row.GetString(index++));
        investment->setIssueDate(Common::int64ToDate(QString(row.GetString(index++))));
        investment->setPurchaseDate(Common::int64ToDate(QString(row.GetString(index++))));
        investment->setRoutingNumber(row.GetString(index++));
        investment->setAccountNumber(row.GetString(index++));
        investment->setNameOnAccount(row.GetString(index++));
        investment->setShares(QString(row.GetString(index++)).toDouble());
        investment->setLastPrice(QString(row.GetString(index++)).toDouble());
        investment->setUniqueId(row.GetString(index++));
        investment->setWebsiteId(row.GetString(index++));
        investment->setNotes(row.GetString(index++));
        investment->setWebsiteUrl(row.GetString(index++));
        list.append(investment);
    }
}

void TableSelect::select(ConnectionPtr& connection, QQmlObjectListModel<Website>& list  )
{
    list.clear();
    for (Row row : Statement(*connection.data(), "SELECT * FROM Website ORDER BY Title"))
    {
        int index = 0;
        auto website = new Website();
        website->setUniqueId(row.GetString(index++));
        website->setTitle(row.GetString(index++));
        website->setUrl(row.GetString(index++));
        website->setUserId(row.GetString(index++));
        website->setPassword(row.GetString(index++));
        website->setNotes(row.GetString(index++));
        list.append(website);
    }
}
