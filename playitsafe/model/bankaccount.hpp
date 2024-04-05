#pragma once

#include <QObject>
#include <QString>
#include <QDate>
#include <QDebug>
#include "common.hpp"
#include <qqml.h>

class BankAccount : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString bankName READ bankName WRITE setBankName NOTIFY bankNameChanged)
    Q_PROPERTY(QDate openedDate READ openedDate WRITE setOpenedDate NOTIFY openedDateChanged)
    Q_PROPERTY(QString routingNumber READ routingNumber WRITE setRoutingNumber NOTIFY routingNumberChanged)
    Q_PROPERTY(QString accountNumber READ accountNumber WRITE setAccountNumber NOTIFY accountNumberChanged)
    Q_PROPERTY(QString nameOnAccount READ nameOnAccount WRITE setNameOnAccount NOTIFY nameOnAccountChanged)
    Q_PROPERTY(double amount READ amount WRITE setAmount NOTIFY amountChanged)
    Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)
    Q_PROPERTY(QString notes READ notes WRITE setNotes NOTIFY notesChanged)
    Q_PROPERTY(QString websiteId READ websiteId WRITE setWebsiteId NOTIFY websiteIdChanged)
    Q_PROPERTY(QString websiteUrl READ websiteUrl WRITE setWebsiteUrl NOTIFY websiteUrlChanged)
    QML_ELEMENT

public slots:
    void setBankName(QString bankName)
    {
        if (m_bankName == bankName)
        {
            return;
        }

        m_bankName = bankName;
        emit bankNameChanged(bankName);
    }

    void setOpenedDate(QDate openedDate)
    {
        if (m_openedDate == openedDate)
        {
            return;
        }

        m_openedDate = openedDate;
        emit openedDateChanged(openedDate);
    }

    void setRoutingNumber(QString routingNumber)
    {
        if (m_routingNumber == routingNumber)
        {
            return;
        }

        m_routingNumber = routingNumber;
        emit routingNumberChanged(routingNumber);
    }

    void setAccountNumber(QString accountNumber)
    {
        if (m_accountNumber == accountNumber)
        {
            return;
        }

        m_accountNumber = accountNumber;
        emit accountNumberChanged(accountNumber);
    }

    void setNameOnAccount(QString nameOnAccount)
    {
        if (m_nameOnAccount == nameOnAccount)
        {
            return;
        }

        m_nameOnAccount = nameOnAccount;
        emit nameOnAccountChanged(nameOnAccount);
    }

    void setAmount(double amount)
    {
        m_amount = amount;
        emit amountChanged(amount);
    }

    void setNotes(QString notes)
    {
        if (m_notes == notes)
        {
            return;
        }

        m_notes = notes;
        emit notesChanged(notes);
    }

    void setUniqueId(QString uniqueId)
    {
        if (m_uniqueId == uniqueId)
        {
            return;
        }

        m_uniqueId = uniqueId;
        emit uniqueIdChanged(uniqueId);
    }

    void setWebsiteId(QString websiteId)
    {
        if (m_websiteId == websiteId)
        {
            return;
        }

        m_websiteId = websiteId;
        emit websiteIdChanged(websiteId);
    }

    void setWebsiteUrl(QString websiteUrl)
    {
        if (m_websiteUrl == websiteUrl)
        {
            return;
        }

        m_websiteUrl = websiteUrl;
        emit websiteUrlChanged(m_websiteUrl);
    }

signals:
    void bankNameChanged(QString bankName);
    void openedDateChanged(QDate openedDate);
    void routingNumberChanged(QString routingNumber);
    void accountNumberChanged(QString accountNumber);
    void nameOnAccountChanged(QString nameOnAccount);
    void amountChanged(double amount);
    void notesChanged(QString notes);
    void uniqueIdChanged(QString uniqueId);
    void websiteIdChanged(QString websiteId);
    void websiteUrlChanged(QString websiteUrl);

public:
    //    BankAccount(){
    //        qDebug() << "BankAccount::BankAccount called";
    //    }

    //    virtual ~BankAccount()
    //    {
    //        qDebug() << "BankAccount::~BankAccount called";
    //    }

    const static QString heading()
    {
        return QString("%1%2%3%4%5%6    %7%8%9        %10").
               arg(tr("Bank"), -25).
               arg(tr("Account Number"), -20).
               arg(tr("Opened"), -15).
               arg(tr("Routing"), -10).
               arg(tr("Amount"), 20).
               arg(Common::NewLine).
               arg(tr("Name On Account"), -35).
               arg(tr("Website"), -50).
               arg(Common::NewLine).
               arg(tr("Notes"), -80);
    }

    operator QString() const
    {
        QString text1 =  QString("%1%2%3%4%5").
                         arg(m_bankName.left(25), -25).
                         arg(m_accountNumber.left(20), -20).
                         arg(m_openedDate.toString(Common::DateDisplayFormat).left(15), -15).
                         arg(m_routingNumber.left(10), -10).
                         arg(QLocale().toCurrencyString(m_amount).rightJustified(20), 20);
        QString text2;
        text2 = QString("%1    %2%3").
                arg(Common::NewLine).
                arg(m_nameOnAccount.left(35), -35).
                arg(m_websiteUrl.left(50), -50);
        QString text3;
        text3 = QString("%1        %2").
                arg(Common::NewLine).
                arg(m_notes.left(80), -80);
        return text1 + text2 + text3;
    }

    QString bankName() const
    {
        return m_bankName;
    }

    QDate openedDate() const
    {
        return m_openedDate;
    }

    QString routingNumber() const
    {
        return m_routingNumber;
    }

    QString accountNumber() const
    {
        return m_accountNumber;
    }

    QString nameOnAccount() const
    {
        return m_nameOnAccount;
    }

    double amount() const
    {
        return m_amount;
    }

    QString notes() const
    {
        return m_notes;
    }

    QString uniqueId() const
    {
        return m_uniqueId;
    }

    QString websiteId() const
    {
        return m_websiteId;
    }

    QString websiteUrl() const
    {
        return m_websiteUrl;
    }

private:
    QString m_bankName;
    QDate m_openedDate = QDate::currentDate();
    QString m_routingNumber = "";
    QString m_accountNumber;
    QString m_nameOnAccount;
    double m_amount = 0.0;
    QString m_notes;
    QString m_uniqueId;
    QString m_websiteId = Common::WebsiteNoneId;
    QString m_websiteUrl = "";
};
