import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/exchange_rate_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/data/model/transaction_inquiry_request.dart';
import 'package:b2b/utilities/logger.dart';

import 'package:dio/dio.dart';

abstract class TransactionRepository {
  Future<BaseResponseModel<ExchangeRateModel>> getSupportedCurrency();

  Future<BaseResponseModel<TransactionMainModel>> getTransactionList(
      TransactionInquiryRequest request);

  Future<BaseResponseModel<TransactionMainModel>> getTransactionDetail(String code);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final ApiProviderRepository apiProvider;

  TransactionRepositoryImpl({required this.apiProvider}) : super();

  @override
  Future<BaseResponseModel<ExchangeRateModel>> getSupportedCurrency() async {
    try {
      final responseData = await apiProvider.getRequest<Map<String, dynamic>>(
        Endpoint.GET_SUPPORTED_CURRENCY.value,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            'access_token': apiAccessToken,
          },
        ),
      );
      return BaseResponseModel<ExchangeRateModel>.fromJson(
        responseData.data ?? {},
      );
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<TransactionMainModel>> getTransactionList(
      TransactionInquiryRequest request) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.GET_TRANSACTION_LIST.value,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            'access_token': apiAccessToken,
          },
        ),
        data: request.toJson(),
      );
      return BaseResponseModel<TransactionMainModel>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<TransactionMainModel>> getTransactionDetail(
      String code) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.GET_TRANSACTION_DETAIL.value,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/json',
              'access_token': apiAccessToken,
            },
          ),
          data: {
            'trans_code': code,
          });
      return BaseResponseModel<TransactionMainModel>.fromJson(
          responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }
}
