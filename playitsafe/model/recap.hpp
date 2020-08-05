#pragma once


#include <QObject>
#include <QString>
#include <QDebug>

class Recap : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString uniqueId READ uniqueId CONSTANT)
  Q_PROPERTY(QString title READ title CONSTANT)
  Q_PROPERTY(QString description READ description CONSTANT)
  Q_PROPERTY(double amount READ amount CONSTANT)
  Q_PROPERTY(QString section READ section CONSTANT)
  Q_PROPERTY(QString sectionUrl READ sectionUrl CONSTANT)
  Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged )

 public slots:

  void setEnabled(bool enabled) {
    if (m_enabled == enabled) {
      return;
    }
    m_enabled = enabled;
    emit enabledChanged(m_enabled);
  }

 signals:
  void enabledChanged(bool enabled);

 public:
  //    Recap() {
  //        qDebug() << "Recap::Recap called";
  //    }

  Recap(QString uniqueId,  QString title, QString description, double amount, QString section, QString sectionUrl, bool enabled ) :
    m_uniqueId{uniqueId.trimmed()},
    m_title{title.trimmed()},
    m_description{description.trimmed()},
    m_amount{amount},
    m_section{section.trimmed()},
    m_sectionUrl{sectionUrl},
    m_enabled{enabled} {
  }

  //    virtual ~Recap()
  //    {
  //        qDebug() << "Recap::~Recap called";
  //    }

  const static QString heading() {
    return QString("%1%2%3%4").
           arg( tr("Category"), -15).
           arg( tr("Description"), -30).
           arg( tr("Other"), -30).
           arg( tr("Amount"), 15);
  }
  operator QString() const {
    return QString("%1%2%3%4").
           arg(m_section.left(15), -15).
           arg(m_title.left(30), -30).
           arg(m_description.left(30), -30).
           arg(QLocale().toCurrencyString(m_amount).rightJustified(15), 15);
  }

  QString uniqueId() const {
    return m_uniqueId;
  }

  QString title() const {
    return m_title;
  }
  QString description() const {
    return m_description;
  }
  double amount() const {
    return m_amount;
  }
  bool enabled() const {
    return m_enabled;
  }

  QString section() const {
    return m_section;
  }

  QString sectionUrl() const {
    return m_sectionUrl;
  }

 private:
  QString m_uniqueId;
  QString m_title;
  QString m_description;
  double m_amount;
  QString m_section;
  QString m_sectionUrl;
  bool m_enabled;


};
