#pragma once

#include <QSharedPointer>

class Connection;
class Website;
class RealAsset;
class Expense;
class RealAsset;
class Investment;
class BankAccount;

typedef QSharedPointer<Connection> ConnectionPtr;

class TableInsert final
{
public:
    TableInsert();
    void insertVersion(ConnectionPtr& connection);
    void insert(ConnectionPtr& connection, Website& website);
    void insert(ConnectionPtr& connection, Expense& expense);
    void insert(ConnectionPtr& connection, RealAsset& realAsset);
    void insert(ConnectionPtr& connection, Investment& investment);
    void insert(ConnectionPtr& connection, BankAccount& bankAccount);


};


