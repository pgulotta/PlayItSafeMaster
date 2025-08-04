#pragma once

#include "tableinsert.hpp"
#include "tableselect.hpp"
#include "tableupdate.hpp"
#include "../util/qqmlobjectlistmodel.hpp"
#include "../util/sqlite.hpp"
#include <QMetaEnum>
#include <QSharedPointer>


#define QT_SHAREDPOINTER_TRACK_POINTERS


class QString;
class version;
class BankAccount;
class Investment;
class RealAsset;
class Expense;
class Website;
class Recap;

class DataAccessAdapter
{
public:
    DataAccessAdapter();

    bool openDB(const QString& filepath);
    bool createDB(const QString &dbFileName);
    void resetConnection(bool createNew);
    void clearAll(QMetaEnum enumerator);
    Version* version();
    void versionUpdate();

    void updateInvestment(const QString& investmentUniqueId, double lastPrice)
    {
        try
        {
            qInfo() <<  "DataAccessAdapter::updateInvestment: " << investmentUniqueId << "   " << lastPrice;
            mTableUpdate.updateInvestment(mConnection,investmentUniqueId, lastPrice);
        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::updateInvestment: %s", e.what ());
        }
    }

    template <typename T>
    void insert(T& t)
    {
        try
        {
            mTableInsert.insert(mConnection,t);
        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::insert: %s", e.what ());
        }
    }

    template <typename T>
    void update(T& t)
    {
        try
        {
            mTableUpdate.update(mConnection,t);
        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::update: %s", e.what ());
        }
    }

    template <typename T>
    void select(QQmlObjectListModel<T>& t )
    {
        try
        {
            mTableSelect.select(mConnection,t);
        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::select: %s", e.what ());
        }
    }

    template <typename T>
    void remove()
    {
        try
        {
            QString sql= QString("DELETE FROM %1 ").arg(T::staticMetaObject.className());
            Execute(*mConnection.data(), sql.toStdString().c_str());
        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::remove: %s", e.what ());
        }
    }

    template <typename T>
    void remove(const QString &uniqueId) const
    {
        try
        {
            QString sql= QString("DELETE FROM %1 WHERE UniqueId = '%2' ").arg(T::staticMetaObject.className(), uniqueId.toStdString().c_str());
            Execute(*mConnection.data(), sql.toStdString().c_str());
        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::remove: %s", e.what ());
        }
    }


    template <typename T>
    int size() const
    {
        int result = 0;
        try
        {
            QString sql= QString("SELECT COUNT (*) FROM %1").arg( T::staticMetaObject.className());
            Statement statement;
            statement.Prepare(*mConnection.data(),  sql.toStdString().c_str());
            for (Row row : statement)
            {
                result =  row.GetInt(0);
            }

        }
        catch (const std::exception& e)
        {
            qWarning( "DataAccessAdapter::count: %s", e.what ());
        }

        return result;
    }

private:
    void saveDB(const Connection &sourceConnection, const QString &dbFileName);

    typedef QSharedPointer<Connection> ConnectionPtr;
    ConnectionPtr mConnection {QSharedPointer<Connection>::create()};
    TableInsert mTableInsert;
    TableSelect mTableSelect;
    TableUpdate mTableUpdate;
};


