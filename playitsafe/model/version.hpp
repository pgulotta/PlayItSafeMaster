#pragma once

#include <QObject>
#include <QDateTime>
#include <QString>
#include <QDebug>

class Version final : public QObject
{
Q_OBJECT
Q_PROPERTY(QDateTime createdDate READ createdDate WRITE setCreatedDate NOTIFY createdDateChanged)
Q_PROPERTY(QDateTime lastUsedDate READ lastUsedDate WRITE setLastUsedDate NOTIFY lastUsedDateChanged)
Q_PROPERTY(int releaseNumber READ releaseNumber WRITE setReleaseNumber NOTIFY releaseNumberChanged)

signals:
    void createdDateChanged(QDateTime createdDate);
    void lastUsedDateChanged(QDateTime lastUsedDate);
    void releaseNumberChanged(int releaseNumber);

private slots:

public slots:
    void setCreatedDate(QDateTime createdDate)
    {
        if (m_createdDate == createdDate)
            return;

        m_createdDate = createdDate;
        emit createdDateChanged(createdDate);
    }
    void setLastUsedDate(QDateTime lastUsedDate)
    {
        if (m_lastUsedDate == lastUsedDate)
            return;

        m_lastUsedDate = lastUsedDate;
        emit lastUsedDateChanged(lastUsedDate);
    }
    void setReleaseNumber(int releaseNumber)
    {
        if (m_releaseNumber == releaseNumber)
            return;

        m_releaseNumber = releaseNumber;
        emit releaseNumberChanged(releaseNumber);
    }

public:
    explicit Version(QObject *parent = nullptr) :
        QObject(parent) {
        // qDebug() << "Version::Version called";
    }

//    virtual ~Version()
//    {
//        qDebug() << "Version::~Version called";
//    }

    QDateTime createdDate() const
    {
        return m_createdDate;
    }

    QDateTime lastUsedDate() const
    {
        return m_lastUsedDate;
    }

    int releaseNumber() const
    {
        return m_releaseNumber;
    }

private:
    QDateTime m_createdDate;
    QDateTime m_lastUsedDate;
    int m_releaseNumber;
};

