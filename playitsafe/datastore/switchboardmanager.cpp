#include "switchboardmanager.hpp"
#include <QCoreApplication>


const QString gAppName {"Play It Safe"};

SwitchboardManager::SwitchboardManager(QObject *parent) :
    QObject{parent},
    mCategories{parent},
    m_appName{gAppName}
{
    //qDebug() << "SwitchboardManager::SwitchboardManager called";
    initSwitchboard();
}

QString SwitchboardManager::appVersion() const
{
    return QCoreApplication::applicationVersion();
}

QString SwitchboardManager::getTitleFromMoniker( SwitchboardCategory::Moniker moniker) const
{
    auto cit =  std::find_if(mCategories.constBegin(), mCategories.constEnd(),[moniker]( SwitchboardCategory* c)
    {
        return c->moniker() == moniker;
    });
    return cit == mCategories.constEnd() ? "" : (*cit)->title();
}

void SwitchboardManager::initSwitchboard()
{
    mCategories.clear();

    mCategories.append(new SwitchboardCategory {tr("Bank Accounts"), "qrc:/images/bankaccount.png","qrc:/ui/BankAccountsPage.qml",
                                                SwitchboardCategory::Group::Asset, SwitchboardCategory::Moniker::BankAccount, this});

    mCategories.append(new SwitchboardCategory {tr("Investments"), "qrc:/images/investment.png", "qrc:/ui/InvestmentsPage.qml",
                                                SwitchboardCategory::Group::Asset, SwitchboardCategory::Moniker::Investment, this});

    mCategories.append(new SwitchboardCategory {tr("Real Assets"), "qrc:/images/realasset.png", "qrc:/ui/RealAssetsPage.qml",
                                                SwitchboardCategory::Group::Asset,  SwitchboardCategory::Moniker::RealAsset,this});

    mCategories.append(new SwitchboardCategory {tr("Expenses"), "qrc:/images/expense.png", "qrc:/ui/ExpensesPage.qml",
                                                SwitchboardCategory::Group::Liability, SwitchboardCategory::Moniker::Expense, this});

    mCategories.append(new SwitchboardCategory {tr("Websites"), "qrc:/images/website.png",  "qrc:/ui/WebsitesPage.qml",
                                                SwitchboardCategory::Group::Web,  SwitchboardCategory::Moniker::Website,this});

    mCategories.append(new SwitchboardCategory {tr("Recap"), "qrc:/images/recap.png",  "qrc:/ui/RecapPage.qml",
                                                SwitchboardCategory::Group::Reporting,  SwitchboardCategory::Moniker::Recap,this});
}
