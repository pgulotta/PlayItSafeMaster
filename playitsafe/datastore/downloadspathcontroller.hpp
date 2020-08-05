#pragma once

#include <QString>

class DownloadsPathController {
 public:
  static bool setDownloadsPath(const QString& downloadsPath);
  static QString initAppDownloadFolder() ;
  static QString downloadsPath() ;
  static QString tryResolveFilDownloadePath(const QString& unresolvedPath);
};

