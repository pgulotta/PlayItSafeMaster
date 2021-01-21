#include "initializer.hpp"
#include "model/switchboardcategory.hpp"
#include "model/version.hpp"
#include "model/website.hpp"
#include "model/realasset.hpp"
#include "model/recap.hpp"
#include "model/expense.hpp"
#include "model/investment.hpp"
#include "model/bankaccount.hpp"
#include "model/investmentpricenotification.hpp"
#include "datastore/switchboardmanager.hpp"
#include <QApplication>
#include <QGuiApplication>
#include <QClipboard>
#include <QFile>
#include <QQmlContext>


Initializer::Initializer( QObject* parent ) :
  mDataStoreManager{parent}
{
  qDebug() << "Initializer::Initializer called";
  mDataStoreManager.openPseudoDB();

  auto rootContext = mQmlApplicationEngine.rootContext();
  qmlRegisterType<InvestmentPriceNotification>( "InvestmentPriceNotification", 1, 0, "InvestmentPriceNotification" );
  qmlRegisterType<SwitchboardCategory>( "SwitchboardCategory", 1, 0, "SwitchboardCategory" );
  qmlRegisterType<BankAccount>( "BankAccount", 1, 0, "BankAccount" );
  qmlRegisterType<Investment>( "Investment", 1, 0, "Investment" );
  qmlRegisterType<RealAsset>( "RealAsset", 1, 0, "RealAsset" );
  qmlRegisterType<Expense>( "Expense", 1, 0, "Expense" );
  qmlRegisterType<Website>( "Website", 1, 0, "Website" );
  qmlRegisterType<Website>( "Recap", 1, 0, "Recap" );
  qmlRegisterType<ImportFileNotification>( "ImportFileNotification", 1, 0, "ImportFileNotification" );
  qmlRegisterType<PdfCreatedNotification>( "PdfCreatedNotification", 1, 0, "PdfCreatedNotification" );

  rootContext->setContextProperty( "SwitchboardManager", &mDataStoreManager.switchboardManager() );
  rootContext->setContextProperty( "DataStoreManager", &mDataStoreManager );
  rootContext->setContextProperty( "AllCategories", mDataStoreManager.switchboardManager().categories() );
  rootContext->setContextProperty( "AllBankAccounts", mDataStoreManager.bankAccounts( false ) );
  rootContext->setContextProperty( "AllInvestments", mDataStoreManager.investments( false ) );
  rootContext->setContextProperty( "AllExpenses", mDataStoreManager.expenses( false ) );
  rootContext->setContextProperty( "AllRealAssets", mDataStoreManager.realAssets( false ) );
  rootContext->setContextProperty( "AllWebsites", mDataStoreManager.websites( false ) );
  rootContext->setContextProperty( "WebsitesWithoutNone", mDataStoreManager.websitesWithoutNone() );
  rootContext->setContextProperty( "RecapList", mDataStoreManager.recap() );
  rootContext->setContextProperty( "ImportedFile", mDataStoreManager.importedFile() );
  rootContext->setContextProperty( "SavedPdfFile", mDataStoreManager.savedPdfFile() );
  rootContext->setContextProperty( "InvestmentPriceUpdate", mDataStoreManager.investmentPriceUpdate() );

  mQmlApplicationEngine.load( QUrl( QStringLiteral( "qrc:/ui/MainPage.qml" ) ) );
}

Initializer::~Initializer()
{
  qDebug() << "Initializer::~Initializer called";
  QApplication::clipboard()->clear();
  mDataStoreManager.cleanAppDataFolder( false );

}
