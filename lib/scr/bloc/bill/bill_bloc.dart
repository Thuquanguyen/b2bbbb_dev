import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/bill/bill_provider.dart';
import 'package:b2b/scr/data/model/bill/bill_saved.dart';
import 'package:b2b/scr/data/model/bill/bill_service.dart';
import 'package:equatable/equatable.dart';
import 'package:b2b/scr/data/repository/bill_repository.dart';
import 'package:bloc/bloc.dart';

import '../../core/language/app_translate.dart';

part 'bill_event.dart';

part 'bill_state.dart';

enum BillType { DIEN }

extension BillTypeExt on BillType {
  String getServiceCode() {
    switch (this) {
      case BillType.DIEN:
        return 'DIEN';
      default:
        return '';
    }
  }
}

class BillBloc extends Bloc<BillEvent, BillState> {
  BillRepository repository;

  BillBloc(this.repository) : super(BillState()) {
    on<GetBillServiceEvent>(getBillService);
    on<GetBillProviderEvent>(getBillProvider);
    on<GetListBillSavedEvent>(getListBillSaved);
    on<BillProviderInitEvent>(getBillProviderInitEvent);
  }

  void getBillService(GetBillServiceEvent event, Emitter emit) async {
    emit(state.copyWith(getBillServiceDataState: DataState.preload));
    try {
      var response = await repository.getBillService();
      if (response.result?.isSuccess() == true) {
        var listService = response.toArrayModel(
          (json) => BillService.fromJson(json),
        );
        emit(
          state.copyWith(
              getBillServiceDataState: DataState.data,
              listBillService: listService),
        );
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      emit(
        state.copyWith(
          getBillServiceDataState: DataState.error,
          errMsg: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized,
        ),
      );
    }
  }

  void getBillProvider(GetBillProviderEvent event, Emitter emit) async {
    emit(state.copyWith(getBillProviderDataState: DataState.preload));
    try {
      var response = await repository
          .getBillProvider(params: {'service_code': event.code});
      if (response.result?.isSuccess() == true) {
        var listProvider = response.toArrayModel(
          (json) => BillProvider.fromJson(json),
        );
        emit(
          state.copyWith(
              getBillProviderDataState: DataState.data,
              listBillProvider: listProvider),
        );
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      emit(
        state.copyWith(
          getBillProviderDataState: DataState.error,
          getBillProviderErrMsg: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized,
        ),
      );
    }
  }

  void getListBillSaved(GetListBillSavedEvent event, Emitter emit) async {
    emit(state.copyWith(getListBillSavedDataState: DataState.preload));
    try {
      var response = await repository
          .getListBillSaved(params: {'service_code': event.providerCode});
      if (response.result?.isSuccess() == true) {
        var listSaved = response.toArrayModel(
          (json) => BillSaved.fromJson(json),
        );
        emit(
          state.copyWith(
              getListBillSavedDataState: DataState.data,
              listBillSaved: listSaved),
        );
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      emit(
        state.copyWith(
          getListBillSavedDataState: DataState.error,
          getListBillSavedErrMsg: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized,
        ),
      );
    }
  }

  void getBillProviderInitEvent(
      BillProviderInitEvent event, Emitter emit) async {
    add(GetBillProviderEvent(event.serviceCode));
    add(GetListBillSavedEvent(event.serviceCode));
  }
}
