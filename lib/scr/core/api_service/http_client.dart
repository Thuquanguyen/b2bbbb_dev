import 'dart:io';

import 'package:b2b/config.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:dio/dio.dart';

import 'intercepter_logging.dart';

class HttpClient {
  HttpClient._internal();

  static HttpClient shared = HttpClient._internal();

  Dio? _repository;
  Dio? _repositoryFireBase;

  static Dio getRepository() {
    shared._repository ??= generateRepository();
    return shared._repository!;
  }

  static Dio getRepositoryFireBase() {
    shared._repositoryFireBase ??= generateRepositoryFireBase();
    return shared._repositoryFireBase!;
  }

  static Dio generateRepository() => Dio(
        BaseOptions(
            baseUrl: AppEnvironmentManager.apiUrl,
            connectTimeout: 45000,
            receiveTimeout: 30000,
            responseType: ResponseType.json,
            headers: {
              Headers.contentTypeHeader: 'application/json',
              'access_token': apiAccessToken,
            }),
      )..interceptors.add(AppInterceptorLogging());

  // ..interceptors.add(
  //     DioCacheManager(CacheConfig(baseUrl: AppEnvironmentManager.apiUrl))
  //         .interceptor);

  static Dio generateRepositoryFireBase() => Dio(BaseOptions(
          baseUrl: AppEnvironmentManager.baseUrlFirebase,
          connectTimeout: 45000,
          receiveTimeout: 30000,
          responseType: ResponseType.json,
          headers: {
            Headers.contentTypeHeader: 'application/json',
          }))
        ..interceptors.add(AppInterceptorLogging());

  // ..interceptors.add(
  //     DioCacheManager(CacheConfig(baseUrl: AppEnvironmentManager.baseUrlFirebase))
  //         .interceptor);

  static void setSessionId(String? sessionId) {
    String platform = '';
    if (Platform.isAndroid) {
      platform = 'ANDROID';
    } else if (Platform.isIOS) {
      platform = 'IOS';
    }
    if (shared._repository != null) {
      shared._repository!.options.headers = {
        ...shared._repository!.options.headers,
        'session_id': sessionId ?? '',
        'platform': platform,
        'build_number': AppConfig.buildNumber,
        'version_name': AppConfig.versionName,
      };
    }
  }
}
