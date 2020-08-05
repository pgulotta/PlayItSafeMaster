#include "datastoremanager.hpp"
#include "filechooser.hpp"
#include "pdfbuilder.hpp"
#include "investmentpricequery.hpp"
#include "downloadspathcontroller.hpp"
#include "../model/version.hpp"
#include "../model/recap.hpp"
#include "../model/bankaccount.hpp"
#include "../model/website.hpp"
#include "../model/investment.hpp"
#include "../model/realasset.hpp"
#include "../model/expense.hpp"
#include "../model/switchboardcategory.hpp"

#include <QDir>
#include <QDebug>
#include <QFile>
#include <QDate>
#include <QSharedPointer>


auto toStatus( bool value )
{
  return value ? " is successful" : " has failed";
}

DataStoreManager::DataStoreManager( QObject* parent ) :
  QObject{parent},
  mSwitchboardManager{this},
  mFileEncryptor{mDataStoreFileNames},
  mFileChooserResult{mFileChooserResultNotification}
{
  //  qDebug() << "DataStoreManager::DataStoreManager called";

  connect( &mInvestmentPriceQuery, &InvestmentPriceQuery::queryResultsRecieved, this,
           &DataStoreManager::onInvestmentResultsReceived );
  connect( &mInvestmentPriceQuery, &InvestmentPriceQuery::networkErrorOccurred, this,
           &DataStoreManager::onInvestmentNetworkErrorOccurred );
  connect( &mFileChooserResultNotification, &FileChooserResultNotification::fileChooserResultReceived, this,
           &DataStoreManager::onFileChooserResultReceived );
}

