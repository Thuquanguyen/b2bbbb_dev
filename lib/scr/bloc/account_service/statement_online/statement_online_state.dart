part of 'statement_online_bloc.dart';

@immutable
class StatementOnlineState extends Equatable {
  const StatementOnlineState(
      {this.accountServiceRequestModel,
      this.dataState,
      this.statementOnlineResponse,
      this.statementState,
      this.isRequestTimeOut = false});

  final AccountServiceRequestModel? accountServiceRequestModel;
  final DataState? dataState;

  final StatementOnlineResponse? statementOnlineResponse;
  final DataState? statementState;

  final bool? isRequestTimeOut;

  @override
  List<Object?> get props => [
        accountServiceRequestModel,
        dataState,
        statementOnlineResponse,
        statementState,
      ];

  StatementOnlineState copyWith(
      {AccountServiceRequestModel? accountServiceRequestModel,
      DataState? dataState,
      StatementOnlineResponse? statementOnlineResponse,
      DataState? statementState,
      bool? isRequestTimeOut}) {
    return StatementOnlineState(
        accountServiceRequestModel: accountServiceRequestModel ?? this.accountServiceRequestModel,
        dataState: dataState ?? this.dataState,
        statementOnlineResponse: statementOnlineResponse ?? this.statementOnlineResponse,
        statementState: statementState ?? this.statementState,
        isRequestTimeOut: isRequestTimeOut ?? this.isRequestTimeOut);
  }
}
