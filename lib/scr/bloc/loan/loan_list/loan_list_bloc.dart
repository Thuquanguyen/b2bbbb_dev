import 'dart:async';

import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/loan/loan_detail_info.dart';
import 'package:b2b/scr/data/repository/loan_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../../utilities/vp_file_helper.dart';
import '../../../core/api_service/list_response.dart';
import '../../../core/language/app_translate.dart';
import '../../../data/model/base_result_model.dart';
import '../../../data/model/loan/loan_list_model.dart';

part 'loan_list_event.dart';

part 'loan_list_state.dart';

class LoanListBloc extends Bloc<LoanListEvent, LoanListState> {
  LoanRepository repository;

  LoanListBloc(this.repository)
      : super(
          LoanListState(
            loanDetailState: LoanDetailState(),
          ),
        );

  @override
  Stream<LoanListState> mapEventToState(LoanListEvent event) async* {
    switch (event.runtimeType) {
      case GetLoanListEvent:
        yield* _mapToGetLoanListEvent();
        break;
      case GetLoanDetailEvent:
        yield* _mapToGetLoanDetailEvent(event as GetLoanDetailEvent);
        break;
      case ExportLoan:
        yield* _mapToExportLoanEvent(event as ExportLoan);
        break;
      default:
        break;
    }
  }

  Stream<LoanListState> _mapToGetLoanListEvent() async* {
    yield state.copyWith(
      getLoanListDataState: DataState.preload,
    );
    try {
      final response = await repository.getLoanList();
      if (response.result!.isSuccess()) {
        final ListResponse<LoanListModel> loanLists =
            ListResponse<LoanListModel>(
          response.data,
          (item) => LoanListModel.fromJson(item),
        );
        yield state.copyWith(
          getLoanListDataState: DataState.data,
          loanLists: loanLists.items,
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        getLoanListDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<LoanListState> _mapToGetLoanDetailEvent(
      GetLoanDetailEvent event) async* {
    yield state.copyWith(
      loanDetailState:
          state.loanDetailState?.copyWith(loanInfoDataState: DataState.preload),
    );
    try {
      final response = await repository
          .getLoanDetail(params: {'contract_number': event.contractId});
      if (response.result!.isSuccess()) {
        final SingleResponse<LoanDetailInfo> loanDetail =
            SingleResponse<LoanDetailInfo>(
          response.data,
          (item) => LoanDetailInfo.fromJson(item),
        );
        yield state.copyWith(
          loanDetailState: state.loanDetailState?.copyWith(
              loanInfoDataState: DataState.data,
              loanDetailInfo: loanDetail.item),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        loanDetailState: state.loanDetailState?.copyWith(
          loanInfoDataState: DataState.error,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized,
        ),
      );
    }
  }

  Stream<LoanListState> _mapToExportLoanEvent(ExportLoan event) async* {
    yield state.copyWith(
      loanDetailState: state.loanDetailState
          ?.copyWith(exportLoanDataState: DataState.preload),
    );
    try {
      final response = await repository
          .exportLoan(params: {'file_type': event.fileType.getFileTypeId()});
      if (response.result!.isSuccess()) {
        yield state.copyWith(
          loanDetailState: state.loanDetailState?.copyWith(
              exportLoanDataState: DataState.data,
              exportLoanData: (response.data) as String?),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        loanDetailState: state.loanDetailState?.copyWith(
          exportLoanDataState: DataState.error,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized,
        ),
      );
    }
  }
}
