#pragma once
#include <QObject>
#include <QDebug>


class FileChooserResultNotification : public QObject
{
Q_OBJECT

public slots:

signals:
    void fileChooserResultReceived(const QString& path);

public:
    FileChooserResultNotification()
    {
        // qDebug() << "FileChooserResultNotification::FileChooserResultNotification called";
    }

//    virtual ~FileChooserResultNotification()
//    {
//        qDebug() << "FileChooserResultNotification::~FileChooserResultNotification called";
//    }

    void onFileChooserResult(const QString& path)
    {
        qInfo() << "FileChooserResultNotification::onFileChooserResult="<< path;
        emit fileChooserResultReceived(path);
    }

    static const int RequestCode {101};

    explicit FileChooserResultNotification(const FileChooserResultNotification& rhs) = delete;
    FileChooserResultNotification& operator= (const FileChooserResultNotification& rhs) = delete;

private:


};
