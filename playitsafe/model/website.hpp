#pragma once

#include <QObject>
#include <QString>
#include <QDebug>
#include "common.hpp"

class Website : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
  Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userIdChanged)
  Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
  Q_PROPERTY(QString notes READ notes WRITE setNotes NOTIFY notesChanged)

 public slots:
  void setTitle(QString title) {
    if (m_title == title) {
      return;
    }

    m_title = title;
    emit titleChanged(title);
  }
  void setUniqueId(QString uniqueId) {
    if (m_uniqueId == uniqueId) {
      return;
    }

    m_uniqueId = uniqueId;
    emit uniqueIdChanged(uniqueId);
  }

  void setUrl(QString url) {
    if (m_url == url) {
      return;
    }

    m_url = url;
    emit urlChanged(url);
  }

  void setNotes(QString notes) {
    if (m_notes == notes) {
      return;
    }

    m_notes = notes;
    emit notesChanged(notes);
  }

  void setPassword(QString password) {
    if (m_password == password) {
      return;
    }

    m_password = password;
    emit passwordChanged(m_password);
  }

  void setUserId(QString userId) {
    if (m_userId == userId) {
      return;
    }

    m_userId = userId;
    emit userIdChanged(m_userId);
  }

 signals:
  void titleChanged(QString title);
  void uniqueId(QString uniqueId);
  void urlChanged(QString url);
  void notesChanged(QString notes);
  void uniqueIdChanged(QString uniqueId);
  void passwordChanged(QString password);
  void userIdChanged(QString userId);

 public:
  //    Website()  {
  //        qDebug() << "Website::Website called";
  //    }

  //    virtual ~Website()
  //    {
  //        qDebug() << "Website::~Website called";
  //    }

  const static QString heading() {
    return QString("%1%2%3    %4%5%6").
           arg( tr("Title"), -35).
           arg( tr("Url"), -50).
           arg(Common::NewLine).
           arg( tr("User Id"), -20).
           arg(tr("Password"), -20).
           arg(tr("Notes"), -45);
  }

  operator QString() const {
    return QString("%1%2%3    %4%5%6").
           arg(m_title.left(35), -35).
           arg(m_url.left(50), -50).
           arg(Common::NewLine).
           arg(m_userId.left(20), -20).
           arg(m_password.left(20), -20).
           arg(m_notes.left(40), -40);
  }

  QString toStringExcludingPassword() const {
    auto password = m_password.isEmpty() ? m_password : "********";
    return QString("%1%2%3    %4%5%6").
           arg(m_title.left(35), -35).
           arg(m_url.left(55), -55).
           arg(Common::NewLine).
           arg(m_userId.left(20), -20).
           arg(password.left(20), -20).
           arg(m_notes.left(40), -40);
  }

  QString title() const {
    return m_title;
  }

  QString uniqueId() const {
    return m_uniqueId;
  }

  QString url() const {
    return m_url;
  }

  QString notes() const {
    return m_notes;
  }

  QString password() const {
    return m_password;
  }

  QString userId() const {
    return m_userId;
  }

 private:
  QString m_uniqueId;
  QString m_title;
  QString m_url;
  QString m_notes;
  QString m_password;
  QString m_userId;
};

