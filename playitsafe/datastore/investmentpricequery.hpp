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
    void query(const QQmlObjectListModel<Investment>&investments);

    QList< QSharedPointer<PriceResult> >&  priceResultList()
    {
        return mPriceResultList;
    }

public slots:
    void onNetworkQueryTimer();
    void onNetworkReply(QNetworkReply *networkReply);

private:
    void runQuery(const QSharedPointer<PriceQuery>& investments);
    bool shouldAutoUpdate();
    QNetworkAccessManager mNetworkAccessManager;
    QTimer mNetworkQueryTimer;
    QQueue< QSharedPointer<PriceQuery> > mPriceQueryQueue;
    QList< QSharedPointer<PriceResult> > mPriceResultList;
    int mInvestmentQueriesCount {0};
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

