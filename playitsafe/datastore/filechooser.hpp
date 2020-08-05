#pragma once
#include <QObject>
#include <QDebug>


class FileChooserResult;

class FileChooser : public QObject
{
Q_OBJECT

public slots:

signals:

public:
    FileChooser(FileChooserResult& fileChooserResult) : mFileChooserResult{fileChooserResult}
    {
    }

//    virtual ~FileChooser()
//    {
//        qDebug() << "FileChooser::~FileChooser called";
//    }

    void selectFile();

    explicit FileChooser(const FileChooser& rhs) = delete;
    FileChooser& operator= (const FileChooser& rhs) = delete;

private:
    FileChooserResult& mFileChooserResult;

};

