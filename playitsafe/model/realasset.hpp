#pragma once

#include <QObject>
#include <QString>
#include <QDate>
#include <QDebug>
#include "common.hpp"

class RealAsset : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
  Q_PROPERTY(QDate effectiveDate READ effectiveDate WRITE setEffectiveDate NOTIFY effectiveDateChanged)
  Q_PROPERTY(double valuation READ valuation WRITE setValuation NOTIFY valuationChanged)
  Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)
  Q_PROPERTY(QString websiteId READ websiteId WRITE setWebsiteId NOTIFY websiteIdChanged)
  Q_PROPERTY(QString websiteUrl READ websiteUrl WRITE setWebsiteUrl NOTIFY websiteUrlChanged)
  Q_PROPERTY(QString notes READ notes WRITE setNotes NOTIFY notesChanged)

 public slots:
  void setEffectiveDate(QDate effectiveDate) {
    if (m_effectiveDate == effectiveDate) {
      return;
    }

    m_effectiveDate = effectiveDate;
    emit effectiveDateChanged(effectiveDate);
  }

  void setDescription(QString description) {
    if (m_description == description) {
      return;
    }

    m_description = description;
    emit descriptionChanged(description);
  }

  void setValuation(double valuation) {
    if (m_valuation == valuation) {
      return;
    }

    m_valuation = valuation;
    emit valuationChanged(valuation);
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
  void effectiveDateChanged(QDate effectiveDate);
  void descriptionChanged(QString description);
  void valuationChanged(double valuation);
  void websiteIdChanged(QString websiteId);
  void websiteUrlChanged(QString websiteUrl);
  void notesChanged(QString notes);
  void uniqueIdChanged(QString uniqueId);

 public:
  //    RealAsset()  {
  //        qDebug() << "RealAsset::RealAsset called";
  //    }

  //    virtual ~RealAsset()
  //    {
  //        qDebug() << "RealAsset::~RealAsset called";
  //    }

  const static QString heading() {
    return QString("%1%2%3%4    %5%6").
           arg( tr("Description"), -55).
           arg( tr("Effective Date"), -15).
           arg( tr("Valuation"), 20).
           arg(Common::NewLine).
           arg(tr("Website"), -40).
           arg(tr("Notes"), -45);
  }

  operator QString() const {
    QString line1 =  QString("%1%2%3").
                     arg(m_description.left(55), -55).
                     arg(m_effectiveDate.toString(Common::DateDisplayFormat).left(15), -15).
                     arg(QLocale().toCurrencyString(m_valuation).rightJustified(20), 20);
    QString line2;
    if (!( m_websiteUrl.isEmpty() && m_notes.isEmpty())) {
      line2 = QString("%1    %2%3").
              arg(Common::NewLine).
              arg(m_websiteUrl.left(40), -40).
              arg(m_notes.left(45), -45);
    }
    return line1 + line2;
  }

  QDate effectiveDate() const {
    return m_effectiveDate;
  }

  QString description() const {
    return m_description;
  }

  double valuation() const {
    return m_valuation;
  }
  double amount() const {
    return m_valuation;
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

 private:
  QDate m_effectiveDate = QDate::currentDate();
  QString m_description;
  double m_valuation = 0.0;
  QString m_websiteId = Common::WebsiteNoneId;
  QString m_websiteUrl = "";
  QString m_notes;
  QString m_uniqueId;
};

