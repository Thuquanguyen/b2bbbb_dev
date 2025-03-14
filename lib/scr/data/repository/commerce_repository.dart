import 'package:b2b/scr/data/model/commerce/commerce_filter_request.dart';
import 'package:b2b/scr/data/model/commerce/dr_contract_model.dart';

import '../../core/api_service/api_endpoint.dart';
import '../../core/api_service/api_provider.dart';
import '../../core/api_service/list_response.dart';
import '../model/base_response_model.dart';

class CommerceRepository {
  static final CommerceRepository _singleton = CommerceRepository._internal();

  factory CommerceRepository(ApiProviderRepositoryImpl apiProvider) {
    _singleton.apiProvider = apiProvider;
    return _singleton;
  }

  late ApiProviderRepositoryImpl apiProvider;

  CommerceRepository._internal();

  Future<BaseResponseModel<ListResponse>> getLcList({CommerceFilterRequest? request}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_LC.value, data: request?.toJson());

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<DRContractModel>> getContractList({String? refNum}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_LC_CONTRACT_LIST.value, data: {
        'ref_num': refNum,
      });

      return BaseResponseModel<DRContractModel>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getGuaranteeList({CommerceFilterRequest? request}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_GAURANTEE.value, data: request?.toJson());

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getNegotiatingList({CommerceFilterRequest? request}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_NEGOTING.value, data: request?.toJson());

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
