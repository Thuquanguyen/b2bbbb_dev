part of 'current_deposits_bloc.dart';

class CurrentDepositsState extends Equatable {
  const CurrentDepositsState({
    this.list,
    this.filterRequest,
    this.singleDetail,
    this.initState,
    this.selectedNominationAcc,
    this.confirmState,
    this.debitAccountList,
  });

  final CDSDepositsList? list;
  final TransactionFilterRequest? filterRequest;
  final CDSDepositsDetail? singleDetail;
  final CDSDepositsDetail? initState;
  final String? selectedNominationAcc;
  final CDSConfirmState? confirmState;
  final CDSDebitAccountList? debitAccountList;

  CurrentDepositsState copyWith({
    CDSDepositsList? list,
    TransactionFilterRequest? filterRequest,
    CDSDepositsDetail? singleDetail,
    CDSDepositsDetail? initState,
    String? selectedNominationAcc,
    CDSConfirmState? confirmState,
    CDSDebitAccountList? debitAccountList,
  }) {
    return CurrentDepositsState(
      list: list ?? this.list,
      filterRequest: filterRequest ?? this.filterRequest,
      singleDetail: singleDetail ?? this.singleDetail,
      initState: initState ?? this.initState,
      selectedNominationAcc:
          selectedNominationAcc ?? this.selectedNominationAcc,
      confirmState: confirmState ?? this.confirmState,
      debitAccountList: debitAccountList ?? this.debitAccountList,
    );
  }

  @override
  List<Object?> get props => [
        list,
        filterRequest,
        singleDetail,
        initState,
        selectedNominationAcc,
        confirmState,
        debitAccountList,
      ];
}

class CDSDepositsList {
  CDSDepositsList({
    this.dataState = DataState.init,
    this.list,
    this.error,
  });

  final DataState dataState;
  final List<SavingAccountModel>? list;
  final String? error;

  CDSDepositsList copyWith({
    DataState? dataState,
    List<SavingAccountModel>? list,
    String? error,
  }) {
    return CDSDepositsList(
      dataState: dataState ?? this.dataState,
      list: list ?? this.list,
      error: error ?? this.error,
    );
  }
}

class CDSDepositsDetail {
  CDSDepositsDetail({
    this.dataState = DataState.init,
    this.transactionSaving,
    this.additionalInfo,
    this.error,
  });

  final DataState dataState;
  final TransactionSavingModel? transactionSaving;
  final TransactionAdditionalInfoState? additionalInfo;
  final String? error;

  CDSDepositsDetail copyWith({
    DataState? dataState,
    TransactionSavingModel? transactionSaving,
    TransactionAdditionalInfoState? additionalInfo,
    String? error,
  }) {
    return CDSDepositsDetail(
      dataState: dataState ?? this.dataState,
      transactionSaving: transactionSaving ?? this.transactionSaving,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      error: error ?? this.error,
    );
  }
}

class CDSConfirmState {
  CDSConfirmState({
    this.dataState = DataState.init,
    this.data,
    this.successMessage,
    this.error,
  });

  final DataState dataState;
  final TransactionManageConfirmResponse? data;
  final String? successMessage;
  final String? error;

  CDSConfirmState copyWith({
    DataState? dataState,
    TransactionManageConfirmResponse? data,
    String? successMessage,
    String? error,
  }) {
    return CDSConfirmState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      successMessage: successMessage ?? this.successMessage,
      error: error ?? this.error,
    );
  }
}

class CDSDebitAccountList {
  CDSDebitAccountList({
    this.dataState = DataState.init,
    this.data,
    this.error,
  });

  final DataState dataState;
  final DebitAccountResponseModel? data;
  final String? error;

  CDSDebitAccountList copyWith({
    DataState? dataState,
    DebitAccountResponseModel? data,
    String? error,
  }) {
    return CDSDebitAccountList(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
