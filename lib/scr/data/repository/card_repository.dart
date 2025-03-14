import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/card/card_constract_list_response.dart';
import 'package:b2b/scr/data/model/card/card_contract_info.dart';
import 'package:b2b/scr/data/model/card/card_history_request.dart';
import 'package:b2b/scr/data/model/card/card_list_response.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/card/card_statement_request.dart';
import 'package:b2b/scr/data/model/card/export_card_statement_response.dart';
import 'package:b2b/scr/data/model/transfer/amount_info.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:dio/dio.dart';

class CardRepository {
  CardRepository._internal();

  static final CardRepository _singleton = CardRepository._internal();

  factory CardRepository(ApiProviderRepositoryImpl apiProvider) {
    _singleton.apiProvider = apiProvider;
    return _singleton;
  }

  late ApiProviderRepositoryImpl apiProvider;

  Future<BaseResponseModel<SingleResponse>> getListDebitAccount(
      {Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_LIST_DEBIT_ACCOUNT.value,
        data: {
          'transfer_type_code': TransferType.CARD.getTransferTypeCode,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<CardListResponse>>>
      getCardList() async {
    try {
      String endPoint = Endpoint.GET_CARD_LIST.value;
      // final responseData = await apiProvider.getRequest(path)<Map<String, dynamic>>(
      //   endPoint,
      //   queryParameters: null,
      // );
      final responseData = await apiProvider.getRequest(endPoint);
      return SingleResponse<BaseResponseModel<CardListResponse>>(
          responseData.data ?? {},
          (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug('getCardList error $e');
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<CardContractListResponse>>>
      getCardContractList() async {
    try {
      String endPoint = Endpoint.GET_CARD_CONTRACT_LIST.value;
      final responseData = await apiProvider.getRequest(endPoint);
      return SingleResponse<BaseResponseModel<CardContractListResponse>>(
          responseData.data ?? {},
          (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug('getCardList error $e');
      rethrow;
    }
  }

  Future<BaseResponseModel<SingleResponse>> initPayment({
    DebitAccountModel? debitAccountModel,
    String? cardId,
    AmountInfo? amountInfo,
  }) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.TRANSFER_INIT.value,
        data: {
          "debbit_info": debitAccountModel?.toJSONPARAM(),
          "amount_info": amountInfo?.toJSON(),
          "transfer_type_code": TransferType.CARD.getTransferTypeCode,
          'card_contract_id': cardId
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

  Future<BaseResponseModel<StatementOnlineData>> getCardHistory(
      CardHistoryRequestModel? request, CancelToken? cancelToken) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_CARD_HISTORY.value,
        cancelToken: cancelToken,
        data: request?.toJSON() ?? CardHistoryRequestModel().toJSON(),
      );

      return BaseResponseModel<StatementOnlineData>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getCardStatementMonth(
      {CancelToken? cancelToken}) async {
    try {
      var rawResponse = await apiProvider.getRequest(
        Endpoint.GET_CARD_STATEMENT_MONTH.value,
        cancelToken: cancelToken,
      );

      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ExportCardStatementResponse>> getCardStatement(
      {required CardStatementRequestModel request,
      CancelToken? cancelToken}) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.GET_CARD_STATEMENT.value,
        data: request.toJSON(),
        cancelToken: cancelToken,
      );

      return BaseResponseModel<ExportCardStatementResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<CardContractInfo>>>
      getCardContractInfo(String contractId) async {
    try {
      String endPoint = Endpoint.GET_CARD_CONTRACT_INFO.value;
      final responseData = await apiProvider.postRequest(
        endPoint,
        data: {"contract_card_id": contractId},
      );
      return SingleResponse<BaseResponseModel<CardContractInfo>>(
          responseData.data ?? {},
          (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug('getCardList error $e');
      rethrow;
    }
  }

  Future<SingleResponse<BaseResponseModel<CardModel>>>
  getCardInfo(String cardId) async {
    try {
      String endPoint = Endpoint.GET_CARD_INFO.value;
      final responseData = await apiProvider.postRequest(
        endPoint,
        data: {"contract_card_id": cardId},
      );
      return SingleResponse<BaseResponseModel<CardModel>>(
          responseData.data ?? {},
              (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug('GET_CARD_INFO error $e');
      rethrow;
    }
  }
}
