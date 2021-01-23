#pragma once

#include <QObject>
#include <QString>
#include "switchboardmanager.hpp"
#include "dataaccessadapter.hpp"
#include "investmentpricequery.hpp"
#include "filechooserresultnotification.hpp"
#include "filechooserresult.hpp"
#include "fileencryptor.hpp"
#include "downloadspathcontroller.hpp"
#include "datastorefilenames.hpp"
#include "../model/common.hpp"
#include "../model/investmentpricenotification.hpp"
#include "../model/importfilenotification.hpp"
#include "../model/pdfcreatednotification.hpp"
#include "../util/qqmlobjectlistmodel.hpp"
#include "../util/sqlite.hpp"

class QDate;
class Version;
class BankAccount;
class Investment;
class RealAsset;
class Expense;
class Website;
class Recap;


class DataStoreManager : public QObject
{
  Q_OBJECT
  Q_PROPERTY( QString downloadsPath READ downloadsPath WRITE setDownloadsPath )

public slots:
  void onFileChooserResultReceived( const QString& path );
  void onInvestmentNetworkErrorOccurred();
  void onInvestmentResultsReceived();
  static void setDownloadsPath( const QString& downloadsPath )
  {
    DownloadsPathController::setDownloadsPath( downloadsPath );
  }


signals:

public:
  Q_INVOKABLE bool importDataStore( const QString& password );
  Q_INVOKABLE QString exportDataStore();
  Q_INVOKABLE void selectDataStore();
  Q_INVOKABLE void saveToPdf( bool diplayWebsitePassword );
  Q_INVOKABLE void clearAll();
  Q_INVOKABLE void toggleRecapSectionEnabled( const QString& section );
  Q_INVOKABLE void toggleRecapRowEnabled( const QString& uniqueId );
  Q_INVOKABLE QObject* newItem( int moniker );
  Q_INVOKABLE void removeItem( int moniker, const QString& uniqueId );
  Q_INVOKABLE void saveItem( int moniker, bool isAddNew, QObject* objPtr );
  Q_INVOKABLE bool isPasswordNew() const;
  Q_INVOKABLE bool setDataStorePassword( const QString& password ) ;

  explicit DataStoreManager( QObject* parent = nullptr );
  virtual ~DataStoreManager();
  const Website* getWebsite( const QString& uniqueId );
  static QString convertToTimeText( const QDate& date );
  static int convertToTimeNumeric( const QDate& date );
  Version* version();
  bool openPseudoDB();
  bool tryOpenDB();
  void cleanAppDataFolder( bool shouldResetConnection );
  QQmlObjectListModel<BankAccount>* bankAccounts( bool reload = false );
  QQmlObjectListModel<Investment>* investments( bool reload = false );
  QQmlObjectListModel<RealAsset>* realAssets( bool reload = false );
  QQmlObjectListModel<Expense>* expenses( bool reload = false );
  QQmlObjectListModel<Website>* websites( bool reload = false );
  QQmlObjectListModel<Website>* websitesWithoutNone();
  QQmlObjectListModel<Recap>* recap( bool reload = true );


  ImportFileNotification* importedFile()
  {
    return &mImportedFile;
  }

  PdfCreatedNotification* savedPdfFile()
  {
    return &mSavedPdfFile;
  }

  InvestmentPriceNotification* investmentPriceUpdate()
  {
    return &mInvestmentPriceNotification;
  }

  SwitchboardManager& switchboardManager()
  {
    return mSwitchboardManager;
  }

  DataAccessAdapter& dataAccessAdapter()
  {
    return mDataAccessAdapter;
  }

  QString downloadsPath() const
  {
    return DownloadsPathController::downloadsPath();
  }

private:
  bool createDB( const QString& dbFileName );
  void reloadAllTables();
  bool fileCopy( const QString& sourceFilePath, const  QString& destinationFilePath );
  bool exportDataStore( QString& exportFilePath );
  void clearConnection( bool shouldResetConnection );
  void storeDB();

  DataStoreFileNames mDataStoreFileNames;
  DataAccessAdapter mDataAccessAdapter;
  SwitchboardManager mSwitchboardManager;
  InvestmentPriceQuery mInvestmentPriceQuery;
  FileEncryptor mFileEncryptor;
  FileChooserResult mFileChooserResult;
  FileChooserResultNotification mFileChooserResultNotification;
  InvestmentPriceNotification mInvestmentPriceNotification;
  ImportFileNotification mImportedFile;
  PdfCreatedNotification mSavedPdfFile;

  QQmlObjectListModel<Recap> mRecapListModel;
  QQmlObjectListModel<BankAccount> mBankAccountListModel;
  QQmlObjectListModel<Investment> mInvestmentListModel;
  QQmlObjectListModel<RealAsset> mRealAssetListModel;
  QQmlObjectListModel<Expense> mExpenseListModel;
  QQmlObjectListModel<Website> mWebsiteListModel;
  QQmlObjectListModel<Website> mWithoutNoneWebsiteListModel;

  template <typename T> QQmlObjectListModel<T>& getListModel( QQmlObjectListModel<T>& listModel, bool reload = false );





};



