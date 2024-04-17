#pragma once

#include "filechooserresultnotification.hpp"
#include <QObject>
#include <QFile>
#include <QDebug>

class FileChooserResult {
 public:
  FileChooserResult( FileChooserResultNotification& fileChooserResultNotification) :
    mFileChooserResultNotification{fileChooserResultNotification} {
      qDebug() << "FileChooserResult::FileChooserResult called ";
  }

  ~FileChooserResult() { qDebug() << "FileChooserResult::~FileChooserResult called "; }

  private:
  FileChooserResultNotification& mFileChooserResultNotification;
};
