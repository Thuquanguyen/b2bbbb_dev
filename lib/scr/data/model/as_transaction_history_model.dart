enum AccountHistoryDetailType { PROCESS, SUCCEED }

class AccountServiceTransactionHistoryModel {
  AccountServiceTransactionHistoryModel(
      {required this.code,
      required this.transactionTime,
      this.accountName,
      this.accountNumber,
      required this.destinationAccountName,
      required this.destinationAccountNumber,
      required this.amount,
      this.currency = '',
      required this.currentBalance,
      this.fee = '',
      this.transactionnote,
      this.status = AccountHistoryDetailType.SUCCEED,
      this.callback});

  final String code;
  final String transactionTime;
  final String? accountName;
  final String? accountNumber;
  final String destinationAccountName;
  final String destinationAccountNumber;
  final String amount;
  final String currency;
  final String currentBalance;
  final String? fee;
  final String? transactionnote;
  final AccountHistoryDetailType? status;
  final void Function()? callback;
}
