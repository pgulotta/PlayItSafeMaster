#pragma once

#include "filechooserresultnotification.hpp"
#include <QObject>
#include <QFile>
#include <QDebug>

#ifdef Q_OS_ANDROID

#include <QtAndroid>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>

class FileChooserResult : public QAndroidActivityResultReceiver {
 public:
  FileChooserResult( FileChooserResultNotification& fileChooserResultNotification) :
    QAndroidActivityResultReceiver(),
    mFileChooserResultNotification{fileChooserResultNotification} {
    // qDebug() << "FileChooserResult::FileChooserResult called ";
  }

  //    ~FileChooserResult() {
  //        qDebug() << "FileChooserResult::~FileChooserResult called ";
  //    }

  void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject& data) {
    if (receiverRequestCode != FileChooserResultNotification::RequestCode) {
      return;
    }
    try {
      jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
      if ( resultCode == RESULT_OK) {
        QString filePath  = data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;").toString();
        qInfo() << "filePath ="  <<   filePath;

        QAndroidJniObject obj  =  data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;");
        qInfo() << "obj ="  <<   obj.toString();
        mFileChooserResultNotification.onFileChooserResult(filePath);

      } else {
        qWarning() << "FileChooserResult::handleActivityResult: Invalid resultCode=" << resultCode;
      }
    } catch (const std::exception& e) {
      qWarning( "FileChooserResult::clearAll: %s", e.what ());
    }
  }

 private:
  FileChooserResultNotification& mFileChooserResultNotification;
};
#else
class FileChooserResult {
 public:
  FileChooserResult( FileChooserResultNotification& fileChooserResultNotification) :
    mFileChooserResultNotification{fileChooserResultNotification} {
    //qDebug() << "FileChooserResult::FileChooserResult called ";
  }

  //    ~FileChooserResult() {
  //        qDebug() << "FileChooserResult::~FileChooserResult called ";
  //    }

 private:
  FileChooserResultNotification& mFileChooserResultNotification;
};

#endif
