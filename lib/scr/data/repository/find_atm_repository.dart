import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/intercepter_logging.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:dio/dio.dart';

class FindAtmRepository {
  static final FindAtmRepository _singleton = FindAtmRepository._internal();

  late Dio _dio;

  factory FindAtmRepository() {
    var dio = Dio(
      BaseOptions(
          baseUrl: AppEnvironmentManager.apiUrl,
          connectTimeout: 45000,
          receiveTimeout: 30000,
          responseType: ResponseType.json,
          headers: {
            Headers.contentTypeHeader: 'application/json',
          }),
    )
      ..interceptors.add(AppInterceptorLogging());
      // ..interceptors.add(DioCacheManager(CacheConfig(baseUrl: AppEnvironmentManager.apiUrl)).interceptor);

    _singleton._dio = dio;
    return _singleton;
  }

  FindAtmRepository._internal();

  Future<Response<T>> fetchMarker<T>(String url, Map<String, dynamic> header) async {
    _dio.options.headers = header;
    final Response<T> response =
        // await _dio.post(url, options: buildCacheOptions(const Duration(hours: 1), subKey: url));
        await _dio.post(url,);
    return response;
  }
}
