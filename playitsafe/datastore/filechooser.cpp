#include "filechooser.hpp"
#include "filechooserresult.hpp"
#include "filechooserresultnotification.hpp"

#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidActivityResultReceiver>


void FileChooser::selectFile()
{
    QAndroidJniObject action = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
    QAndroidJniObject intent("android/content/Intent");
    if (action.isValid() && intent.isValid()) {
        qInfo() << "FileChooser::selectFile called for android action " << action.toString();
        intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", action.object<jstring>());
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("*/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), FileChooserResultNotification::RequestCode, &mFileChooserResult);
    } else {
        qWarning() << "FileChooser::selectFile:  GET_CONTENT is not supported ";
    }
}


#else


void FileChooser::selectFile()
{
}


#endif
