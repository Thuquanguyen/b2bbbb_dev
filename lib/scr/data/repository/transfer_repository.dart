import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_request_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/amount_info.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/data/model/transfer/transfer_rate.dart';

abstract class TransferRepository {
  Future<BaseResponseModel<SingleResponse>> getListDebitAccount(
    int transferTypeCode,
  );

  Future<BaseResponseModel<SingleResponse>> getDebitAccountDetail(
    String debitAccount,
    String benAccount,
    String benCcy,
    int transferTypeCode,
  );

  Future<BaseResponseModel<SingleResponse>> getBenAccountDetail(
    String benAccount,
    int transferTypeCode,
  );

  Future<BaseResponseModel<SingleResponse>> confirmTransfer(
    InitTransferModel initTransferModel,
    int transferTypeCode,
  );

  Future<BaseResponseModel<SingleResponse>> initTransfer({
    required DebitAccountModel debbitAccount,
    DebitAccountModel? chargeAccount,
    required BeneficianAccountModel benAccount,
    required AmountInfo amountInfo,
    required bool addBen,
    String? outBenFee,
    String? benAlias,
    required int transferTypeCode,
    required String memo,
  });

  Future<BaseResponseModel<ListResponse>> getBenBankList();
}

class TransferRepositoryImpl extends TransferRepository {
  TransferRepositoryImpl({required this.apiProvider});

  final ApiProviderRepositoryImpl apiProvider;

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

  @override
  Future<BaseResponseModel<SingleResponse>> getDebitAccountDetail(
    String debitAccount,
    String benAccount,
    String benCcy,
    int transferTypeCode,
  ) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_DEBIT_ACCOUNT_DETAIL.value,
        data: {
          'transfer_type_code': transferTypeCode,
          "debit_account": debitAccount,
          "ben_account": benAccount,
          "ben_ccy": benCcy,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> getBenAccountDetail(
      String benAccount, int transferTypeCode,
      {String? benBank}) async {
    Map<String, dynamic> params = {};
    params['ben_account'] = benAccount;
    params['transfer_type_code'] = transferTypeCode;
    if (benBank != null && benBank.isNotEmpty) {
      params['ben_bank'] = benBank;
    }

    try {
      var rawResponse = await apiProvider
          .postRequest(Endpoint.GET_BEN_ACCOUNT_DETAIL.value, data: params);
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> initTransfer({
    required DebitAccountModel debbitAccount,
    DebitAccountModel? chargeAccount,
    required BeneficianAccountModel benAccount,
    required AmountInfo amountInfo,
    required bool addBen,
    String? outBenFee,
    String? benAlias,
    String? city,
    String? cityName,
    String? branch,
    String? branchName,
    String? accountName,
    String? accountNumber,
    required String memo,
    required int transferTypeCode,
    String? bankCode, //bankNapasId
    String? benCcy,
  }) async {
    try {
      final benAccountRequest =
          BeneficianAccountRequestModel.fromAccountBeneficianModel(
              benAccount, addBen, benAlias,
              bankCode: bankCode,
              city: city,
              branch: branch,
              accountName: accountName,
              accountNumber: accountNumber,
              cityName: cityName,
              branchName: branchName,
              benCcy: benCcy);
      var rawResponse = await apiProvider.postRequest(
        Endpoint.TRANSFER_INIT.value,
        data: {
          "debbit_info": debbitAccount.toJSONPARAM(),
          "charge_account": chargeAccount?.toJSONPARAM(),
          "ben_info": benAccountRequest.toJSON(),
          "memo": memo,
          "amount_info": amountInfo.toJSON(),
          "out_ben_fee": outBenFee,
          "transfer_type_code": transferTypeCode,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> confirmTransfer(
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

  @override
  Future<BaseResponseModel<ListResponse>> getBenBankList() async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_BEN_BANKS.value,
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> searchBenList(
      int transferTypeCode) async {
    try {
      var rawResponse = await apiProvider.postRequest(
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

  Future<BaseResponseModel<ListResponse>> searchBranchList(
      String bankCode, String cityCode) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_BRANCH_LIST.value,
        data: {'bank_code': bankCode, 'city_code': cityCode},
      );
      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<TransferRate>> getTransferRate(
      {String? fcy,
      double? amount,
      int? transferTypeCode,
      required amountCcy}) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_TRANSFER_RATE.value,
        data: {
          'fcy': fcy,
          'amount': amount,
          'transfer_type_code': transferTypeCode,
          'amount_currency': amountCcy
        },
      );
      return BaseResponseModel<TransferRate>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
