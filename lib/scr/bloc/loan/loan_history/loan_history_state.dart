import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/loan_statement_model.dart';
import 'package:equatable/equatable.dart';

class LoanHistoryState extends Equatable {
  final DataState? dataState;
  final String? errorMessage;
  final List<LoanStatementModel>? data;

  const LoanHistoryState({
    this.dataState,
    this.errorMessage,
    this.data,
  });

  LoanHistoryState copyWith({
    DataState? dataState,
    String? errorMessage,
    List<LoanStatementModel>? data,
  }) {
    return LoanHistoryState(
      dataState: dataState ?? this.dataState,
      errorMessage: errorMessage,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        errorMessage,
        data,
      ];
}
