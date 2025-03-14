import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/loan_statement_model.dart';
import 'package:b2b/scr/data/model/loan/loan_detail_info.dart';

class LoanRepository {
  LoanRepository._internal();

  static final LoanRepository _singleton = LoanRepository._internal();

  factory LoanRepository(ApiProviderRepositoryImpl apiProvider) {
    _singleton.apiProvider = apiProvider;
    return _singleton;
  }

  late ApiProviderRepositoryImpl apiProvider;

  Future<BaseResponseModel<ListResponse<LoanStatementModel>>> getLoanHistory(
    String? contractNumber,
    String? fromDate,
    String? toDate,
  ) async {
    try {
      var rawResponse = await apiProvider
          .postRequest(Endpoint.GET_LOAN_STATEMENT.value, data: {
        'contract_number': contractNumber,
        'from_date': fromDate,
        'to_date': toDate,
      });
      return BaseResponseModel<ListResponse<LoanStatementModel>>.fromJson(
          rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<ListResponse>> getLoanList(
      {Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.getRequest(
        Endpoint.GET_LOAN_LIST.value,
      );
      return BaseResponseModel<ListResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<SingleResponse>> getLoanDetail(
      {Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider
          .postRequest(Endpoint.GET_LOAN_DETAIL.value, data: params);
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponseModel<String>> exportLoan(
      {Map<String, dynamic>? params}) async {
    try {
      var rawResponse = await apiProvider.postRequest(
        Endpoint.EXPORT_LOAN_DUE_DATE.value,
        data: params,
      );
      return BaseResponseModel<String>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
