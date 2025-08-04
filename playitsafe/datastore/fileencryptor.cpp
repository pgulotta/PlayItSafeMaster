#include "fileencryptor.hpp"
#include "datastorefilenames.hpp"
#include "../model/common.hpp"
#include <QCryptographicHash>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QUuid>
#include <QSaveFile>
#include <QDataStream>
#include <QByteArray>
#include <QDateTime>

#include <QDebug>

//  Default compressed encyrpted data store:  com.twentysixapps.playitsafe.db
//  Example uncompressed unencrypted data store:  0a5c192a-1e9d-4716-aa37-cb3d0c4ae9fe.db
//  use fileInfo.absoluteFilePath();


FileEncryptor::FileEncryptor( const DataStoreFileNames& dataStoreFileNames ):
  mDataStoreFileNames{dataStoreFileNames}
{
}

void FileEncryptor::initialize()
{
  try {
    srand( uint( QDateTime::currentMSecsSinceEpoch() & 0xFFFF ) );
    QDir dir = QDir::root();
    dir.mkpath( DataStoreFileNames::AppDataFolder );
    qInfo() <<  "DataStoreFileNames::AppDataFolder=" << qPrintable( DataStoreFileNames::AppDataFolder );
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

FileEncryptor::~FileEncryptor()
{
}

void FileEncryptor::setKey( quint64 key )
{
  m_key = key;
  splitKey();
}

void FileEncryptor::splitKey()
{
  m_keyParts.clear();
  m_keyParts.resize( 8 );

  for ( int i = 0; i < 8; i++ ) {
    quint64 part = m_key;

    for ( int j = i; j > 0; j-- ) {
      part = part >> 8;
    }

    part = part & 0xff;
    m_keyParts[i] = static_cast<char>( part );
  }
}

QByteArray FileEncryptor::encryptToByteArray( const QString& text )
{
  QByteArray plaintextArray = text.toUtf8();
  return encryptToByteArray( plaintextArray );
}

QByteArray FileEncryptor::encryptToByteArray( QByteArray bytes )
{
  if ( m_keyParts.isEmpty() ) {
    qWarning( "FileEncryptor::encryptToByteArray: Encryption failed because no encrypt key set" );
    return QByteArray();
  }

  QByteArray ba = bytes;
  QByteArray compressed = qCompress( ba, 9 );

  if ( compressed.size() < ba.size() ) {
    ba = compressed;
  }

  QByteArray integrityProtection;
  QDataStream s( &integrityProtection, QIODevice::WriteOnly );
  s << qChecksum( ba.constData(), static_cast<uint>( ba.length() ) );
  char randomChar = char( rand() & 0xFF );
  ba = randomChar + integrityProtection + ba;

  int pos( 0 );
  char lastChar( 0 );
  int cnt = ba.size();

  while ( pos < cnt ) {
    ba[pos] = ba.at( pos ) ^ m_keyParts.at( pos % 8 ) ^ lastChar;
    lastChar = ba.at( pos );
    ++pos;
  }

  QByteArray resultArray;
  resultArray.append( mVersionPart1 );
  resultArray.append( mVersionPart2 );
  resultArray.append( ba );
  return resultArray;
}

QByteArray FileEncryptor::decryptToByteArray( const QString& text )
{
  QByteArray cyphertextArray = QByteArray::fromBase64( text.toLatin1() );
  QByteArray ba = decryptToByteArray( cyphertextArray );
  return ba;
}

QByteArray FileEncryptor::decryptToByteArray( QByteArray bytes )
{
  if ( m_keyParts.isEmpty() ) {
    qWarning( "FileEncryptor::decryptToByteArray: Decryption failed because no encryption key set" );
    return QByteArray();
  }

  QByteArray ba = bytes;

  if ( bytes.size() < 3 ) {
    qInfo( "FileEncryptor::decryptToByteArray: Decryption failed because there is no file to decrypt" );
    return QByteArray();
  }

  if ( mVersionPart1 !=  ba.at( 0 )  ||  mVersionPart2 !=  ba.at( 1 ) ) {
    qInfo( "FileEncryptor::decryptToByteArray: Decryption failed because source file version is invalid" );
    return QByteArray();
  }

  ba = ba.mid( 2 );
  int pos( 0 );
  int cnt( ba.size() );
  char lastChar = 0;

  while ( pos < cnt ) {
    char currentChar = ba[pos];
    ba[pos] = ba.at( pos ) ^ lastChar ^ m_keyParts.at( pos % 8 );
    lastChar = currentChar;
    ++pos;
  }

  ba = ba.mid( 1 );   //remove the random number at the start

  if ( ba.length() < 2 ) {
    qInfo( "FileEncryptor::decryptToByteArray: Decryption failed because source file is invalid" );
    return QByteArray();
  }

  quint16 storedChecksum;
  {
    QDataStream s( &ba, QIODevice::ReadOnly );
    s >> storedChecksum;
  }
  ba = ba.mid( 2 );
  quint16 checksum = qChecksum( ba.constData(), ba.length() );

  if ( checksum != storedChecksum ) {
    qInfo( "FileEncryptor::decryptToByteArray: Decryption failed because source file or password is invalid" );
    return QByteArray();
  }

  return qUncompress( ba );
}

bool FileEncryptor::FileEncryptor::decrypt()
{
// qInfo() <<  "FileEncryptor::decrypt: mUnencryptedFileName=" << qPrintable(mDataStoreFileNames.unencryptedFileName());
//qDebug() <<  "FileEncryptor::decrypt: mEncryptedFilePassword=" << qPrintable(mEncryptedFilePassword);
// qInfo()  <<  "FileEncryptor::decrypt: mEncryptedFileName=" << qPrintable(mDataStoreFileNames.encryptedFileName());
  bool result = false;

  try {
    if ( mEncryptedFilePassword.isEmpty() ) {
      qWarning() << "FileEncryptor::decrypt:  Encrypted file password is empty";
    } else if ( ! QFile::exists( mDataStoreFileNames.encryptedFileName() ) ) {
      qWarning()  << "FileEncryptor::decrypt:  Encrypted file does not exist: " << qPrintable(
                    mDataStoreFileNames.encryptedFileName() );
    } else if ( QFileInfo( mDataStoreFileNames.encryptedFileName() ).size() == 0 ) {
      qWarning()  << "FileEncryptor::decrypt:  Encrypted file size is zero: " << qPrintable(
                    mDataStoreFileNames.encryptedFileName() );
    } else {
      QFile source( mDataStoreFileNames.encryptedFileName() );
      QSaveFile destination( mDataStoreFileNames.unencryptedFileName() );
      setKey( generateKeyFromPassword( mEncryptedFilePassword ) );
      source.open( QIODevice::ReadOnly );
      destination.open( QIODevice::WriteOnly );
      auto bytes = decryptToByteArray( source.readAll() );

      //qInfo() <<  "FileEncryptor::decrypt: Source bytes read size = " << bytes.size();
      if ( bytes.isEmpty() ) {
        destination.cancelWriting();
      } else {
        destination.write( bytes );
      }

      destination.commit();
      source.close();
      result = ( QFile::exists( mDataStoreFileNames.unencryptedFileName() ) );
      //      if (result) {
      //        qInfo() <<  "FileEncryptor::decrypt: " << source.fileName() << " unencrypted to " << destination.fileName();
      //      }
    }
  } catch ( const std::exception& e ) {
    qWarning( "FileEncryptor::decrypt: Failed to write file %s; %s", qPrintable( mDataStoreFileNames.encryptedFileName() ),
              e.what() );
  }

  return result;
}
bool FileEncryptor::canEncrypt()
{
  if ( mDataStoreFileNames.unencryptedFileName().isEmpty() ) {
    return false;
  }

  if ( mEncryptedFilePassword.isEmpty() ) {
    return false;
  }

  if ( !QFile::exists( mDataStoreFileNames.unencryptedFileName() ) ) {
    return false;
  }

  return true;
}

bool FileEncryptor::encrypt()
{
  //qInfo() <<  "FileEncryptor::encrypt: mUnencryptedFileName=" << qPrintable(mDataStoreFileNames.unencryptedFileName());
  // qInfo() <<  "FileEncryptor::encrypt: mEncryptedFilePassword=" << qPrintable(mEncryptedFilePassword);
  //qInfo() <<  "FileEncryptor::encrypt: mEncryptedFileName=" << qPrintable(mDataStoreFileNames.encryptedFileName());
  try {
    if ( canEncrypt() ) {
      QFile source( mDataStoreFileNames.unencryptedFileName() );
      QSaveFile destination( mDataStoreFileNames.encryptedFileName() );
      setKey( generateKeyFromPassword( mEncryptedFilePassword ) );
      source.open( QIODevice::ReadOnly );
      destination.open( QIODevice::WriteOnly );
      auto bytes = source.readAll();
      qInfo() <<  "FileEncryptor::encrypt: Source bytes read size = " << bytes.size();
      destination.write( encryptToByteArray( bytes ) );
      destination.commit();
      source.close();
      qInfo() <<  "FileEncryptor::encrypt: Source file size = " << source.size();
    }
  } catch ( const std::exception& e ) {
    qWarning( "FileEncryptor::encrypt: Failed to write file %s; %s", qPrintable( mDataStoreFileNames.encryptedFileName() ),
              e.what() );
  }

  return ( QFile::exists( mDataStoreFileNames.encryptedFileName() ) );
}

quint64 FileEncryptor::generateKeyFromPassword( const QString& password )
{
  QByteArray hash = QCryptographicHash::hash(
                      QByteArray::fromRawData( ( const char* )password.utf16(), password.length() * 2 ),
                      QCryptographicHash::Md5 );
  Q_ASSERT( hash.size() == 16 );
  QDataStream stream( hash );
  qint64 a, b;
  stream >> a >> b;
  return a ^ b;
}
