part of 'account_info_bloc.dart';

@immutable
class AccountInfoState extends Equatable {
  const AccountInfoState({
    this.accountModel,
    this.dataState,
    this.baseResultModel,
    this.statementState,
    this.errorMessage,
  });

  final AccountModel? accountModel;
  final DataState? dataState;

  final BaseResultModel? baseResultModel;
  final DataState? statementState;

  final String? errorMessage;

  @override
  List<Object?> get props => [
        accountModel,
        dataState,
        baseResultModel,
        statementState,
      ];

  AccountInfoState copyWith({
    AccountModel? accountModel,
    DataState? dataState,
    BaseResultModel? baseResultModel,
    DataState? statementState,
    String? errorMessage,
  }) {
    return AccountInfoState(
      accountModel: accountModel ?? this.accountModel,
      dataState: dataState ?? this.dataState,
      baseResultModel: baseResultModel ?? this.baseResultModel,
      statementState: statementState ?? this.statementState,
      errorMessage: errorMessage,
    );
  }
}
