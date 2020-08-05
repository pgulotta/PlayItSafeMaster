#pragma once


#include "../util/qqmlobjectlistmodel.hpp"
#include "../model/switchboardcategory.hpp"
#include <QObject>


class SwitchboardManager final : public QObject
{
Q_OBJECT
Q_PROPERTY(QString appName READ appName CONSTANT )
Q_PROPERTY(QString appNameVersion READ appNameVersion CONSTANT )
Q_PROPERTY(QString appVersion READ appVersion CONSTANT )

public:
    explicit SwitchboardManager(QObject *parent= nullptr);

//    virtual ~SwitchboardManager()
//    {
//        qDebug() << "SwitchboardManager::~SwitchboardManager called";
//    }

    QString getTitleFromMoniker( SwitchboardCategory::Moniker moniker) const;
    QString appVersion() const;

    QString appNameVersion() const
    {
        return appName() + " v" + appVersion();
    }

    QString appName() const
    {
        return m_appName;
    }

    QQmlObjectListModel<SwitchboardCategory>* categories()
    {
        return &mCategories;
    }

private:
    void initSwitchboard();

    QQmlObjectListModel<SwitchboardCategory> mCategories;
    QString m_appNameVersion;
    QString m_appName;

};
