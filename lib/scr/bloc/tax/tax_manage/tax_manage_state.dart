import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:equatable/equatable.dart';

class TaxManageState extends Equatable {
  final TaxManageInitState? initState;
  final TaxManageConfirmState? confirmState;
  final TaxManageListState? listState;

  const TaxManageState({
    this.initState,
    this.confirmState,
    this.listState,
  });

  TaxManageState copyWith({
    TaxManageInitState? initState,
    TaxManageConfirmState? confirmState,
    TaxManageListState? listState,
  }) {
    return TaxManageState(
      initState: initState ?? this.initState,
      confirmState: confirmState ?? this.confirmState,
      listState: listState ?? this.listState,
    );
  }

  @override
  List<Object?> get props => [
        initState,
        confirmState,
        listState,
      ];
}

class TaxManageListState {
  final DataState? dataState;
  final List<TaxOnline>? list;
  final String? errorMessage;

  TaxManageListState({
    this.dataState,
    this.list,
    this.errorMessage,
  });

  TaxManageListState copyWith({
    DataState? dataState,
    List<TaxOnline>? list,
    String? errorMessage,
  }) {
    return TaxManageListState(
      dataState: dataState ?? this.dataState,
      list: list ?? this.list,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TaxManageInitState {
  final DataState? dataState;
  final TaxOnline? data;
  final String? errorMessage;

  TaxManageInitState({
    this.dataState,
    this.data,
    this.errorMessage,
  });

  TaxManageInitState copyWith({
    DataState? dataState,
    TaxOnline? data,
    String? errorMessage,
  }) {
    return TaxManageInitState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TaxManageConfirmState {
  final DataState? dataState;
  final TransactionManageConfirmResponse? data;
  final CommitActionType? actionType;
  final String? errorMessage;
  final String? rejectReason;
  final String? successMessage;

  TaxManageConfirmState({
    this.dataState,
    this.data,
    this.actionType,
    this.errorMessage,
    this.rejectReason,
    this.successMessage,
  });

  TaxManageConfirmState copyWith({
    DataState? dataState,
    TransactionManageConfirmResponse? data,
    CommitActionType? actionType,
    String? errorMessage,
    String? rejectReason,
    String? successMessage,
  }) {
    return TaxManageConfirmState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      actionType: actionType ?? this.actionType,
      errorMessage: errorMessage ?? this.errorMessage,
      rejectReason: rejectReason ?? this.rejectReason,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
