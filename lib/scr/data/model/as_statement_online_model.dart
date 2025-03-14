import 'package:b2b/scr/data/model/as_transaction_history_model.dart';

class AccountServiceStatementOnlineModel {
  AccountServiceStatementOnlineModel(this.date, this.transactionHistoryList,
      {this.isShow = true});
  final String date;
  final List<AccountServiceTransactionHistoryModel> transactionHistoryList;
  bool isShow;
}
