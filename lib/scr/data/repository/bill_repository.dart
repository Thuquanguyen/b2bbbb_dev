import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/bill/bill_info.dart';
import 'package:b2b/scr/data/model/bill/bill_provider.dart';
import 'package:b2b/scr/data/model/bill/bill_saved.dart';
import 'package:b2b/scr/data/model/bill/init_bill_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction/transaction_init_response.dart';
import 'package:b2b/scr/data/model/transfer/confirm_transfer_model.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';

import '../../core/api_service/api_endpoint.dart';
import '../../core/api_service/api_provider.dart';
import '../../core/api_service/single_response.dart';
import '../model/base_response_model.dart';
import '../model/bill/bill_service.dart';

class BillRepository {
  late ApiProviderRepositoryImpl apiProvider;
  static final BillRepository _singleton = BillRepository._internal();

  factory BillRepository(ApiProviderRepositoryImpl apiProvider) {
    _singleton.apiProvider = apiProvider;
    return _singleton;
  }

  BillRepository._internal();

  Future<BaseResponseModel<SingleResponse>> getListDebitAccount({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_BILL_DEBIT_ACCOUNT.value,
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<BillService>> getBillService({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.getRequest(
        Endpoint.GET_BILL_SERVICE.value,
      );
      return BaseResponseModel<BillService>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<BillProvider>> getBillProvider({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_BILL_PROVIDER.value, data: params);
      return BaseResponseModel<BillProvider>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<BillInfo>> getBillInfo({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_BILL_INFO.value, data: params);
      return BaseResponseModel<BillInfo>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<BillSaved>> getListBillSaved({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.GET_BILL_SAVED.value, data: params);
      return BaseResponseModel<BillSaved>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<InitBillResponse>> initBill({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.BILL_INIT.value, data: params);
      return BaseResponseModel<InitBillResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ConfirmTransferModel>> confirmBill({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(Endpoint.BILL_CONFIRM.value, data: params);
      return BaseResponseModel<ConfirmTransferModel>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<BillTransactionManageInitResponse>> initBillManage({
    required List<String?> transCodeList,
    TransactionFilterRequest? filterRequest,
  }) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(Endpoint.INIT_BILL_MANAGE.value, data: {
        'list_trans_code': transCodeList,
        'fillter': filterRequest != null ? filterRequest.toJson() : TransactionFilterRequest().toJson(),
      });
      return BaseResponseModel<BillTransactionManageInitResponse>.fromJson(responseData.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageConfirmResponse>> confirmBillManage({
    required String transCodes,
    required String secureTrans,
    required CommitActionType actionType,
  }) async {
    try {
      final responseData =
          await apiProvider.postRequest<Map<String, dynamic>>(Endpoint.CONFIRM_BILL_MANAGE.value, data: {
        'trans_code': transCodes,
        'secure_trans': secureTrans,
        'action_type': actionType.value,
      });
      return BaseResponseModel<TransactionManageConfirmResponse>.fromJson(responseData.data ?? {});
    } catch (e) {
      rethrow;
    }
  }
}
