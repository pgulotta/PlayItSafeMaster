#pragma once

#include "../util/qqmlobjectlistmodel.hpp"
#include <QString>
#include <QTextCharFormat>

class DataStoreManager;
class QTextCursor;
class SwitchboardManager;
class BankAccount;
class Investment;
class RealAsset;
class Expense;
class Website;
class Recap;

class PdfBuilder {
 public:
  PdfBuilder(bool displayWebsitePassword, DataStoreManager& dataStoreManager);
  void run();

  QString pdfFilePath() const;

 private:
  template <typename T> void appendTextRows(QQmlObjectListModel<T>* tListModel,  QTextCursor& cursor);
  template <typename T> double calculateTotal(QQmlObjectListModel<T>* tListModel);
  void appendTitleRow(const QString& title, double amount, QTextCursor& cursor);
  void appendTitleRow(const QString& title, QTextCursor& cursor);
  void appendHeadingRow(const QString& heading, QTextCursor& cursor);
  void appendWebsiteTextRows(QTextCursor& cursor);

  SwitchboardManager& mSwitchboardManager;
  bool mDisplayWebsitePassword;
  QString mPdfFilePath;
  QQmlObjectListModel<Recap>* mRecapListModel;
  QQmlObjectListModel<BankAccount>* mBankAccountListModel;
  QQmlObjectListModel<Investment>* mInvestmentListModel;
  QQmlObjectListModel<RealAsset>* mRealAssetListModel;
  QQmlObjectListModel<Expense>* mExpenseListModel;
  QQmlObjectListModel<Website>* mWithoutNoneWebsiteListModel;
  QTextCharFormat mTitleFormat;
  QTextCharFormat mTextFormat;

};

