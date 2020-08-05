#pragma once

#include <QObject>
#include <QString>
#include <QDate>
#include <QDebug>
#include <QTextCursor>
#include "common.hpp"

class Expense : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString payee READ payee WRITE setPayee NOTIFY payeeChanged)
  Q_PROPERTY(QDate nextPaymentDate READ nextPaymentDate WRITE setNextPaymentDate NOTIFY nextPaymentDateChanged)
  Q_PROPERTY(QString autoPayment READ autoPayment WRITE setAutoPayment NOTIFY autoPaymentChanged)
  Q_PROPERTY(QString accountNumber READ accountNumber WRITE setAccountNumber NOTIFY accountNumberChanged)
  Q_PROPERTY(QString nameOnAccount READ nameOnAccount WRITE setNameOnAccount NOTIFY nameOnAccountChanged)
  Q_PROPERTY(double amount READ amount WRITE setAmount NOTIFY amountChanged)
  Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)
  Q_PROPERTY(QString websiteId READ websiteId WRITE setWebsiteId NOTIFY websiteIdChanged)
  Q_PROPERTY(QString websiteUrl READ websiteUrl WRITE setWebsiteUrl NOTIFY websiteUrlChanged)
  Q_PROPERTY(QString notes READ notes WRITE setNotes NOTIFY notesChanged)

 public slots:
  void setPayee(QString payee) {
    if (m_payee == payee) {
      return;
    }

    m_payee = payee;
    emit payeeChanged(payee);
  }

  void setAutoPayment(QString autoPayment) {
    if ( m_autoPayment != autoPayment) {
      m_autoPayment = autoPayment;
      emit autoPaymentChanged(autoPayment);
    }
  }

  void setAccountNumber(QString accountNumber) {
    if (m_accountNumber == accountNumber) {
      return;
    }

    m_accountNumber = accountNumber;
    emit accountNumberChanged(accountNumber);
  }

  void setNameOnAccount(QString nameOnAccount) {
    if (m_nameOnAccount == nameOnAccount) {
      return;
    }

    m_nameOnAccount = nameOnAccount;
    emit nameOnAccountChanged(nameOnAccount);
  }

  void setWebsiteId(QString websiteId) {
    if (m_websiteId == websiteId) {
      return;
    }

    m_websiteId = websiteId;
    emit websiteIdChanged(websiteId);
  }

  void setWebsiteUrl(QString websiteUrl) {
    if (m_websiteUrl == websiteUrl) {
      return;
    }

    m_websiteUrl = websiteUrl;
    emit websiteUrlChanged(m_websiteUrl);
  }


  void setNotes(QString notes) {
    if (m_notes == notes) {
      return;
    }

    m_notes = notes;
    emit notesChanged(notes);
  }

  void setAmount(double amount) {
    if (m_amount == amount) {
      return;
    }

    m_amount = amount;
    emit amountChanged(amount);
  }

  void setUniqueId(QString uniqueId) {
    if (m_uniqueId == uniqueId) {
      return;
    }

    m_uniqueId = uniqueId;
    emit uniqueIdChanged(uniqueId);
  }

  void setNextPaymentDate(QDate nextPaymentDate) {
    if (m_nextPaymentDate == nextPaymentDate) {
      return;
    }

    m_nextPaymentDate = nextPaymentDate;
    emit nextPaymentDateChanged(m_nextPaymentDate);
  }

 signals:
  void payeeChanged(QString payee);
  void autoPaymentChanged(QString autoPayment);
  void accountNumberChanged(QString accountNumber);
  void nameOnAccountChanged(QString nameOnAccount);
  void notesChanged(QString notes);
  void amountChanged(double amount);
  void uniqueIdChanged(QString uniqueId);
  void websiteIdChanged(QString websiteId);
  void websiteUrlChanged(QString websiteUrl);
  void nextPaymentDateChanged(QDate nextPaymentDate);

 public:
  //    Expense() {
  //        qDebug() << "Expense::Expense called";
  //    }

  //    virtual ~Expense()
  //    {
  //        qDebug() << "Expense::~Expense called";
  //    }

  const static QString heading() {
    return QString("%1%2%3%4%5    %6%7%8        %9%10").
           arg("Payee", -30).
           arg( tr("Account Number"), -30).
           arg( tr("Next Payment"), -15).
           arg( tr("Amount"), 15).
           arg(Common::NewLine).
           arg(tr("Name On Account"), -35).
           arg(tr("Website"), -45).
           arg(Common::NewLine).
           arg( tr("Auto Payment"), -35).
           arg(tr("Notes"), -40);
  }

  operator QString() const {
    return QString("%1%2%3%4%5    %6%7%8        %9%10").
           arg(m_payee.left(30), -30).
           arg(m_accountNumber.left(30), -30).
           arg(m_nextPaymentDate.toString(Common::DateDisplayFormat).left(15), -15).
           arg(QLocale().toCurrencyString(m_amount).rightJustified(15), 15).
           arg(Common::NewLine).
           arg(m_nameOnAccount.left(35), -35).
           arg(m_websiteUrl.left(45), -45).
           arg(Common::NewLine).
           arg(m_autoPayment.left(35), -35).
           arg(m_notes.left(40), -40);
  }

  QString payee() const {
    return m_payee;
  }

  QString autoPayment() const {
    return m_autoPayment;
  }

  QString accountNumber() const {
    return m_accountNumber;
  }

  QString nameOnAccount() const {
    return m_nameOnAccount;
  }

  QString websiteId() const {
    return m_websiteId;
  }

  QString websiteUrl() const {
    return m_websiteUrl;
  }

  QString notes() const {
    return m_notes;
  }

  double amount() const {
    return m_amount;
  }

  QString uniqueId() const {
    return m_uniqueId;
  }

  QDate nextPaymentDate() const {
    return m_nextPaymentDate;
  }

 private:
  QString m_payee;
  QDate m_nextPaymentDate = QDate::currentDate();
  QString m_autoPayment = tr("None");
  QString m_accountNumber;
  QString m_nameOnAccount;
  QString m_websiteId = Common::WebsiteNoneId;
  QString m_websiteUrl = "";
  QString m_notes;
  double m_amount = 0.0;
  QString m_uniqueId;
};

