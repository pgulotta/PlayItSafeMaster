#pragma once

#include "../util/qqmlobjectlistmodel.hpp"
#include <QSharedPointer>

class Connection;
class Version;
class QObject;
class Website;
class Expense;
class RealAsset;
class Investment;
class BankAccount;

typedef QSharedPointer<Connection> ConnectionPtr;

class TableSelect final
{
public:
    TableSelect();

    void select(ConnectionPtr& connection, QQmlObjectListModel<BankAccount>& list);
    void select(ConnectionPtr& connection, QQmlObjectListModel<Investment>& list);
    void select(ConnectionPtr& connection, QQmlObjectListModel<Expense>& list);
    void select(ConnectionPtr& connection, QQmlObjectListModel<RealAsset>& list);
    void select(ConnectionPtr& connection, QQmlObjectListModel<Website>& list);
    void select(ConnectionPtr& connection, Version* version);

private:

};

