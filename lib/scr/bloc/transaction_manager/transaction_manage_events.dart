import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';

class TransuctionManageEvent {}

class TransuctionManageStartEvent extends TransuctionManageEvent {
  TransactionFilterCategory? category;

  TransuctionManageStartEvent({this.category});
}

class TransuctionManageRefreshEvent extends TransuctionManageEvent {}

class TransuctionManageClearEvent extends TransuctionManageEvent {}

class TransuctionManageUpdateFilterEvent extends TransuctionManageEvent {
  TransactionFilterRequest? filterRequest;
  TransactionFilterCategory? category;

  TransuctionManageUpdateFilterEvent({this.filterRequest, this.category});
}

class TransuctionManageClearFilterEvent extends TransuctionManageEvent {}

class TransuctionManageEnableSelectEvent extends TransuctionManageEvent {}

class TransuctionManageSelectSingleEvent extends TransuctionManageEvent {
  String transCode;

  TransuctionManageSelectSingleEvent({
    required this.transCode,
  });
}

class TransuctionManageSelectAllEvent extends TransuctionManageEvent {}

class TransuctionManageClearSelectEvent extends TransuctionManageEvent {}

class TransuctionManageLoadSingleEvent extends TransuctionManageEvent {
  String transactionCode;

  TransuctionManageLoadSingleEvent({
    required this.transactionCode,
});
}

class TransuctionManageLoadAdditionalInfoSingleEvent
    extends TransuctionManageEvent {
  String? debitAccountNumber;

  TransuctionManageLoadAdditionalInfoSingleEvent({this.debitAccountNumber});
}

class TransuctionManageClearSingleEvent extends TransuctionManageEvent {}

class TransuctionManageInitManageEvent extends TransuctionManageEvent {
  List<String>? transactionCodes;

  TransuctionManageInitManageEvent({this.transactionCodes});
}

class TransuctionManageClearInitManageEvent extends TransuctionManageEvent {}

class TransuctionManageConfirmSingleEvent extends TransuctionManageEvent {
  List<String>? transactionCodes;

  TransuctionManageConfirmSingleEvent({this.transactionCodes});
}

class TransuctionManageClearConfirmSingleEvent extends TransuctionManageEvent {}
