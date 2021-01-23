#include <QApplication>
#include <QQuickStyle>
#include "initializer.hpp"
#include "util/permissions.hpp"
#include "datastore/fileencryptor.hpp"
#include "datastore/downloadspathcontroller.hpp"

int main( int argc, char* argv[] )
{
  QApplication app( argc, argv );

  QCoreApplication::setApplicationName( QObject::tr( "Play It Safe" ) );
  QCoreApplication::setOrganizationDomain( "twentysixapps.com" );
  QCoreApplication::setOrganizationName( QLatin1String( "26Apps" ) );
  QCoreApplication::setApplicationVersion( "2.00" );

  QObject::connect( &app, &QGuiApplication::lastWindowClosed, &app, &QGuiApplication::quit );

  DataStoreManager mDataStoreManager;
  FileEncryptor::initialize( );
  DownloadsPathController::initAppDownloadFolder();
  Initializer initializer( mDataStoreManager );
  Permissions permissions;
  permissions.requestExternalStoragePermission();

  if ( permissions.getPermissionResult() ) {
    qWarning( "Successfully obtained required permissions, app starting" );
    return app.exec();
  } else {
    qWarning( "Failed to obtain required permissions, app terminating" );
  }


}
