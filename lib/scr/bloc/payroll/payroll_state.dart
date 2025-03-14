import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/payroll_ben_model.dart';
import 'package:equatable/equatable.dart';

class PayrollState extends Equatable {
  final PayrollBenListState? benListState;

  const PayrollState({
    this.benListState,
  });

  PayrollState copyWith({
    PayrollBenListState? benListState,
  }) {
    return PayrollState(
      benListState: benListState ?? this.benListState,
    );
  }

  @override
  List<Object?> get props => [
        benListState,
      ];
}

class PayrollBenListState {
  final DataState? dataState;
  final PayrollBenListFilterRequest? filterRequest;
  final List<PayrollBenModel>? list;
  final String? errorMessage;

  const PayrollBenListState({
    this.dataState,
    this.filterRequest,
    this.list,
    this.errorMessage,
  });

  PayrollBenListState copyWith({
    DataState? dataState,
    PayrollBenListFilterRequest? filterRequest,
    List<PayrollBenModel>? list,
    String? errorMessage,
  }) {
    return PayrollBenListState(
      dataState: dataState ?? this.dataState,
      filterRequest: filterRequest ?? this.filterRequest,
      list: list ?? this.list,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
