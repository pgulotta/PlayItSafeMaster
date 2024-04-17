#include <QApplication>
#include <QQuickStyle>
#include "initializer.hpp"
#include "datastore/fileencryptor.hpp"
#include "datastore/downloadspathcontroller.hpp"

int main( int argc, char* argv[] )
{
  QApplication app( argc, argv );

  QCoreApplication::setApplicationName( QObject::tr( "Play It Safe" ) );
  QCoreApplication::setOrganizationDomain( "twentysixapps.com" );
  QCoreApplication::setOrganizationName( QLatin1String( "26Apps" ) );
  QCoreApplication::setApplicationVersion("3.00");

  QObject::connect(&app, &QGuiApplication::lastWindowClosed, &app, &QGuiApplication::quit);

  DataStoreManager mDataStoreManager;
  FileEncryptor::initialize( );
  DownloadsPathController::initAppDownloadFolder();
  Initializer initializer( mDataStoreManager );
  app.exec();
}
