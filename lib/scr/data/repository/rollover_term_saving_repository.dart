import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';

abstract class RolloverTermSavingRepository {
  Future<BaseResponseModel<SingleResponse>> getRolloverTermSaving();
}

class RolloverTermSavingRepositoryImpl extends RolloverTermSavingRepository {
  RolloverTermSavingRepositoryImpl({required this.apiProvider}) : super();
  final ApiProviderRepositoryImpl apiProvider;

  @override
  Future<BaseResponseModel<SingleResponse>> getRolloverTermSaving() async {
    try {
      final rawResponse = await apiProvider.getRequest(
        Endpoint.GET_ROLLOVER_TERM_SAVING_ONLINE.value,
        // options: buildCacheOptions(const Duration(hours: 1), subKey: Endpoint.GET_ROLLOVER_TERM_SAVING_ONLINE.value),
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
