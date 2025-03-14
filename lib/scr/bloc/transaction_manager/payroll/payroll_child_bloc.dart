import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc_child.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/transaction_payroll_model.dart';
import 'package:b2b/utilities/transaction/transaction_helper.dart';

class PayrollChildBloc implements TransuctionManageChildBloc {
  @override
  Stream<TransuctionManageState> loadList(
    TransuctionManageBloc bloc,
  ) async* {
    try {
      var response = await bloc.payrollRepo.getList(
        bloc.state.currentFilterRequest,
      );

      if (response.result?.isSuccess() == true) {
        final ListResponse<TransactionPayrollModel> listTransaction =
            ListResponse<TransactionPayrollModel>(
          response.data,
          (item) => TransactionPayrollModel.fromJson(item),
        );
        List<TransactionPayrollModel> result = listTransaction.items;

        yield bloc.state.copyWith(
          listState: TransuctionManageListState<TransactionPayrollModel>(
            dataState: DataState.data,
            transactions: TransactionHelper.groupByDate(result),
          ),
        );
      } else {
        yield bloc.state.copyWith(
          listState: TransuctionManageListState<TransactionPayrollModel>(
            dataState: DataState.error,
            errorMessage: response.result?.getMessage(
                defaultValue: AppTranslate.i18n.errorNoReasonStr.localized),
          ),
        );
      }
    } catch (e) {
      yield bloc.state.copyWith(
        listState: TransuctionManageListState<TransactionPayrollModel>(
          dataState: DataState.error,
          errorMessage: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }

  @override
  Stream<TransuctionManageState> loadServiceList(
      TransuctionManageBloc bloc) async* {
    yield bloc.state.copyWith(
      filterServiceTypes: [],
    );
  }

  Stream<TransuctionManageState> loadBenList(
    String? keyword,
    String? fileCode,
    int? filterType,
  ) async* {}
}
