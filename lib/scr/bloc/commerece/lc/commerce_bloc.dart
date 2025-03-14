import 'dart:async';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/loan/loan_list/loan_list_bloc.dart';
import 'package:b2b/scr/data/model/commerce/Neogotiating_model.dart';
import 'package:b2b/scr/data/model/commerce/commerce_filter_request.dart';
import 'package:b2b/scr/data/model/commerce/dr_contract_model.dart';
import 'package:b2b/scr/data/model/commerce/guaratee_model.dart';
import 'package:b2b/scr/data/model/commerce/lc_model.dart';
import 'package:b2b/scr/data/repository/commerce_repository.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/api_service/list_response.dart';
import '../../../core/language/app_translate.dart';
import '../../../data/model/base_result_model.dart';

part 'commerce_event.dart';

part 'commerce_state.dart';

class CommerceBloc extends Bloc<CommerceEvent, CommerceState> {
  CommerceRepository repository;

  CommerceBloc(this.repository)
      : super(
          CommerceState(
            contractListState: CommerceContractListState(),
          ),
        );

  @override
  Stream<CommerceState> mapEventToState(CommerceEvent event) async* {
    switch (event.runtimeType) {
      case CommerceChangeFilterStatusEvent:
        yield* _mapToLcChangeFilterStatusEvent();
        break;
      case CommerceUpdateFilterRequestEvent:
        yield state.copyWith(filterRequest: (event as CommerceUpdateFilterRequestEvent).filterRequest);
        break;
      case CommerceGetDataList:
        CommerceType type = (event as CommerceGetDataList).type!;
        CommerceFilterRequest? filterRequest = event.filterRequest;
        if (type == CommerceType.LC) {
          yield* _mapToCommerceGetLcList(filterRequest: filterRequest);
        } else if (type == CommerceType.BAO_LANH) {
          yield* _mapToCommerceGetGuaranteeList(filterRequest: filterRequest);
        } else if (type == CommerceType.DISCOUNT) {
          yield* _mapToCommerceGetDiscountList(filterRequest: filterRequest);
        }
        break;
      case CommerceGetContractListEvent:
        yield* _mapToCommerceGetContractList(event as CommerceGetContractListEvent);
        break;
      case ClearCommerceEvent:
        yield CommerceState(
          contractListState: CommerceContractListState(),
        );
        break;
      default:
        break;
    }
  }

  Stream<CommerceState> _mapToLcChangeFilterStatusEvent({CommerceFilterRequest? filterRequest}) async* {
    yield state.copyWith(isFiltering: !(state.isFiltering ?? false));
  }

  Stream<CommerceState> _mapToCommerceGetContractList(CommerceGetContractListEvent? event) async* {
    yield state.copyWith(
      contractListState: state.contractListState?.copyWith(
        dataState: DataState.preload,
      ),
    );

    try {
      var response = await repository.getContractList(refNum: event?.refNumber);
      if (response.result?.isSuccess() == true) {
        yield state.copyWith(
          contractListState: state.contractListState?.copyWith(
            dataState: DataState.data,
            list: response.toArrayModel((json) => DRContractModel.fromJson(json)),
          ),
        );
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        contractListState: state.contractListState?.copyWith(
          dataState: DataState.error,
          errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized,
        ),
      );
    }
  }

  Stream<CommerceState> _mapToCommerceGetLcList({CommerceFilterRequest? filterRequest}) async* {
    yield state.copyWith(
      dataState: DataState.preload,
      filterRequest: filterRequest,
      isFiltering: false,
    );
    try {
      var response = await repository.getLcList(request: filterRequest);
      if (response.result?.isSuccess() == true) {
        final ListResponse<LcModel> listData = ListResponse<LcModel>(
          response.data,
          (item) => LcModel.fromJson(item),
        );
        yield state.copyWith(dataState: DataState.data, dataList: listData.items);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        dataState: DataState.error,
        errMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<CommerceState> _mapToCommerceGetGuaranteeList({CommerceFilterRequest? filterRequest}) async* {
    yield state.copyWith(
      dataState: DataState.preload,
      filterRequest: filterRequest,
      isFiltering: false,
    );
    try {
      var response = await repository.getGuaranteeList(request: filterRequest);
      if (response.result?.isSuccess() == true) {
        final ListResponse<GuaranteeModel> listData = ListResponse<GuaranteeModel>(
          response.data,
          (item) => GuaranteeModel.fromJson(item),
        );
        yield state.copyWith(dataState: DataState.data, dataList: listData.items);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        dataState: DataState.error,
        errMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<CommerceState> _mapToCommerceGetDiscountList({CommerceFilterRequest? filterRequest}) async* {
    yield state.copyWith(
      dataState: DataState.preload,
      filterRequest: filterRequest,
      isFiltering: false,
    );
    try {
      var response = await repository.getNegotiatingList(request: filterRequest);
      if (response.result?.isSuccess() == true) {
        final ListResponse<NegotiatingModel> listData = ListResponse<NegotiatingModel>(
          response.data,
          (item) => NegotiatingModel.fromJson(item),
        );
        yield state.copyWith(dataState: DataState.data, dataList: listData.items);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        dataState: DataState.error,
        errMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }
}
