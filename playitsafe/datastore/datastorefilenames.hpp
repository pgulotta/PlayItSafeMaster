#pragma once

#include <QString>

class DataStoreFileNames {
 public:
  DataStoreFileNames();

  DataStoreFileNames(const QString& unencryptedFileName, const QString& encryptedFileName);

  static QString AppDataFolder;

  const QString& pseudoAppFileName() const {
    return mPseudoAppFileName;
  }

  const QString& tempFileName() const {
    return mTempFileName;
  }

  const QString& unencryptedFileName() const {
    return mUnencryptedFileName;
  }

  const QString& encryptedFileName() const {
    return mEncryptedFileName;
  }

 private:
  void assignDefaultFileNames();
  void rename( const QString& unencryptedFileName, const QString& encryptedFileName);

  QString mPseudoAppFileName;
  QString mUnencryptedFileName;
  QString mEncryptedFileName;
  QString mTempFileName;

  const QString mPseudoAppDbName = {"com.twentysixapps.playitsafe.pseudo.db"};
  const QString mDefaultAppDbName = {"com.twentysixapps.playitsafe.db"};
  const QString mDefaultPassword = {"password"};

};

