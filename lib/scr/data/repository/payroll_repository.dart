import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/payroll_ben_model.dart';
import 'package:b2b/scr/data/model/transaction/payroll_manage_init_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';

class PayrollRepository {
  final ApiProviderRepositoryImpl _apiProvider;

  PayrollRepository(this._apiProvider);

  Future<BaseResponseModel<ListResponse>> getList(
      TransactionFilterRequest? filterRequest) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_PAYROLL_LIST_WAIT_APPROVE.value,
        data: filterRequest?.toJson() ?? TransactionFilterRequest().toJson(),
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<PayrollManageInitResponse>> initManage(
      String? fileCode,String? transCode) async {
    try {
      var rawResponse = await _apiProvider
          .postRequest(Endpoint.TRANSACTION_PAYROLL_MANAGE_INIT.value, data: {
        'file_code': fileCode,
        'trans_code': transCode,
      });

      return BaseResponseModel<PayrollManageInitResponse>.fromJson(
          rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageConfirmResponse>> confirmManage({
    required String transCode,
    required String secureTrans,
    required CommitActionType actionType,
  }) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
          Endpoint.TRANSACTION_PAYROLL_MANAGE_CONFIRM.value,
          data: {
            'trans_code': transCode,
            'secure_trans': secureTrans,
            'action_type': actionType.value,
          });

      return BaseResponseModel<TransactionManageConfirmResponse>.fromJson(
          rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getBenList(
      PayrollBenListFilterRequest? filterRequest) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.TRANSACTION_PAYROLL_MANAGE_GET_BEN_LIST.value,
        data: {
          'file_code': filterRequest?.fileCode,
          'fillter': filterRequest?.fillter?.toJson(),
        },
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
