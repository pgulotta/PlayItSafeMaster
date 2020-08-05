TEMPLATE = app

QT += \
    qml \
    quick \
    quickcontrols2 \
    printsupport


CONFIG += c++1z

# https://stackoverflow.com/questions/29308589/does-qt-no-debug-cause-a-definition-of-ndebug
CONFIG(release, debug|release): DEFINES += NDEBUG


DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    initializer.cpp \
    model/common.cpp \
    datastore/fileencryptor.cpp \
    datastore/switchboardmanager.cpp \
    datastore/datastoremanager.cpp \
    datastore/tableinsert.cpp \
    datastore/tableselect.cpp \
    datastore/tableupdate.cpp \
    datastore/filechooser.cpp \
    datastore/pdfbuilder.cpp \
    datastore/investmentpricequery.cpp \
    datastore/dataaccessadapter.cpp \
    datastore/downloadspathcontroller.cpp \
    util/sqlite3.c \
    util/qqmlobjectlistmodel.cpp \
    datastore/datastorefilenames.cpp \
    util/permissions.cpp


HEADERS += \
    initializer.hpp \
    model/version.hpp \
    model/website.hpp \
    model/switchboardcategory.hpp \
    model/bankaccount.hpp \
    model/expense.hpp \
    model/investment.hpp \
    model/realasset.hpp \
    model/recap.hpp \
    model/common.hpp \
    model/importfilenotification.hpp \
    model/pdfcreatednotification.hpp \
    datastore/pdfbuilder.hpp \
    datastore/switchboardmanager.hpp \
    datastore/datastoremanager.hpp \
    datastore/tableinsert.hpp \
    datastore/tableselect.hpp \
    datastore/tableupdate.hpp \
    datastore/fileencryptor.hpp \
    datastore/filechooser.hpp \
    datastore/filechooserresult.hpp \
    datastore/filechooserresultnotification.hpp  \
    datastore/dataaccessadapter.hpp \
    datastore/investmentpricequery.hpp \
    datastore/downloadspathcontroller.hpp \
    util/qqmlobjectlistmodel.hpp \
    util/sqlite.hpp \
    util/sqlite3.h \
    util/handle.hpp \
    model/investmentpricenotification.hpp \
    datastore/datastorefilenames.hpp \
    util/permissions.hpp

RESOURCES += qml.qrc
QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

ICON = Resources/icon.png
win32: RC_FILE = Resources/PlayItSafe.rc

android {
    QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

include(<../../../../android_openssl/openssl.pri)
}

unix:!macx: LIBS += -ldl
unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat


message(****  PlayItSafe  ****)
message(Qt version: $$[QT_VERSION])
message(Qt is installed in $$[QT_INSTALL_PREFIX])
message(Qt resources can be found in the following locations:)
message(Documentation: $$[QT_INSTALL_DOCS])
message(Header files: $$[QT_INSTALL_HEADERS])
message(Libraries: $$[QT_INSTALL_LIBS])
message(Binary files (executables): $$[QT_INSTALL_BINS])
message(Plugins: $$[QT_INSTALL_PLUGINS])
message(Data files: $$[QT_INSTALL_DATA])
message(Translation files: $$[QT_INSTALL_TRANSLATIONS])
message(Settings: $$[QT_INSTALL_CONFIGURATION])
message(PWD = $$PWD)
message(INCLUDEPATH = $$INCLUDEPATH)
message(TEST_SOURCE_DIR = $$TEST_SOURCE_DIR)
message(GOOGLETEST_DIR = $$GOOGLETEST_DIR)
message(ANDROID_EXTRA_LIBS = $$ANDROID_EXTRA_LIBS)
message(****  PlayItSafe  ****)

