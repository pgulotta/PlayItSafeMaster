#include "pdfbuilder.hpp"
#include "../model/bankaccount.hpp"
#include "../model/common.hpp"
#include "../model/expense.hpp"
#include "../model/investment.hpp"
#include "../model/realasset.hpp"
#include "../model/recap.hpp"
#include "../model/switchboardcategory.hpp"
#include "../model/website.hpp"
#include "../util/qqmlobjectlistmodel.hpp"
#include "datastoremanager.hpp"
#include "switchboardmanager.hpp"

#include <QTextDocument>
#include <QTextCursor>
#include <QPrinter>
#include <QDir>
#include <QFontDatabase>


PdfBuilder::PdfBuilder( bool displayWebsitePassword,  DataStoreManager& dataStoreManager ) :
  mSwitchboardManager{dataStoreManager.switchboardManager()},
  mDisplayWebsitePassword{displayWebsitePassword}
{
  mRecapListModel = dataStoreManager.recap( false );
  mBankAccountListModel = dataStoreManager.bankAccounts();
  mInvestmentListModel = dataStoreManager.investments();
  mRealAssetListModel = dataStoreManager.realAssets();
  mExpenseListModel = dataStoreManager.expenses();
  mWithoutNoneWebsiteListModel = dataStoreManager.websitesWithoutNone();
  mTitleFormat.setFontWeight( QFont::Bold );
  mTextFormat.setFontWeight( QFont::Normal );
}

void PdfBuilder::run()
{
  try {
      QString fileName = DataStoreFileNames::DownloadsFolder + QDir::separator()
                         + Common::createUniqueId() + ".pdf";
      qInfo() << "PdfBuilder::run: fileName=" << fileName;
      QPrinter printer(QPrinter::PrinterResolution);
      printer.setOutputFormat(QPrinter::PdfFormat);
      printer.setOutputFileName(fileName);

      QFont defaultFont;
      defaultFont.setFamily("Courier");
      defaultFont.setStyleHint(QFont::Monospace);
      defaultFont.setFixedPitch(true);
    #ifdef Q_OS_ANDROID
    defaultFont.setPointSize( 12 );
    #else
    defaultFont.setPointSize( 10 );
    #endif
    QTextDocument document;
    document.setDefaultFont( defaultFont );
    document.setPageSize( printer.pageRect( QPrinter::DevicePixel ).size() );
    QTextCursor cursor {&document};

    cursor.insertText( QDate::currentDate().toString( ) );

    appendTitleRow( mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::Recap ),
                    calculateTotal( mRecapListModel ), cursor );
    cursor.insertText( Common::NewLine );
    appendTextRows( mRecapListModel, cursor );

    appendTitleRow( mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::BankAccount ),
                    calculateTotal( mBankAccountListModel ),
                    cursor );
    cursor.insertText( Common::NewLine );
    appendTextRows( mBankAccountListModel, cursor );

    appendTitleRow( mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::Investment ),
                    calculateTotal( mInvestmentListModel ),
                    cursor );
    cursor.insertText( Common::NewLine );
    appendTextRows( mInvestmentListModel, cursor );

    appendTitleRow( mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::RealAsset ),
                    calculateTotal( mRealAssetListModel ),
                    cursor );
    cursor.insertText( Common::NewLine );
    appendTextRows( mRealAssetListModel, cursor );

    appendTitleRow( mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::Expense ),
                    calculateTotal( mExpenseListModel ), cursor );
    cursor.insertText( Common::NewLine );
    appendTextRows( mExpenseListModel, cursor );

    appendTitleRow( mSwitchboardManager.getTitleFromMoniker( SwitchboardCategory::Moniker::Website ), cursor );
    cursor.insertText( Common::NewLine );
    appendWebsiteTextRows( cursor );

    document.print( &printer );
    mPdfFilePath = fileName;
  } catch ( const std::exception& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
    mPdfFilePath.clear();
  }
}

QString PdfBuilder::pdfFilePath() const
{
  return mPdfFilePath;
}

void PdfBuilder::appendTitleRow( const QString& title, QTextCursor& cursor )
{
  cursor.mergeCharFormat( mTitleFormat );
  cursor.insertText( Common::NewLine );
  cursor.insertText( Common::NewLine );
  cursor.insertText( Common::NewLine );
  cursor.insertText( title.toUpper() );
  cursor.mergeCharFormat( mTextFormat );
}

void PdfBuilder::appendTitleRow( const QString& title, double amount, QTextCursor& cursor )
{
  cursor.mergeCharFormat( mTitleFormat );
  cursor.insertText( Common::NewLine );
  cursor.insertText( Common::NewLine );
  cursor.insertText( Common::NewLine );
  cursor.insertText(  QString( "%1:  %2" ).arg( title.toUpper() ).arg( QLocale().toCurrencyString( amount ) ) );
  cursor.mergeCharFormat( mTextFormat );
}
void PdfBuilder::appendHeadingRow( const QString& heading, QTextCursor& cursor )
{
  cursor.mergeCharFormat( mTitleFormat );
  cursor.insertText( Common::NewLine );
  cursor.insertText( heading );
  cursor.mergeCharFormat( mTextFormat );
}

void PdfBuilder::appendWebsiteTextRows( QTextCursor& cursor )
{
  if ( mWithoutNoneWebsiteListModel->isEmpty() ) {
    return;
  }

  if ( mDisplayWebsitePassword ) {
    appendTextRows( mWithoutNoneWebsiteListModel, cursor );
  } else {
    appendHeadingRow( Website::heading(), cursor );

    for ( const Website* row : *mWithoutNoneWebsiteListModel ) {
      cursor.insertText( Common::NewLine );
      cursor.insertText( row->toStringExcludingPassword() );
    }
  }
}

template <typename T> double
PdfBuilder::calculateTotal( QQmlObjectListModel<T>* tListModel )
{
  return std::accumulate( tListModel->constBegin(), tListModel->constEnd(), 0.0,
  []( double result, T * rhs ) {
    return result + rhs->amount();
  } );
}

template <typename T> void
PdfBuilder::appendTextRows( QQmlObjectListModel<T>* tListModel, QTextCursor& cursor )
{
  if ( tListModel->isEmpty() ) {
    return;
  }

  appendHeadingRow( T::heading(), cursor );

  for ( const T* row : *tListModel ) {
    cursor.insertText( Common::NewLine );
    cursor.insertText( QString( *row ) );
  }
}
