#pragma once

#include <QObject>
#include <QString>
#include <QDebug>


class InvestmentPriceNotification : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool updateSuccess READ updateSuccess WRITE setUpdateSuccess NOTIFY updateSuccessChanged)

 public slots:
  void setUpdateSuccess(bool updateSuccess) {
    m_updateSuccess = updateSuccess;
    emit updateSuccessChanged(m_updateSuccess);
  }

 signals:
  void updateSuccessChanged(bool updateSuccess);

 public:
  //    InvestmentPriceNotification() {
  //        qDebug() << "InvestmentPriceNotification::InvestmentPriceNotification called";
  //    }

  //    virtual ~InvestmentPriceNotification()
  //    {
  //        qDebug() << "InvestmentPriceNotification::~InvestmentPriceNotification called";
  //    }

  bool updateSuccess() const {
    return m_updateSuccess;
  }

 private:
  bool m_updateSuccess;
};
