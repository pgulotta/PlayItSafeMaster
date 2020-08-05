#pragma once

#include <QtQml>
#include <QGuiApplication>
#include <QScreen>
#include <QObject>
#include <QString>
#include <QDebug>
#include <QDate>
#include <QSortFilterProxyModel>


class SwitchboardCategory : public QObject {
  Q_OBJECT
  Q_ENUMS(Group)
  Q_ENUMS(Moniker)
  Q_PROPERTY(QString title READ title CONSTANT )
  Q_PROPERTY(QString imageSource READ imageSource CONSTANT  )
  Q_PROPERTY(QString pageSource READ pageSource CONSTANT  )
  Q_PROPERTY(Group group READ group CONSTANT)
  Q_PROPERTY(Moniker moniker READ moniker CONSTANT)

 public slots:

 public:
  enum class Group {
    Asset, Liability, Web, Reporting
  };


  enum class Moniker {
    BankAccount,
    Investment,
    RealAsset,
    Expense,
    Website,
    Recap,
  };

  explicit SwitchboardCategory(QObject* parent = nullptr) :
    QObject(parent) {
    //qDebug() << " SwitchboardCategory() called";
  }

  SwitchboardCategory(const QString& title, const QString& imageSource, const QString& pageSource, Group group, Moniker moniker,
                      QObject* parent = nullptr) :
    QObject(parent) {
    m_title = title;
    m_imageSource = imageSource;
    m_pageSource = pageSource;
    m_group = group;
    m_moniker = moniker;
    //qDebug() << " SwitchboardCategories() called";
  }

  virtual ~SwitchboardCategory() {
    //qDebug() << " ~SwitchboardCategories() called";
  }

  QString title() const {
    return m_title;
  }

  QString imageSource() const {
    return m_imageSource;
  }

  Group group() const {
    return m_group;
  }

  Moniker moniker() const {
    return m_moniker;
  }

  QString pageSource() const {
    return m_pageSource;
  }

  static int getMonikerEnumIndex() {
    return 1;
  }

  static int getTableCount() {
    return 5;
  }

 private:
  QString m_title;
  QString m_imageSource;
  Group m_group;
  Moniker m_moniker;
  QString m_pageSource;
};


