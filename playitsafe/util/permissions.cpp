#include "permissions.hpp"
#include <QMessageBox>
#include <QApplication>

Permissions::Permissions( QObject* parent ) : QObject( parent )
{
}

void Permissions::requestExternalStoragePermission()
{
  #if defined(Q_OS_ANDROID)
  this->mPermissionResult = false;
  QtAndroid::PermissionResult request = QtAndroid::checkPermission( "android.permission.WRITE_EXTERNAL_STORAGE" );

  if ( request == QtAndroid::PermissionResult::Denied ) {
    QtAndroid::requestPermissionsSync( QStringList() <<  "android.permission.WRITE_EXTERNAL_STORAGE" );
    request = QtAndroid::checkPermission( "android.permission.WRITE_EXTERNAL_STORAGE" );

    if ( request == QtAndroid::PermissionResult::Denied ) {
      this->mPermissionResult = false;

      if ( QtAndroid::shouldShowRequestPermissionRationale( "android.permission.READ_EXTERNAL_STORAGE" ) ) {
        mShowPermissionRationale = QAndroidJniObject ( "com/twentysixapps/symart/ShowPermissionRationale",
                                                       "(Landroid/app/Activity;)V",
                                                       QtAndroid::androidActivity().object<jobject>()
                                                     );
        QAndroidJniEnvironment env;

        if ( env->ExceptionCheck() ) {
          env->ExceptionClear();
        }
      }
    } else {
      this->mPermissionResult = true;
    }
  } else {
    this->mPermissionResult = true;
  }

  #else
  mPermissionResult = true;
  #endif
}

bool Permissions::getPermissionResult()
{
  return mPermissionResult;
}
