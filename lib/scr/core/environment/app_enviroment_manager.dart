import 'package:b2b/config.dart';

class AppEnvironmentManager {
  AppEnvironmentManager._();

  static final _instance = AppEnvironmentManager._();

  factory AppEnvironmentManager() => _instance;

  static initialize() {
    baseUrlFirebase = 'https://us-central1-b2b-mobile-app-deb71.cloudfunctions.net';
    if (AppConfig.env == AppEnvironment.Dev) {
      baseUrl = 'https://118.70.213.238';
      apiUrl = baseUrl + '/b2bMobileSIT/api'; // example
      onboardUrl = 'http://10.37.24.8/tai-khoan-doanh-nghiep/ekyc/option';
      environment = AppEnvironment.Dev;
    } else {
      baseUrl = 'https://api-b2b.vpbank.com.vn';
      apiUrl = baseUrl + '/mapi/api'; // example
      onboardUrl = 'https://smeconnect.vpbank.com.vn/tai-khoan-doanh-nghiep/ekyc/option';
      environment = AppEnvironment.Pro;
    }
  }

  // late AppEnvironment appEnvironment;
  // your params config specified environment is here
  static late String apiUrl;
  static late String baseUrl;
  static late String baseUrlFirebase;
  static late String versionApp;
  static late String onboardUrl;
  static late AppEnvironment environment;
}
