import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/saving_account_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:intl/intl.dart';

class SavingRepository {
  final ApiProviderRepositoryImpl _apiProvider;

  SavingRepository(this._apiProvider);

  Future<BaseResponseModel<ListResponse>> getListSavingAccount(
      TransactionFilterRequest? filterRequest) async {
    try {
      var rawResponse = await _apiProvider
          .postRequest(Endpoint.GET_LIST_SAVING_ACCOUNT.value, data: {
        'from_amount': filterRequest?.fromAmount,
        'to_amount': filterRequest?.toAmount,
        'from_date': filterRequest?.fromDate,
        'to_date': filterRequest?.toDate,
      });

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<DebitAccountResponseModel>> getListDebitAccount({
    String? productId,
    String? secureId,
  }) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_LIST_DEBIT_SAVING_ACCOUNT.value,
        data: {
          'product_id': productId,
          'secure_id': secureId,
          'lang': AppTranslate().currentLanguage == SupportLanguages.En ? 0 : 1,
        },
      );

      return BaseResponseModel<DebitAccountResponseModel>.fromJson(
          rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionSavingModel>> getAzDetail(
    String accountNo,
  ) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.GET_AZ_DETAIL.value,
        data: {
          'account_no': accountNo,
        },
      );

      return BaseResponseModel<TransactionSavingModel>.fromJson(
          rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionSavingModel>> initSettlementRequest(
    String debitAccountNo,
    String nominatedAcc,
  ) async {
    try {
      var rawResponse = await _apiProvider.postRequest(
        Endpoint.CLOSE_AZ_INIT.value,
        data: {
          'account_no': debitAccountNo,
          'nominated_ac': nominatedAcc,
        },
      );

      return BaseResponseModel<TransactionSavingModel>.fromJson(
          rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageConfirmResponse>>
      confirmSettlementRequest(
    String? transCode,
    String? secureTrans,
  ) async {
    try {
      var response = await _apiProvider.postRequest(
        Endpoint.CLOSE_AZ_CONFIRM.value,
        data: {
          'trans_code': transCode ?? '',
          'secure_trans': secureTrans ?? '',
          'transfer_type_code': 5, // Close saving online
        },
      );

      return BaseResponseModel<TransactionManageConfirmResponse>.fromJson(
          response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionSavingModel>> initTransactionManage({
    required String transCode,
  }) async {
    try {
      final responseData = await _apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.TRANSACTION_SAVING_MANAGE_INIT.value,
          data: {
            'trans_code': transCode,
          });
      return BaseResponseModel<TransactionSavingModel>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageConfirmResponse>>
      confirmTransactionManage({
    required String transCode,
    required String secureTrans,
    required CommitActionType actionType,
  }) async {
    try {
      final responseData = await _apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.TRANSACTION_SAVING_MANAGE_CONFIRM.value,
          data: {
            'trans_code': transCode,
            'secure_trans': secureTrans,
            'action_type': actionType.value,
          });
      return BaseResponseModel<TransactionManageConfirmResponse>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      // Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }
}