DataStoreManager::~DataStoreManager()
{
  try {
    mDataAccessAdapter.resetConnection( false );
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void DataStoreManager::onInvestmentNetworkErrorOccurred()
{
  try {
    mInvestmentPriceNotification.setUpdateSuccess( false );
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void DataStoreManager::onInvestmentResultsReceived()
{
  try {
    QList< QSharedPointer<PriceResult>>&  results {mInvestmentPriceQuery.priceResultList() };

    for ( auto result : results ) {
      mDataAccessAdapter.updateInvestment( result->InvestmentUniqueId, result->LastPrice );
    }

    investments( true );
    recap();
    storeDB();
    mInvestmentPriceNotification.setUpdateSuccess( true );
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void DataStoreManager::onFileChooserResultReceived( const QString& path )
{
  qInfo() << Q_FUNC_INFO << " path=" << path;
  mImportedFile.setImportFilePath( DownloadsPathController::tryResolveFilDownloadePath( path ) );
}

void DataStoreManager::clearAll()
{
  mDataAccessAdapter.clearAll( SwitchboardCategory::staticMetaObject.enumerator(
                                 SwitchboardCategory::getMonikerEnumIndex() ) );
  storeDB();
  reloadAllTables();
}

void DataStoreManager::storeDB()
{
  mFileEncryptor.encrypt();
}

void DataStoreManager::clearConnection( bool shouldResetConnection )
{
  mDataAccessAdapter.resetConnection( shouldResetConnection );
}

void DataStoreManager::cleanAppDataFolder( bool shouldResetConnection )
{
  try {
    qInfo() << "DataStoreManager::cleanAppDataFolder:  Attempting to clean  " << DataStoreFileNames::AppDataFolder;

    clearConnection( shouldResetConnection ) ;

    QDir dir( DataStoreFileNames::AppDataFolder );
    QFileInfoList files {dir.entryInfoList( QDir::Files )};

    for ( auto fileInfo : files ) {
      if ( !fileInfo.completeBaseName().startsWith( "com.twentysixapps.playitsafe" ) ) {
        if ( fileInfo.suffix() == "db" ) {
          QFile::remove( fileInfo.absoluteFilePath() );

          if ( QFile::exists( fileInfo.absoluteFilePath() ) ) {
            qWarning() <<  "DataStoreManager::cleanAppDataFolder: Unable to remove file " << fileInfo.absoluteFilePath();
          } else {
            qInfo() <<  "DataStoreManager::cleanAppDataFolder:  Sucessfully removed unused file " << fileInfo.absoluteFilePath();
          }
        }
      }
    }
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void DataStoreManager::toggleRecapSectionEnabled( const QString& section )
{
  for (  Recap* r : mRecapListModel ) {
    if ( r->section() == section ) {
      r->setEnabled( r->enabled() ? false : true );
    }
  }
}

void DataStoreManager::toggleRecapRowEnabled( const QString& uniqueId )
{
  for (  Recap* r : mRecapListModel ) {
    if ( r->uniqueId() == uniqueId ) {
      r->setEnabled( r->enabled() ? false : true );
      break;
    }
  }
}

void DataStoreManager::saveToPdf( bool displayWebsitePassword )
{
  PdfBuilder builder {displayWebsitePassword,  *this};
  builder.run();

  if ( QFile::exists( builder.pdfFilePath() ) ) {
    mSavedPdfFile.setPdfFilePath( builder.pdfFilePath() );
  } else {
    mSavedPdfFile.setPdfFilePath( mImportedFile.unresolvedFilePathId() );
  }
}

void DataStoreManager::selectDataStore()
{
  try {
    FileChooser fileChooser {mFileChooserResult};
    fileChooser.selectFile();
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

bool DataStoreManager::exportDataStore( QString& exportFilePath )
{
  QString exportedEncryptedFileName = exportDataStore();

  if ( exportedEncryptedFileName.isEmpty() ) {
    return  false;
  } else {
    exportFilePath = exportedEncryptedFileName;
    return true;
  }
}

QString DataStoreManager::exportDataStore()
{
  QString destinationFilePath;

  try {
    mFileEncryptor.encrypt();
    destinationFilePath =  DownloadsPathController::downloadsPath() + "/" + Common::createUniqueId() + ".db";
    QFile::copy( mDataStoreFileNames.encryptedFileName(), destinationFilePath );
    qInfo() << "DataStoreManager::exportDataStore destinationFilePath: " << destinationFilePath << " file size = " <<
            QFileInfo( destinationFilePath ).size();
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return QFile::exists( destinationFilePath )  ? destinationFilePath : "";
}

bool DataStoreManager::fileCopy( const QString& sourceFilePath, const  QString& destinationFilePath )
{
  qInfo() <<  "DataStoreManager::fileCopy: source = " << sourceFilePath << " Destination = " << destinationFilePath;

  if ( QFile::exists( destinationFilePath ) ) {
    if ( ! QFile::remove( destinationFilePath ) ) {
      qWarning() <<  "DataStoreManager::fileCopy: Unable to remove file" << destinationFilePath;
      return false;
    }
  }

  QFile source( sourceFilePath );
  QSaveFile destination{destinationFilePath};
  destination.open( QIODevice::WriteOnly );

  if ( source.open( QIODevice::ReadOnly ) ) {
    auto bytes = source.readAll();
    qInfo() <<  "DataStoreManager::fileCopy: Source bytes read size = " << bytes.size();

    if ( bytes.isEmpty() ) {
      destination.cancelWriting();
    } else {
      destination.write( bytes );
    }

    destination.commit();
    source.close();
    qInfo() <<  "DataStoreManager::fileCopy: Destination bytes copied size = " <<
            QFileInfo( destinationFilePath ).size();
  }

  return QFile::exists( destinationFilePath );
}

bool DataStoreManager::importDataStore( const QString& password )
{
  bool success = false;
  QString exportedEncryptedPassword = mFileEncryptor.encryptedFilePassword();

  try {
    clearConnection( true );
    cleanAppDataFolder( true );
    QFile::rename( mDataStoreFileNames.encryptedFileName(), mDataStoreFileNames.tempFileName() );
    DataStoreFileNames toImportFileNames{ "",  mImportedFile.importFilePath()};
    FileEncryptor importFileEncryptor{toImportFileNames};
    importFileEncryptor.setEncryptedFilePassword( password );
    success = importFileEncryptor.decrypt();

    if ( success ) {
      success = fileCopy( mImportedFile.importFilePath(), mDataStoreFileNames.encryptedFileName() );

      if ( success ) {
        mFileEncryptor.setEncryptedFilePassword( password );
        success =  tryOpenDB();
      }
    }

    if ( success ) {
      qInfo( "DataStoreManager::importDataStore: Successful" );
    } else {
      qWarning( "DataStoreManager::importDataStore: Failed" );
      QFile::remove( mDataStoreFileNames.encryptedFileName() );
      QFile::rename( mDataStoreFileNames.tempFileName(), mDataStoreFileNames.encryptedFileName() );
      mFileEncryptor.setEncryptedFilePassword( exportedEncryptedPassword );
      tryOpenDB();
    }
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return success;
}

bool DataStoreManager::setDataStorePassword( const QString& password )
{
  //qDebug() << "DataStoreManager::setDataStorePassword: isPasswordNew = " << isPasswordNew();
  //qDebug() << "DataStoreManager::setDataStorePassword: password = " << password;
  mFileEncryptor.setEncryptedFilePassword( password );
  storeDB();
  return tryOpenDB();
}

int DataStoreManager::convertToTimeNumeric( const QDate& date )
{
  return static_cast<int>( QDateTime( date ).toTime_t() );
}

QString DataStoreManager::convertToTimeText( const QDate& date )
{
  return QString::number( convertToTimeNumeric( date ) );
}

Version* DataStoreManager::version()
{
  return mDataAccessAdapter.version();
}

bool DataStoreManager::openPseudoDB()
{
  bool success = false;

  try {
    bool dbExists = QFile::exists( mDataStoreFileNames.pseudoAppFileName() );

    if ( !dbExists ) {
      mDataAccessAdapter.createDB( mDataStoreFileNames.pseudoAppFileName() );
    }

    success = mDataAccessAdapter.openDB( mDataStoreFileNames.pseudoAppFileName() );
    qInfo() <<  "DataStoreManager::openPseudoDB: db=" << mDataStoreFileNames.pseudoAppFileName() << " status is " <<
            toStatus( success );
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  return success;
}

void DataStoreManager::reloadAllTables()
{
  bankAccounts( true );
  realAssets( true );
  investments( true );
  expenses( true );
  websites( true );
  websitesWithoutNone();
  recap();
}

bool DataStoreManager::tryOpenDB()
{
  // qDebug() <<  "DataStoreManager::tryOpenDB: encryptedFilePassword=" << qPrintable(mFileEncryptor.encryptedFilePassword());
  qInfo() <<  "DataStoreManager::tryOpenDB: encryptedFileName=" << qPrintable( mDataStoreFileNames.encryptedFileName() );
  qInfo()  <<  "DataStoreManager::tryOpenDB: unencryptedFileName=" << qPrintable(
             mDataStoreFileNames.unencryptedFileName() );
  qInfo()  <<  "DataStoreManager::tryOpenDB: pseudoAppFileName=" << qPrintable( mDataStoreFileNames.pseudoAppFileName() );

  bool success = false;

  try {
    bool encryptedDbExists = QFile::exists( mDataStoreFileNames.encryptedFileName() );

    if ( !encryptedDbExists ) {
      mDataAccessAdapter.createDB( mDataStoreFileNames.unencryptedFileName() );
      mFileEncryptor.encrypt();
      encryptedDbExists = QFile::exists( mDataStoreFileNames.encryptedFileName() );
    }

    if ( encryptedDbExists ) {
      if ( mFileEncryptor.decrypt() ) {
        if ( mDataAccessAdapter.openDB( mDataStoreFileNames.unencryptedFileName() ) ) {
          reloadAllTables();
          mDataAccessAdapter.versionUpdate();
          mInvestmentPriceQuery.query( mInvestmentListModel );
          success = true;
        }
      }
    }
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  if ( success ) {
    qInfo() <<  "DataStoreManager::tryOpenDB succeeded" ;
  } else {
    qWarning() << Q_FUNC_INFO << " failed" ;
  }

  return success;
}

bool DataStoreManager::isPasswordNew() const
{
  return !QFile::exists( mDataStoreFileNames.encryptedFileName() );
}

QQmlObjectListModel<BankAccount>* DataStoreManager::bankAccounts( bool reload )
{
  return &( getListModel( mBankAccountListModel, reload ) );
}

QQmlObjectListModel<Investment>* DataStoreManager::investments( bool reload )
{
  return &( getListModel( mInvestmentListModel, reload ) );
}

QQmlObjectListModel<RealAsset>* DataStoreManager::realAssets( bool reload )
{
  return &( getListModel( mRealAssetListModel, reload ) );
}

QQmlObjectListModel<Expense>* DataStoreManager::expenses( bool reload )
{
  return &( getListModel( mExpenseListModel, reload ) );
}

QQmlObjectListModel<Website>* DataStoreManager::websites( bool reload )
{
  return &( getListModel( mWebsiteListModel, reload ) );
}

QQmlObjectListModel<Website>* DataStoreManager::websitesWithoutNone()
{
  websites();
  mWithoutNoneWebsiteListModel.clear();

  for (  Website* website : mWebsiteListModel ) {
    if ( website->uniqueId().compare( Common::WebsiteNoneId, Qt::CaseInsensitive ) != 0 ) {
      mWithoutNoneWebsiteListModel.append( website );
    }
  }

  return &mWithoutNoneWebsiteListModel;
}

QQmlObjectListModel<Recap>* DataStoreManager::recap( bool reload )
{
  if ( reload ) {
    mRecapListModel.clear();

    for (  BankAccount* ba : mBankAccountListModel ) {
      mRecapListModel.append( new Recap { ba->uniqueId(), ba->bankName(), ba->nameOnAccount(), ba->amount(),
                                          mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::BankAccount ), "qrc:/ui/BankAccountsPage.qml", true } );
    }

    for (  Investment* in : mInvestmentListModel ) {
      mRecapListModel.append( new Recap { in->uniqueId(), in->issuer(), in->nameOnAccount(), in->amount(),
                                          mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::Investment ), "qrc:/ui/InvestmentsPage.qml", true } );
    }

    for (  RealAsset* ra : mRealAssetListModel ) {
      mRecapListModel.append( new Recap { ra->uniqueId(), ra->description(), ra->effectiveDate().toString( Common::DateDisplayFormat ), ra->valuation(),
                                          mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::RealAsset ), "qrc:/ui/RealAssetsPage.qml", true } );
    }

    for (  Expense* ex : mExpenseListModel ) {
      mRecapListModel.append( new Recap { ex->uniqueId(), ex->payee(), ex->nextPaymentDate().toString( Common::DateDisplayFormat ), ( -1.0 * ex->amount() ),
                                          mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::Expense ),  "qrc:/ui/ExpensesPage.qml", true } );
    }
  }

  qInfo() <<  "DataStoreManager::getRecapListModel() QQmlObjectListModel count: " << mRecapListModel.count();
  return &mRecapListModel;
}

const Website* DataStoreManager::getWebsite( const QString& uniqueId )
{
  QQmlObjectListModel<Website>&  websites =  getListModel( mWebsiteListModel );
  auto cit =  std::find_if( websites.constBegin(), websites.constEnd(), [&uniqueId]( Website * w ) {
    return w->uniqueId() == uniqueId;
  } );
  return ( cit == websites.constEnd() ) ? nullptr : *cit;
}

QObject* DataStoreManager::newItem( int moniker )
{
  QObject* objPtr = nullptr;
  SwitchboardCategory::Moniker monikerId = static_cast< SwitchboardCategory::Moniker>( moniker );

  switch ( monikerId ) {
  case SwitchboardCategory::Moniker::BankAccount:
    objPtr = new BankAccount();
    break;

  case SwitchboardCategory::Moniker::RealAsset:
    objPtr = new RealAsset();
    break;

  case SwitchboardCategory::Moniker::Investment:
    objPtr = new Investment();
    break;

  case SwitchboardCategory::Moniker::Expense:
    objPtr = new Expense();
    break;

  case SwitchboardCategory::Moniker::Website:
    objPtr = new Website();
    break;

  case SwitchboardCategory::Moniker::Recap:
    break;
  }

  qInfo() << "QObject* newItem(int moniker) = " << moniker;
  return objPtr;
}

void DataStoreManager::saveItem( int moniker, bool isAddNew, QObject* objPtr )
{
  if ( objPtr == nullptr ) {
    return;
  }

  SwitchboardCategory::Moniker monikerId = static_cast< SwitchboardCategory::Moniker>( moniker );

  switch ( monikerId ) {
  case SwitchboardCategory::Moniker::BankAccount:
    if ( isAddNew ) {
      mDataAccessAdapter.insert<BankAccount>( *static_cast<BankAccount*>( objPtr ) );
    } else {
      mDataAccessAdapter.update( *static_cast<BankAccount*>( objPtr ) );
    }

    bankAccounts( true );
    break;

  case SwitchboardCategory::Moniker::RealAsset:
    if ( isAddNew ) {
      mDataAccessAdapter.insert( *static_cast<RealAsset*>( objPtr ) );
    } else {
      mDataAccessAdapter.update( *static_cast<RealAsset*>( objPtr ) );
    }

    realAssets( true );
    break;

  case SwitchboardCategory::Moniker::Investment:
    if ( isAddNew ) {
      mDataAccessAdapter.insert( *static_cast<Investment*>( objPtr ) );
    } else {
      mDataAccessAdapter.update( *static_cast<Investment*>( objPtr ) );
    }

    investments( true );
    break;

  case SwitchboardCategory::Moniker::Expense:
    if ( isAddNew ) {
      mDataAccessAdapter.insert( *static_cast<Expense*>( objPtr ) );
    } else {
      mDataAccessAdapter.update( *static_cast<Expense*>( objPtr ) );
    }

    expenses( true );
    break;

  case SwitchboardCategory::Moniker::Website:
    if ( isAddNew ) {
      mDataAccessAdapter.insert( *static_cast<Website*>( objPtr ) );
    } else {
      mDataAccessAdapter.update( *static_cast<Website*>( objPtr ) );
    }

    websites( true );
    websitesWithoutNone();
    break;

  case SwitchboardCategory::Moniker::Recap:
    break;
  }

  recap();
  storeDB();
}

void DataStoreManager::removeItem( int moniker, const QString& uniqueId )
{
  SwitchboardCategory::Moniker monikerId = static_cast< SwitchboardCategory::Moniker>( moniker );

  switch ( monikerId ) {
  case SwitchboardCategory::Moniker::BankAccount:
    mDataAccessAdapter.remove<BankAccount>( uniqueId );
    bankAccounts( true );
    break;

  case SwitchboardCategory::Moniker::RealAsset:
    mDataAccessAdapter.remove<RealAsset>( uniqueId );
    realAssets( true );
    break;

  case SwitchboardCategory::Moniker::Investment:
    mDataAccessAdapter.remove<Investment>( uniqueId );
    investments( true );
    break;

  case SwitchboardCategory::Moniker::Expense:
    mDataAccessAdapter.remove<Expense>( uniqueId );
    expenses( true );
    break;

  case SwitchboardCategory::Moniker::Website:
    if ( uniqueId != Common::WebsiteNoneId ) {
      mDataAccessAdapter.remove<Website>( uniqueId );
      websites( true );
      websitesWithoutNone();
    }

    break;

  case SwitchboardCategory::Moniker::Recap:
    break;
  }

  recap();
  storeDB();
}

template <typename T>
QQmlObjectListModel<T>&  DataStoreManager::getListModel( QQmlObjectListModel<T>& listModel,  bool reload )
{
  if ( reload || listModel.count() == 0 ) {
    listModel.clear();
    mDataAccessAdapter.select( listModel );
    qInfo() <<  typeid( T ).name() << " list model record count = " << listModel.count();
  }

  return listModel;
}
