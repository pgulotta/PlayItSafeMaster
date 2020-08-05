#pragma once

#include <QString>
#include <QVector>
#include <QDir>

class DataStoreFileNames;


class FileEncryptor {
 public:
  FileEncryptor(const DataStoreFileNames& dataStoreFileNames);
  ~FileEncryptor();
  void setKey(quint64 key);
  bool encrypt();
  bool decrypt();
  QByteArray encryptToByteArray(const QString& text);
  QByteArray encryptToByteArray(QByteArray bytes);
  QByteArray decryptToByteArray(const QString& text);
  QByteArray decryptToByteArray(QByteArray bytes);

  bool hasKey() const {
    return !m_keyParts.isEmpty();
  }

  void setEncryptedFilePassword(const QString& password) {
    mEncryptedFilePassword = password;
  }

  QString encryptedFilePassword() {
    return mEncryptedFilePassword;
  }

  static void initialize();

 private:
  quint64 generateKeyFromPassword(const QString& password);
  void splitKey();
  bool canEncrypt();
  const DataStoreFileNames& mDataStoreFileNames;

  const QString mDefaultPassword = {"password"};
  QString mEncryptedFilePassword {mDefaultPassword};
  quint64 m_key;
  QVector<char> m_keyParts;

  const char mVersionPart1 {0x01};
  const char mVersionPart2 {0x00};


};

