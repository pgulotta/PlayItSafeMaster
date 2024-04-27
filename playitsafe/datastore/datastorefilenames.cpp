#include "datastorefilenames.hpp"
#include "fileencryptor.hpp"
#include "../model/common.hpp"
#include <QDir>
#include <QFile>
#include <QUuid>
#include <QStandardPaths>
#include <QCoreApplication>
#include <QDebug>

//Default db names
// on android:  /data/user/0/com.twentysixapps.playitsafe/files/com.twentysixapps.playitsafe.db
// on windows:  C:/Users/pat/AppData/Roaming/26Apps/Play It Safe/com.twentysixapps.playitsafe.db
// on linux:    /home/pat-ubuntu/.local/share/26Apps/Play It Safe/com.twentysixapps.playitsafe.db

const QString DataStoreFileNames::AppDataFolder = QStandardPaths::writableLocation(
    QStandardPaths::AppDataLocation);
const QString DataStoreFileNames::DownloadsFolder = QStandardPaths::writableLocation(
    QStandardPaths::DownloadLocation);

DataStoreFileNames::DataStoreFileNames()
{
    qInfo() << "DataStoreFileNames::DownloadsFolder = " << qPrintable(DownloadsFolder);
    qInfo() << "DataStoreFileNames::AppDataFolder = " << qPrintable(AppDataFolder);

    assignDefaultFileNames();
}

DataStoreFileNames::DataStoreFileNames(const QString &unencryptedFileName,
                                       const QString &encryptedFileName)
{
  assignDefaultFileNames();
  rename( unencryptedFileName, encryptedFileName );
}

void DataStoreFileNames::rename( const QString& unencryptedFileName, const QString& encryptedFileName )
{
  if ( ! unencryptedFileName.isEmpty() ) {
    mUnencryptedFileName =    unencryptedFileName;
  }

  if ( ! encryptedFileName.isEmpty() ) {
    mEncryptedFileName  = encryptedFileName;
  }
}

void DataStoreFileNames::assignDefaultFileNames()
{
  auto appDir =  AppDataFolder + QDir::separator();
  mUnencryptedFileName = appDir + Common::createUniqueId() + ".db";
  mEncryptedFileName = appDir + mDefaultAppDbName;
  mPseudoAppFileName = appDir + mPseudoAppDbName;
  mTempFileName = appDir + "t_" + mDefaultAppDbName;

//  qDebug() << "FileEncryptor::assignDefaultFileNames: mUnencryptedFileName=" << qPrintable( mUnencryptedFileName );
//  qDebug() <<  "FileEncryptor::assignDefaultFileNames: mEncryptedFileName=" << qPrintable( mEncryptedFileName );
//  qDebug() <<  "FileEncryptor::assignDefaultFileNames: mPseudoAppFileName=" << qPrintable( mPseudoAppFileName );
//  qDebug() <<  "FileEncryptor::assignDefaultFileNames: mTempFileName=" << qPrintable( mTempFileName );
}
