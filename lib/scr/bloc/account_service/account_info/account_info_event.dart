part of 'account_info_bloc.dart';

@immutable
abstract class AccountInfoEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AccountInfoEventGetAccountList extends AccountInfoEvent {
  AccountInfoEventGetAccountList();
}

class AccountInfoEventSendStatement extends AccountInfoEvent {
  AccountInfoEventSendStatement(
      {required this.fileType,
      required this.fromDate,
      required this.toDate,
      required this.accountNumber,
      required this.fromAmount,
      required this.toAmount,
      required this.memo});

  final String fileType;
  final String fromDate;
  final String toDate;
  final String accountNumber;
  final double fromAmount;
  final double toAmount;
  final String memo;
}

class AccountInfoEventSendStatementOnline extends AccountInfoEvent {
  AccountInfoEventSendStatementOnline(
      {required this.fromDate,
      required this.toDate,
      required this.accountNumber,
      required this.fromAmount,
      required this.toAmount,
      required this.memo});

  final String fromDate;
  final String toDate;
  final String accountNumber;
  final double fromAmount;
  final double toAmount;
  final String memo;
}
