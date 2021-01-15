#include "investmentpricequery.hpp"
#include "../model/investment.hpp"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QStringList>
#include <QSettings>
#include <QStringView>

//const QString gInvestmentPriceAPI {"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&outputsize=compact&interval=60min&apikey=RD8W7TPV2G2TQRAU&symbol="};
//const QString gInvestmentPriceAPI {"https://api.iextrading.com/1.0/stock/%1/quote"};
const QString gInvestmentPriceAPI {"https://cloud.iexapis.com/stable/stock/%1/quote?token=pk_3532d8dd6756498b9c69949b8c97b528"};


const int gQueryTimerIntervalMs {500};

InvestmentPriceQuery::InvestmentPriceQuery( QObject* parent ) :
  QObject{parent}
{
  qInfo() << Q_FUNC_INFO << "SSL Library Build Version= " << QSslSocket::sslLibraryBuildVersionString();
  connect( &mNetworkAccessManager, &QNetworkAccessManager::finished, this, &InvestmentPriceQuery::onNetworkReply );
  connect( &mNetworkQueryTimer, &QTimer::timeout, this, &InvestmentPriceQuery::onNetworkQueryTimer );
}

void InvestmentPriceQuery::query( const QQmlObjectListModel<Investment>& investments )
{
  try {
    qInfo() << "InvestmentPriceQuery::query: Initiating current investment prices query";

    if ( shouldAutoUpdate() ) {
      mNetworkQueryTimer.stop();

      mPriceQueryQueue.clear();
      mPriceResultList.clear();

      for ( auto investment : investments ) {
        if ( investment->issuer().length() < 7 )
          mPriceQueryQueue.append( QSharedPointer<PriceQuery> {new PriceQuery { investment->uniqueId(), investment->issuer()}} );
      }

      mInvestmentQueriesCount = mPriceQueryQueue.count();
      onNetworkQueryTimer();
    }
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

void InvestmentPriceQuery::onNetworkQueryTimer()
{
  try {
    mNetworkQueryTimer.stop();

    if ( mPriceQueryQueue.count() > 0 ) {
      runQuery( mPriceQueryQueue.dequeue() );
      mNetworkQueryTimer.start( gQueryTimerIntervalMs );
    }
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }
}

bool InvestmentPriceQuery::shouldAutoUpdate()
{
  bool shouldUpdate = true;

  try {
    QSettings settings;
    shouldUpdate = settings.value( Common::AutoUpdateInvestmentPricesKey, QVariant( true ) ).toBool();
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
  }

  qInfo() << "InvestmentPriceQuery::shouldAutoUpdate:" << shouldUpdate;
  return shouldUpdate;

}

void InvestmentPriceQuery::runQuery( const QSharedPointer<PriceQuery>& investmentPrice )
{
  try {
    if ( investmentPrice->InvestmentUniqueId.isEmpty() || investmentPrice->IssuerSymbol.isEmpty() ) {
      return;
    }

    QString url {gInvestmentPriceAPI.arg( investmentPrice->IssuerSymbol )};
    auto networkRequest = QNetworkRequest( url );
    QStringList attributes { investmentPrice->InvestmentUniqueId};
    networkRequest.setAttribute( QNetworkRequest::Attribute::User, QVariant( attributes ) );
    mNetworkAccessManager.get( networkRequest );
    qInfo() << Q_FUNC_INFO << "  Symbol = " << investmentPrice->IssuerSymbol ;
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << e.what();
  }
}

void InvestmentPriceQuery::onNetworkReply( QNetworkReply* networkReply )
{
  if ( networkReply == nullptr ) {
    return;
  }



  try {
    --mInvestmentQueriesCount;
    QStringList attributes = networkReply->request().attribute( QNetworkRequest::Attribute::User ).toStringList();

    if ( attributes.isEmpty() ) {
      return;
    }

    const QString uniqueId { attributes[0]};
    const static QString lastPrice{"latestPrice"};
    const static QString comma{","};
    bool hasNetworkError {false};

    if ( networkReply->error() ) {
      hasNetworkError = true;
      qWarning() << "InvestmentPriceQuery::onNetworkReply: Unable to identify the price for " << uniqueId;
    } else {
      QString reply { networkReply->readAll()};
      QStringView source { reply};
      auto begIndex = source.indexOf( lastPrice ) + 13;
      auto size = source.indexOf( comma, begIndex ) - begIndex;
      QStringView extractedText{ source.mid( begIndex, size )};

      bool success;
      auto formattedPrice = extractedText.toString().toDouble( &success );

      if ( success && formattedPrice > 0.0 ) {
        mPriceResultList.append( QSharedPointer<PriceResult> {new PriceResult { uniqueId, formattedPrice}} );
      }
    }

    if ( mInvestmentQueriesCount < 1  && mPriceQueryQueue.isEmpty() ) {
      if ( mPriceResultList.isEmpty() ) {
        if ( hasNetworkError ) {
          qWarning() << Q_FUNC_INFO << "  Error = " << networkReply->error();
          emit networkErrorOccurred();
        }
      } else {
        qInfo() << "InvestmentPriceQuery::onNetworkReply: Investment price query complete; total prices updated=" <<
                mPriceResultList.count();
        emit queryResultsRecieved();
      }
    }
  } catch ( std::exception const& e ) {
    qWarning() << Q_FUNC_INFO << " " << e.what();
    emit networkErrorOccurred();
  }

  networkReply->deleteLater();
}

