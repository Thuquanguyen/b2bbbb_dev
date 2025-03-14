import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/search/branch_model.dart';
import 'package:b2b/scr/data/model/search/city_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction/transaction_init_response.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/transaction_filter/transaction_filter.dart';
import 'package:b2b/utilities/logger.dart';

class TransactionManagerRepository {
  late ApiProviderRepositoryImpl apiProvider;

  static final TransactionManagerRepository _singleton =
      TransactionManagerRepository._();

  factory TransactionManagerRepository(
      ApiProviderRepositoryImpl apiProviderRepositoryImpl) {
    _singleton.apiProvider = apiProviderRepositoryImpl;
    return _singleton;
  }

  TransactionManagerRepository._();

  Future<BaseResponseModel<ListResponse>> getTransactionServiceType(
      {String? transCatKey}) async {
    try {
      String endpoint = Endpoint.GET_TRANSACTION_SERVICE_TYPE.value;
      if (transCatKey == TransactionManage.savingCat.key) {
        endpoint = Endpoint.GET_TRANSACTION_SAVING_SERVICE_TYPE.value;
      } else if (transCatKey == TransactionManage.fxCat.key) {
        endpoint = Endpoint.GET_TRANSACTION_FX_SERVICE_TYPE.value;
      }

      var rawResponse = await apiProvider.getRequest(
        endpoint,
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getTransactionList(
      TransactionFilterRequest? filterRequest,
      TransactionFilterCategory? transCat) async {
    try {
      String endpoint = Endpoint.GET_TRANSACTION_LIST_WAIT_APPROVE.value;

      if (transCat?.key == TransactionManage.transferCat.key) {
        endpoint = Endpoint.GET_TRANSACTION_LIST_WAIT_APPROVE.value;
      } else if (transCat?.key == TransactionManage.savingCat.key) {
        endpoint = Endpoint.GET_TRANSACTION_SAVING_LIST_WAIT_APPROVE.value;
      } else if (transCat?.key == TransactionManage.fxCat.key) {
        endpoint = Endpoint.GET_TRANSACTION_FX_LIST_WAIT_APPROVE.value;
      } else if (transCat?.key == TransactionManage.billCat.key) {
        endpoint = Endpoint.GET_BILL_WAITING_APPROVAL.value;
      }

      var rawResponse = await apiProvider.postRequest(
        endpoint,
        data: filterRequest?.toJson() ?? TransactionFilterRequest().toJson(),
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageInitResponse>>
      initTransactionManage({
    required List<String?> transCodeList,
    TransactionFilterRequest? filterRequest,
    bool isFx = false,
  }) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          isFx
              ? Endpoint.TRANSACTION_FX_MANAGE_INIT.value
              : Endpoint.TRANSACTION_MANAGE_INIT.value,
          data: {
            'list_trans_code': transCodeList,
            'fillter': filterRequest != null
                ? filterRequest.toJson()
                : TransactionFilterRequest().toJson(),
          });
      return BaseResponseModel<TransactionManageInitResponse>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageConfirmResponse>>
      confirmTransactionManage({
    required String transCode,
    required String secureTrans,
    required CommitActionType actionType,
    bool isFx = false,
  }) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          isFx
              ? Endpoint.TRANSACTION_FX_MANAGE_CONFIRM.value
              : Endpoint.TRANSACTION_MANAGE_CONFIRM.value,
          data: {
            'trans_code': transCode,
            'secure_trans': secureTrans,
            'action_type': actionType.value,
          });
      return BaseResponseModel<TransactionManageConfirmResponse>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }

  Future<BaseResponseModel<AccountInfo>> getDebitAccountDetail(
      String accountNumber) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.GET_DEBIT_ACCOUNT_DETAIL.value,
          data: {
            'debit_account': accountNumber,
          });
      return BaseResponseModel<AccountInfo>.fromJson(responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse<CityModel>>> getCityList() async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.GET_CITY_LIST.value,
      );
      return BaseResponseModel<ListResponse<CityModel>>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse<BranchModel>>> getBranchList(
    String bankCode,
    String cityCode,
  ) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.GET_BRANCH_LIST.value,
          data: {
            'bank_code': bankCode,
            'city_code': cityCode,
          });
      return BaseResponseModel<ListResponse<BranchModel>>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }
}
