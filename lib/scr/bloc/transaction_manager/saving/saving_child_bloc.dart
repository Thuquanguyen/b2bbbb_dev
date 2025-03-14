import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc_child.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/utilities/transaction/transaction_helper.dart';

class SavingChildBloc implements TransuctionManageChildBloc {
  @override
  Stream<TransuctionManageState> loadList(
      TransuctionManageBloc bloc,
      ) async* {
    try {
      var response = await bloc.transManangerRepository.getTransactionList(
          bloc.state.currentFilterRequest,
          TransactionManage.savingCat);

      if (response.result!.isSuccess()) {
        final ListResponse<TransactionSavingModel> listTransaction =
        ListResponse<TransactionSavingModel>(
          response.data,
              (item) => TransactionSavingModel.fromJson(item),
        );
        List<TransactionSavingModel> result = listTransaction.items;

        yield bloc.state.copyWith(
          listState: TransuctionManageListState<TransactionSavingModel>(
            dataState: DataState.data,
            transactions: TransactionHelper.groupByDate(result),
          ),
        );
      } else {
        yield bloc.state.copyWith(
          listState: TransuctionManageListState<TransactionSavingModel>(
            dataState: DataState.error,
            errorMessage: response.result?.getMessage(
                defaultValue: AppTranslate.i18n.errorNoReasonStr.localized),
          ),
        );
      }
    } catch (e) {
      yield bloc.state.copyWith(
        listState: TransuctionManageListState<TransactionSavingModel>(
          dataState: DataState.error,
          errorMessage: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }

  @override
  Stream<TransuctionManageState> loadServiceList(
      TransuctionManageBloc bloc) async* {
    var response = await bloc.transManangerRepository.getTransactionServiceType(
        transCatKey: TransactionManage.savingCat.key);

    if (response.result!.isSuccess()) {
      final ListResponse<NameModel> serviceType = ListResponse<NameModel>(
        response.data,
            (item) => NameModel.fromJson(item),
      );

      serviceType.items.insert(
        0,
        NameModel(key: '', valueVi: 'Tất cả', valueEn: 'All'),
      );

      yield bloc.state.copyWith(
        filterServiceTypes: serviceType.items,
      );
    } else {
      throw response.result as Object;
    }
  }
}
