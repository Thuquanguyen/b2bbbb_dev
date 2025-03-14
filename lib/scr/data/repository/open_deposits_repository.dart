import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/open_saving/init_deposits_result.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term_rate.dart';
import 'package:b2b/scr/data/model/open_saving/saving_deposits_product_response.dart';
import 'package:b2b/scr/data/model/open_saving/settelment.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:dio/dio.dart';

class OpenDepositsRepository {
  OpenDepositsRepository._internal();

  static final OpenDepositsRepository _singleton =
      OpenDepositsRepository._internal();

  factory OpenDepositsRepository(ApiProviderRepositoryImpl apiProvider) {
    _singleton.apiProvider = apiProvider;
    return _singleton;
  }

  late ApiProviderRepositoryImpl apiProvider;

  Future<BaseResponseModel<SingleResponse>> getListDebitAccount(
      Map<String, dynamic> params) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        '/SavingOnline/GetListDebitAccount',
        data: params,
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<SavingDepositsProductResponse>>>
      getSavingDepositsProductType(Map<String, dynamic> params) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.GET_SAVING_DEPOSITS_PRODCUT.value,
        data: params,
      );
      return SingleResponse<BaseResponseModel<SavingDepositsProductResponse>>(
        responseData.data ?? {},
        (dynamic item) => BaseResponseModel.fromJson(item),
      );
    } catch (e) {
      Logger.debug('getSavingDepositsProductType: catch response error $e');
      rethrow;
    }
  }

  // getRolloverTermList -> ds ky hạn tiền gửi
  Future<SingleResponse<BaseResponseModel<RolloverTerm>>> getRolloverTermList(
      Map<String, dynamic> params) async {
    try {
      final responseData = await apiProvider
          .postRequest('/SavingOnline/GetRolloverTermList', data: params);
      return SingleResponse<BaseResponseModel<RolloverTerm>>(
        responseData.data ?? {},
        (dynamic item) => BaseResponseModel.fromJson(item),
      );
    } catch (e) {
      Logger.debug('getRolloverTermList: catch response error $e');
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<RolloverTermRate>>> getTermRate(
      Map<String, dynamic> params) async {
    try {
      final responseData = await apiProvider
          .postRequest('/SavingOnline/GetTermRate', data: params);
      return SingleResponse<BaseResponseModel<RolloverTermRate>>(
        responseData.data ?? {},
        (dynamic item) => BaseResponseModel.fromJson(item),
      );
    } catch (e) {
      Logger.debug('getTermRate: catch response error $e');
      rethrow;
    }
  }

  //Phương thức nhận lãi
  Future<SingleResponse<BaseResponseModel<Settelment>>> getSettelment(
      Map<String, dynamic> params) async {
    try {
      final responseData = await apiProvider
          .postRequest('/SavingOnline/GetSettelment', data: params);
      return SingleResponse<BaseResponseModel<Settelment>>(
        responseData.data ?? {},
        (dynamic item) => BaseResponseModel.fromJson(item),
      );
    } catch (e) {
      Logger.debug('getSettelment: catch response error $e');
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<InitDepositsResult>>> initDeposits(
      Map<String, dynamic> params) async {
    try {
      final responseData = await apiProvider
          .postRequest('/SavingOnline/OpenAzInit', data: params);
      return SingleResponse<BaseResponseModel<InitDepositsResult>>(
        responseData.data ?? {},
        (dynamic item) => BaseResponseModel.fromJson(item),
      );
    } catch (e) {
      Logger.debug('initDeposits: catch response error $e');
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<TransactionManageConfirmResponse>>>
      confirmOpenDeposits(Map<String, dynamic> params) async {
    try {
      final responseData =
          await apiProvider.postRequest('/SavingOnline/Confirm', data: params);
      return SingleResponse<
          BaseResponseModel<TransactionManageConfirmResponse>>(
        responseData.data ?? {},
        (dynamic item) => BaseResponseModel.fromJson(item),
      );
    } catch (e) {
      Logger.debug('confirmOpenDeposits: catch response error $e');
      rethrow;
    }
  }
}
