#pragma once

#include <QObject>
#include <QString>
#include <QDebug>




class ImportFileNotification : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString importFilePath READ importFilePath WRITE setImportFilePath NOTIFY importFilePathChanged)
  Q_PROPERTY(QString unresolvedFilePathId READ unresolvedFilePathId)

 public slots:
  void setImportFilePath(QString importFilePath) {
    //    if (m_importFilePath == importFilePath) {
    //      return;
    //    }

    m_importFilePath = importFilePath;
    emit importFilePathChanged(m_importFilePath);
  }

 signals:
  void importFilePathChanged(QString importFilePath);

 public:
  //    ImportFileNotification() {
  //        qDebug() << "ImportFileNotification::ImportFileNotification called";
  //    }

  //    virtual ~ImportFileNotification()
  //    {
  //        qDebug() << "ImportFileNotification::~ImportFileNotification called";
  //    }

  QString importFilePath() const {
    return m_importFilePath;
  }

  static QString unresolvedFilePathId()  {
    return "UnresolvedFilePath";
  }

 private:
  QString m_importFilePath;

};


