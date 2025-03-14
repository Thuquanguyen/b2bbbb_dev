import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/loan_statement_model.dart';
import 'package:b2b/scr/data/model/loan/loan_detail_info.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';

import '../../bloc/transfer/transfer_bloc.dart';
import '../model/tax/tax_online.dart';
import '../model/transfer/debit_account_model.dart';
import '../model/transfer/init_transfer_model.dart';

class TaxRepository {
  TaxRepository._internal();

  static final TaxRepository _singleton = TaxRepository._internal();

  factory TaxRepository(ApiProviderRepositoryImpl apiProvider) {
    _singleton.apiProvider = apiProvider;
    return _singleton;
  }

  late ApiProviderRepositoryImpl apiProvider;

  Future<BaseResponseModel<TaxOnline>> getTaxOnline({Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.getRequest(
        Endpoint.GET_TAX_ONLINE.value,
      );
      return BaseResponseModel<TaxOnline>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> getListDebitAccount(
    int transferTypeCode,
  ) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_LIST_DEBIT_ACCOUNT.value,
        data: {
          'transfer_type_code': transferTypeCode,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<SingleResponse>> initPayment({
    DebitAccountModel? debitAccountModel,
    DebitAccountModel? feeAccount,
  }) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.TRANSFER_INIT.value,
        data: {
          "debbit_info": debitAccountModel?.toJSONPARAM(),
          "charge_account": feeAccount?.toJSONPARAM(),
          "transfer_type_code": TransferType.TAX.getTransferTypeCode,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<SingleResponse>> confirmPayment(
      InitTransferModel initTransferModel,
      int transferTypeCode,
      ) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.TRANSFER_CONFIRM.value,
        data: {
          "trans_code": initTransferModel.transcode,
          "secure_trans": initTransferModel.sercureTrans,
          "transfer_type_code": transferTypeCode,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TaxOnline>> getTaxOnlineList() async {
    try {
      var rawResponse = await apiProvider.getRequest(
        Endpoint.GET_TAX_ONLINE_LIST.value,
      );
      return BaseResponseModel<TaxOnline>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TaxOnline>> initTaxOnlineManage({String? transCode}) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.MANAGE_TAX_ONLINE_INIT.value,
        data: {
          'trans_code': transCode,
        },
      );
      return BaseResponseModel<TaxOnline>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<TransactionManageConfirmResponse>> confirmTaxOnlineManage({
    String? transCode,
    String? secureTrans,
    CommitActionType? commitType,
  }) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.MANAGE_TAX_ONLINE_CONFIRM.value,
        data: {
          'trans_code': transCode,
          'secure_trans': secureTrans,
          'action_type': commitType?.value,
        },
      );
      return BaseResponseModel<TransactionManageConfirmResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
