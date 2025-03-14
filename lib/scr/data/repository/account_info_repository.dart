import 'dart:async';

import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';

abstract class AccountInfoRepository {
  Future<BaseResponseModel<SingleResponse>> getAccountList();

  Future<SingleResponse<dynamic>> sendStatement(
      String fileType,
      String fromDate,
      String toDate,
      String accountNumber,
      double fromAmount,
      double toAmount,
      String memo);

  Future<SingleResponse<dynamic>> sendStatementOnline(
      String fromDate,
      String toDate,
      String accountNumber,
      double fromAmount,
      double toAmount,
      String memo);
}

class AccountInfoRepositoryImpl extends AccountInfoRepository {
  AccountInfoRepositoryImpl({required this.apiProvider});

  final ApiProviderRepositoryImpl apiProvider;

  @override
  Future<BaseResponseModel<SingleResponse>> getAccountList() async {
    try {
      final rawResponse = await apiProvider.getRequest<Map<String, dynamic>>(
          Endpoint.GET_ACCOUNT_LIST.value,
          queryParameters: null);
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SingleResponse<BaseResultModel>> sendStatement(
      String fileType,
      String fromDate,
      String toDate,
      String accountNumber,
      double fromAmount,
      double toAmount,
      String memo) async {
    try {
      final params = {
        'format_of_the_statement_file': fileType,
        'from_date': fromDate,
        'to_date': toDate,
        'account_number': accountNumber,
        'from_amount': fromAmount,
        'to_amount': toAmount,
        'memo': memo
      };
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.RECEIVER_STATEMENT_OFFLINE.value,
          data: params);
      return SingleResponse<BaseResultModel>(responseData.data ?? {},
          (itemJson) => BaseResultModel.fromJson(itemJson));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<SingleResponse> sendStatementOnline(
      String fromDate,
      String toDate,
      String accountNumber,
      double fromAmount,
      double toAmount,
      String memo) async {
    try {
      final params = {
        'from_date': fromDate,
        'to_date': toDate,
        'account_number': accountNumber,
        'from_amount': fromAmount,
        'to_amount': toAmount,
        'memo': memo
      };
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
          Endpoint.RECEIVER_STATEMENT_ONLINE.value,
          data: params,
      // options: Options(sendTimeout: 10,receiveTimeout: 10)
      );
      return SingleResponse<StatementOnlineResponse>(responseData.data ?? {},
          (itemJson) => StatementOnlineResponse.fromJson(itemJson));
    } catch (error) {
      rethrow;
    }
  }
}
