#pragma once

#include <QObject>
#include <QString>
#include <QDebug>


class PdfCreatedNotification : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString pdfFilePath READ pdfFilePath WRITE setPdfFilePath NOTIFY pdfFilePathChanged)

 public slots:
  void setPdfFilePath(QString pdfFilePath) {
    if (m_pdfFilePath == pdfFilePath) {
      return;
    }

    qInfo() << "PdfCreatedNotification::setPdfFilePath called" << pdfFilePath;
    m_pdfFilePath = pdfFilePath;
    emit pdfFilePathChanged(pdfFilePath);
  }

 signals:
  void pdfFilePathChanged(QString pdfFilePath);

 public:
  //    PdfCreatedNotification() {
  //        qDebug() << "PdfCreatedNotification::PdfCreatedNotification called";
  //    }

  //    virtual ~PdfCreatedNotification()
  //    {
  //        qDebug() << "PdfCreatedNotification::~PdfCreatedNotification called";
  //    }

  QString pdfFilePath() const {
    return m_pdfFilePath;
  }

 private:
  QString m_pdfFilePath;

};
