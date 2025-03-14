import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/loan/loan_history/loan_history_events.dart';
import 'package:b2b/scr/bloc/loan/loan_history/loan_history_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/loan_statement_model.dart';
import 'package:b2b/scr/data/repository/loan_repository.dart';
import 'package:bloc/bloc.dart';

class LoanHistoryBloc extends Bloc<LoanHistoryEvents, LoanHistoryState> {
  LoanHistoryBloc(this.repository) : super(const LoanHistoryState());
  LoanRepository repository;

  @override
  Stream<LoanHistoryState> mapEventToState(LoanHistoryEvents event) async* {
    switch (event.runtimeType) {
      case GetLoanHistoryEvent:
        yield* getLoanHistory(event as GetLoanHistoryEvent);
        break;
      case ClearLoanHistoryEvent:
        break;
    }
  }

  Stream<LoanHistoryState> getLoanHistory(GetLoanHistoryEvent event) async* {
    yield state.copyWith(dataState: DataState.preload);
    try {
      final response = await repository.getLoanHistory(event.contractNumber, event.fromDate, event.toDate);
      if (response.result?.isSuccess() == true) {
        List<LoanStatementModel>? list = ListResponse<LoanStatementModel>(
          response.data,
          (itemJson) => LoanStatementModel.fromJson(itemJson),
        ).items;
        yield state.copyWith(
          dataState: DataState.data,
          data: list,
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        dataState: DataState.error,
        errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.errorNoReasonStr.localized,
      );
    }
  }
}
