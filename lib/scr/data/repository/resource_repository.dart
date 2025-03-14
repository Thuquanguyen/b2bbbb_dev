import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/data/model/banner_ad_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';

abstract class ResourceRepository {
  Future<BaseResponseModel<ListResponse<BannerAdModel>>> getBannerAds();
}

class ResourceRepositoryImpl implements ResourceRepository {
  final ApiProviderRepository apiProvider;

  ResourceRepositoryImpl({required this.apiProvider}) : super();

  @override
  Future<BaseResponseModel<ListResponse<BannerAdModel>>> getBannerAds() async {
    try {
      final responseData = await apiProvider.getRequest<Map<String, dynamic>>(Endpoint.GET_BANNER_AD.value,
          // options: buildCacheOptions(const Duration(days: 1), subKey: Endpoint.GET_BANNER_AD.value)
      );
      return BaseResponseModel<ListResponse<BannerAdModel>>.fromJson(responseData.data ?? {});
    } catch (e) {
      rethrow;
    }
  }
}
