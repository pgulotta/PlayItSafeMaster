#pragma once

#include "datastore/datastoremanager.hpp"
#include <QQmlApplicationEngine>


class Initializer final
{
public:
  explicit Initializer( const Initializer& ) = delete;
  Initializer& operator= ( const Initializer& rhs ) = delete;

  explicit Initializer( DataStoreManager& dataStoreManager );

  ~Initializer();

private:
  QQmlApplicationEngine mQmlApplicationEngine;
  DataStoreManager& mDataStoreManager;

};

