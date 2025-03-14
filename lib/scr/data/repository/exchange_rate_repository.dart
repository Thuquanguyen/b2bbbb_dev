import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/utilities/logger.dart';

import 'package:dio/dio.dart';

abstract class ExchangeRateRepository {
  Future<SingleResponse<dynamic>> getExchangeRateList();
}

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ApiProviderRepository apiProvider;

  ExchangeRateRepositoryImpl({required this.apiProvider}) : super();

  @override
  Future<SingleResponse<BaseResponseModel>> getExchangeRateList() async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.GET_EXCHANGE_RATE.value,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            'access_token': apiAccessToken,
          },
        ),
      );
      return SingleResponse<BaseResponseModel>(responseData.data ?? {},
          (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }
}
