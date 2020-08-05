#pragma once

#include <QObject>
#include <QString>
#include <QDate>
#include <QDebug>
#include "common.hpp"
#include "math.h"

class Investment : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString issuer READ issuer WRITE setIssuer NOTIFY issuerChanged)
  Q_PROPERTY(QString accountNumber READ accountNumber WRITE setAccountNumber NOTIFY accountNumberChanged)
  Q_PROPERTY(QString nameOnAccount READ nameOnAccount WRITE setNameOnAccount NOTIFY nameOnAccountChanged)
  Q_PROPERTY(QString routingNumber READ routingNumber WRITE setRoutingNumber NOTIFY routingNumberChanged)
  Q_PROPERTY(QDate issueDate READ issueDate WRITE setIssueDate NOTIFY issueDateChanged)
  Q_PROPERTY(QDate purchaseDate READ purchaseDate WRITE setPurchaseDate NOTIFY purchaseDateChanged)
  Q_PROPERTY(double shares READ shares WRITE setShares NOTIFY sharesChanged)
  Q_PROPERTY(double lastPrice READ lastPrice WRITE setLastPrice NOTIFY lastPriceChanged)
  Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)
  Q_PROPERTY(QString websiteId READ websiteId WRITE setWebsiteId NOTIFY websiteIdChanged)
  Q_PROPERTY(QString notes READ notes WRITE setNotes NOTIFY notesChanged)
  Q_PROPERTY(QString websiteUrl READ websiteUrl WRITE setWebsiteUrl NOTIFY websiteUrlChanged)
  Q_PROPERTY(int sharesDecimals READ sharesDecimals CONSTANT)
  Q_PROPERTY(int lastPriceDecimals READ lastPriceDecimals CONSTANT)

 public slots:

  void setIssuer(QString issuer) {
    if (m_issuer == issuer) {
      return;
    }

    m_issuer = issuer;
    emit issuerChanged(issuer);
  }

  void setIssueDate(QDate issueDate) {
    if (m_issueDate == issueDate) {
      return;
    }

    m_issueDate = issueDate;
    emit issueDateChanged(issueDate);
  }

  void setPurchaseDate(QDate purchaseDate) {
    if (m_purchaseDate == purchaseDate) {
      return;
    }

    m_purchaseDate = purchaseDate;
    emit purchaseDateChanged(purchaseDate);
  }

  void setRoutingNumber(QString routingNumber) {
    if (m_routingNumber == routingNumber) {
      return;
    }

    m_routingNumber = routingNumber;
    emit routingNumberChanged(routingNumber);
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

  void setShares(double shares) {
    if (m_shares == shares) {
      return;
    }

    m_shares = shares;
    emit sharesChanged(shares);
  }

  void setLastPrice(double lastPrice) {
    if (m_lastPrice == lastPrice) {
      return;
    }

    m_lastPrice = lastPrice;
    emit lastPriceChanged(lastPrice);
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

  void setUniqueId(QString uniqueId) {
    if (m_uniqueId == uniqueId) {
      return;
    }

    m_uniqueId = uniqueId;
    emit uniqueIdChanged(uniqueId);
  }

 signals:
  void issuerChanged(QString issuer);
  void issueDateChanged(QDate issueDate);
  void purchaseDateChanged(QDate purchaseDate);
  void routingNumberChanged(QString routingNumber);
  void accountNumberChanged(QString accountNumber);
  void nameOnAccountChanged(QString nameOnAccount);
  void sharesChanged(double shares);
  void lastPriceChanged(double lastPrice);
  void notesChanged(QString notes);
  void uniqueIdChanged(QString uniqueId);
  void websiteIdChanged(QString websiteId);
  void websiteUrlChanged(QString websiteUrl);

 public:
  //    Investment() {
  //        qDebug() << "Investment::Investment called";
  //    }

  //    virtual ~Investment()
  //    {
  //        qDebug() << "Investment::~Investment called";
  //    }

  const static QString heading() {
    return QString("%1%2%3%4%5%6    %7%8%9%10        %11%12%13").
           arg( tr("Issuer"), -30).
           arg( tr("Account Number"), -20).
           arg( tr(" Shares"), -10).
           arg( tr(" Price"), -10).
           arg( tr("Amount"), 20).
           arg(Common::NewLine).
           arg(tr("Name On Account"), -30).
           arg( tr("Routing"), -10).
           arg(tr("Website"), -45).
           arg(Common::NewLine).
           arg( tr("Last Updated"), -15).
           arg( tr("Purchased"), -15).
           arg(tr("Notes"), -50);
  }

  operator QString() const {
    QString text1 = QString("%1%2%3%4%5").
                    arg(m_issuer.left(30), -30).
                    arg(m_accountNumber.left(20), -20).
                    arg(QString::number(m_shares).left(10), -10).
                    arg(QLocale().toCurrencyString(m_lastPrice).left(10), 10).
                    arg(QLocale().toCurrencyString(amount()).rightJustified(20), 20);
    QString text2;
    if (!(m_nameOnAccount.isEmpty() && m_websiteUrl.isEmpty() && m_notes.isEmpty())) {
      text2 = QString("%1    %2%3%4").
              arg(Common::NewLine).
              arg(m_nameOnAccount.left(30), -30).
              arg(m_routingNumber.left(10), -10).
              arg(m_websiteUrl.left(45), -45);
    }
    QString text3;
    if (!(m_nameOnAccount.isEmpty() && m_websiteUrl.isEmpty() && m_notes.isEmpty())) {
      text3 = QString("%1        %2%3%4").
              arg(Common::NewLine).
              arg(m_issueDate.toString(Common::DateDisplayFormat).left(15), -15).
              arg(m_purchaseDate.toString(Common::DateDisplayFormat).left(15), -15).
              arg(m_notes.left(50), -50);
    }
    return text1 + text2 + text3;
  }

  QString issuer() const {
    return m_issuer;
  }

  QDate issueDate() const {
    return m_issueDate;
  }

  QDate purchaseDate() const {
    return m_purchaseDate;
  }

  QString routingNumber() const {
    return m_routingNumber;
  }

  QString accountNumber() const {
    return m_accountNumber;
  }

  QString nameOnAccount() const {
    return m_nameOnAccount;
  }

  double shares() const {
    return m_shares;
  }

  double lastPrice() const {
    return m_lastPrice;
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

  QString uniqueId() const {
    return m_uniqueId;
  }

  double amount() const {
    return  floor(m_shares * m_lastPrice * 1000.0 + 0.005) / 1000.0;
  }

  int sharesDecimals() const {
    return 3;
  }

  int lastPriceDecimals() const {
    return 3;
  }

 private:

  QString m_issuer;
  QDate m_issueDate = QDate::currentDate();
  QDate m_purchaseDate = QDate::currentDate();
  QString m_routingNumber;
  QString m_accountNumber;
  QString m_nameOnAccount;
  double m_shares = 0.0;
  double m_lastPrice = 0.00;
  QString m_notes;
  QString m_uniqueId;
  QString m_websiteId = Common::WebsiteNoneId;
  QString m_websiteUrl = "";

};
