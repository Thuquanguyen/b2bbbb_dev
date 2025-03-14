part of 'statement_online_bloc.dart';

@immutable
abstract class StatementOnlineEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class StatementOnlineEventGetTransactionHistory extends StatementOnlineEvent {
  StatementOnlineEventGetTransactionHistory(
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
