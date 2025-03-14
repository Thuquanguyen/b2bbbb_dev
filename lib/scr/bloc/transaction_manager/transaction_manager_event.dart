import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';

abstract class TransactionManagerEvent {}

class InitTransactionManageEvent extends TransactionManagerEvent {
  InitTransactionManageEvent({this.transactions, this.filterRequest});

  List<String?>? transactions;
  TransactionFilterRequest? filterRequest;
}

class InitFxTransactionManageEvent extends TransactionManagerEvent {
  InitFxTransactionManageEvent({this.transactions, this.filterRequest});

  List<String?>? transactions;
  TransactionFilterRequest? filterRequest;
}

class InitSavingTransactionManageEvent extends TransactionManagerEvent {
  InitSavingTransactionManageEvent({this.transCode});

  String? transCode;
}

class InitPayrollTransactionManageEvent extends TransactionManagerEvent {
  InitPayrollTransactionManageEvent({
    this.fileCode,
    this.transCode,
  });

  String? fileCode;
  String? transCode;
}

class InitBillTransactionManageEvent extends TransactionManagerEvent {
  InitBillTransactionManageEvent({this.transCode, this.filterRequest});

  String? transCode;
  TransactionFilterRequest? filterRequest;
}

class ConfirmTransactionManageEvent extends TransactionManagerEvent {
  ConfirmTransactionManageEvent({required this.type, this.rejectReason});

  String? rejectReason;
  CommitActionType type;
}

class ConfirmFxTransactionManageEvent extends TransactionManagerEvent {
  ConfirmFxTransactionManageEvent({required this.type, this.rejectReason});

  String? rejectReason;
  CommitActionType type;
}

class ConfirmSavingTransactionManageEvent extends TransactionManagerEvent {
  ConfirmSavingTransactionManageEvent({required this.type, this.rejectReason});

  String? rejectReason;
  CommitActionType type;
}

class ConfirmPayrollTransactionManageEvent extends TransactionManagerEvent {
  ConfirmPayrollTransactionManageEvent({
    required this.transCode,
    required this.type,
    this.rejectReason,
  });

  String? transCode;
  String? rejectReason;
  CommitActionType type;
}

class ConfirmBillTransactionManageEvent extends TransactionManagerEvent {
  ConfirmBillTransactionManageEvent({required this.type, this.rejectReason});

  String? rejectReason;
  CommitActionType type;
}

class GetAdditionalInfoTransactionManageEvent extends TransactionManagerEvent {
  GetAdditionalInfoTransactionManageEvent({
    this.accountNumber,
    this.bankCode,
    this.cityCode,
    this.branchCode,
  });

  String? accountNumber;
  String? bankCode;
  String? cityCode;
  String? branchCode;
}

class ClearTransactionManageInitConfirmState extends TransactionManagerEvent {}

class ClearFxTransactionManageInitConfirmState extends TransactionManagerEvent {}

class ClearSavingTransactionManageInitConfirmState extends TransactionManagerEvent {}

class ClearPayrollTransactionManageInitConfirmState extends TransactionManagerEvent {}

class ClearBillTransactionManageInitConfirmState extends TransactionManagerEvent {}

class GetSingleTransactionDetailEvent extends TransactionManagerEvent {
  String transCode;
  bool? isFx;

  GetSingleTransactionDetailEvent({
    required this.transCode,
    this.isFx,
  });
}
