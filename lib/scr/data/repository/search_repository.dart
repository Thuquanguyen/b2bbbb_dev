import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchRepository {
  final ApiProviderRepositoryImpl _apiProvider;

  SearchRepository(this._apiProvider);

  Future<BaseResponseModel<ListResponse>> searchBenList(int transferTypeCode) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_BEN_LIST.value,
        data: {
          'transfer_type_code': transferTypeCode,
        },
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> searchLocationList() async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_CITY_LIST.value,
      );
      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> searchBranchList(String bankCode, String cityCode) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_BRANCH_LIST.value,
        data: {'bank_code': bankCode, 'city_code': cityCode},
      );
      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getBenBankList() async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_BEN_BANKS.value,
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
