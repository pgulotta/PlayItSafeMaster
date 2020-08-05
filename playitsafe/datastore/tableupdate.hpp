#pragma once

#include <QSharedPointer>

class Connection;
class Website;
class Expense;
class RealAsset;
class Investment;
class BankAccount;

typedef QSharedPointer<Connection> ConnectionPtr;

class TableUpdate final
{
public:
    TableUpdate();
    void versionUpdate(ConnectionPtr& mConnection);
    void update(ConnectionPtr& connection, const Website &website);
    void update(ConnectionPtr& connection, const Expense& expense);
    void update(ConnectionPtr& connection, const RealAsset& realAsset);
    void update(ConnectionPtr& connection, const Investment& investment);
    void update(ConnectionPtr& connection, const BankAccount& bankAccount);
    void updateInvestment(ConnectionPtr& connection, const QString& investmentUniqueId, double lastPrice);

private:

};


