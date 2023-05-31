#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QTimer>
#include <QQueue>
#include <QSharedPointer>
#include <QList>
#include "../util/qqmlobjectlistmodel.hpp"

class Investment;
struct PriceQuery;
struct PriceResult;
class QNetworkReply;

class InvestmentPriceQuery : public QObject
{
    Q_OBJECT

signals:
    void queryResultsRecieved();
    void networkErrorOccurred();

public:
    explicit InvestmentPriceQuery(QObject *parent = 0);
    void query(const QQmlObjectListModel<Investment> &investments);

    QList< QSharedPointer<PriceResult> >  &priceResultList()
    {
        return mPriceResultList;
    }

public slots:
    void onNetworkQueryTimer();
    void onNetworkReply(QNetworkReply *networkReply);

private:
    void runQuery(const QSharedPointer<PriceQuery> &investments);
    bool shouldAutoUpdate();
    QNetworkAccessManager mNetworkAccessManager;
    QTimer mNetworkQueryTimer;
    QQueue< QSharedPointer<PriceQuery> > mPriceQueryQueue;
    QList< QSharedPointer<PriceResult> > mPriceResultList;
    int mInvestmentQueriesCount {0};
    // const QString gInvestmentPriceAPI {"https://cloud.iexapis.com/stable/stock/%1/quote?token=pk_3532d8dd6756498b9c69949b8c97b528"};
    const QString mInvestmentPriceAPI{"https://apistocks.p.rapidapi.com/intraday?symbol=%1&interval=5min&maxreturn=1"};

    //    auto request = QNetworkRequest(m_url);
    //    request.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader, contentTypeJson);
    //    request.setRawHeader(authorizationToken, m_authorizationToken);
    //   request.setRawHeader(QByteArray("Last-Modified"), QByteArray("Sun, 06 Nov 1994 08:49:37 GMT"));

};

struct PriceResult
{
    QString InvestmentUniqueId;
    double LastPrice;
};

struct PriceQuery
{
    QString InvestmentUniqueId;
    QString IssuerSymbol;
};

