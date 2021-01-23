#include "downloadspathcontroller.hpp"
#include "../model/importfilenotification.hpp"
#include "../model/common.hpp"

#include <QDir>
#include <QDebug>
#include <QSettings>
#include <QStandardPaths>

// android:   /storage/emulated/0/Download


QString DownloadsPathController::downloadsPath()
{
  QString downloadsPath;

  try {
    QSettings settings;
    downloadsPath = settings.value( Common::DownloadsPathSettingsKey ).toString();

    if ( downloadsPath.isEmpty() ) {
      downloadsPath = initAppDownloadFolder();
    }

    QDir dir = QDir::root();
    dir.mkpath( downloadsPath );
    qInfo() << "DownloadsPathController::downloadsPath path = " + downloadsPath;
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return downloadsPath;
}

bool DownloadsPathController::setDownloadsPath( const QString& downloadsPath )
{
  bool isSuccessful = false;

  try {
    QDir dir = QDir::root();
    isSuccessful = dir.mkpath( downloadsPath );
    QSettings settings;
    settings.setValue( Common::DownloadsPathSettingsKey, downloadsPath );
    qInfo() << "DownloadsPathController::setDownloadsPath path = " + settings.value(
              Common::DownloadsPathSettingsKey ).toString();
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return isSuccessful;
}

QString DownloadsPathController::initAppDownloadFolder()
{
  QString downloadsPath;

  try {
    QSettings settings;
    downloadsPath = settings.value( Common::DownloadsPathSettingsKey ).toString();

    if ( downloadsPath.isEmpty() ) {
      downloadsPath = QStandardPaths::writableLocation( QStandardPaths::DownloadLocation );
      setDownloadsPath( downloadsPath );
    }

    qInfo() << "DownloadsPathController::initAppDownloadFolder path = " + settings.value(
              Common::DownloadsPathSettingsKey ).toString();
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return downloadsPath;
}

QString DownloadsPathController::tryResolveFilDownloadePath( const QString& unresolvedPath )
{
  qInfo() << "DownloadsPathController::tryResolveFilDownloadePath: Initial unresolvedPath=" << unresolvedPath;
  QString resolvedPath = ImportFileNotification::unresolvedFilePathId();  // "UnresolvedFilePath"

  if ( QFile::exists( unresolvedPath ) ) {
    resolvedPath = unresolvedPath;
  } else {
    QFileInfo fileInfo {unresolvedPath};
    QString fileName = DownloadsPathController::downloadsPath() + QDir::separator() +  fileInfo.fileName();

    if ( QFile::exists( fileName ) ) {
      resolvedPath = fileName;
    }
  }

  qInfo() << "DownloadsPathController::tryResolveFilDownloadePath: Final resolvedPath=" << resolvedPath;
  return resolvedPath;
}
