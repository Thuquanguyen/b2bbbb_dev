// ignore_for_file: avoid_print

import 'dart:io';

import 'package:b2b/app_manager.dart';
import 'package:b2b/scr/data/model/auth/login_model.dart';
import 'package:b2b/scr/data/model/auth/menu_model.dart';
import 'package:b2b/scr/data/model/auth/register_type_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/change_password_request_model.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';

import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';

abstract class AuthenRepository {
  Future<SingleResponse<dynamic>> login(String username, String password, AuthenType authenType);

  Future<SingleResponse<dynamic>> registerLoginType(AuthenType authenType);

  Future<SingleResponse<dynamic>> getSessionInfo();

  void logout();

  void forgotPassword();

  Future<BaseResultModel> changePassword(ChangePasswordRequestModel changePasswordRequest);

  void cleanUserDevice(String userName);

  void getMenuUserPermission();
}

class AuthenRepositoryImpl extends AuthenRepository {
  AuthenRepositoryImpl({required this.apiProvider}) : super();
  final ApiProviderRepositoryImpl apiProvider;

  @override
  void forgotPassword() {}

  int getAuthenType(AuthenType authenType) {
    switch (authenType) {
      case AuthenType.PASSWORD:
        return 1;
      case AuthenType.FACEID:
        return 2;
      case AuthenType.TOUCHID:
        return 3;
      case AuthenType.PINCODE:
        return 4;
      default:
        return 1;
    }
  }

  AuthenType getAuthenTypeEnum(int authenType) {
    switch (authenType) {
      case 1:
        return AuthenType.PASSWORD;
      case 2:
        return AuthenType.FACEID;
      case 3:
        return AuthenType.TOUCHID;
      case 4:
        return AuthenType.PINCODE;
      default:
        return AuthenType.PASSWORD;
    }
  }

  @override
  Future<SingleResponse<LoginModel>> login(String username, String password, AuthenType authenType) async {
    final String deviceId = AppManager().deviceId;
    final String timeInstallApp = await LocalStorageHelper.getTimeInstallApp();
    try {
      final params = {
        'username': username,
        'authen_passwd': password,
        'device_id': deviceId,
        'channel_type': Platform.isIOS ? 'app_ios' : 'app_android',
        'authen_type': getAuthenType(authenType),
        'time_install_app': timeInstallApp,
      };
      final responseData = await apiProvider.postRequest(
        Endpoint.LOGIN.value,
        data: params,
      );
      return SingleResponse<LoginModel>(responseData.data ?? {}, (dynamic item) => LoginModel.fromJson(item));
    } catch (e) {
      Logger.debug('login: catch response error here');
      rethrow;
    }
  }

  @override
  Future<SingleResponse<RegisterTypeModel>> registerLoginType(AuthenType authenType) async {
    try {
      final params = {
        'authen_type': getAuthenType(authenType),
      };
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.REGISTER_LOGIN_TYPE.value,
        data: params,
      );
      Logger.debug(responseData.toString());
      return SingleResponse<RegisterTypeModel>(
          responseData.data ?? {}, (dynamic item) => RegisterTypeModel.fromJson(item));
    } catch (e) {
      Logger.debug('registerLoginType: catch response error here');
      rethrow;
    }
  }

  @override
  void logout() {
    apiProvider.putRequest(Endpoint.LOGOUT.value, data: null);
  }

  @override
  Future<SingleResponse<BaseResponseModel>> getSessionInfo() async {
    try {
      final responseData = await apiProvider.getRequest<Map<String, dynamic>>(
        Endpoint.GET_SESSION_INFO.value,
        queryParameters: null,
      );
      return SingleResponse<BaseResponseModel>(
          responseData.data ?? {}, (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug('getSessionInfo: catch response error here');
      rethrow;
    }
  }

  @override
  Future<SingleResponse<BaseResponseModel<MenuModel>>> getMenuUserPermission() async {
    try {
      String endPoint = Endpoint.GET_MENU_USER_PERMISSION.value;
      try {
        // var encode = base64.encode(utf8.encode(AccountManager().currentUsername));
        // if (endPoint.contains("?")) {
        //   endPoint = endPoint + '&ref=' + encode;
        // } else {
        //   endPoint = endPoint + '?ref=' + encode;
        // }
      } catch (e) {}
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        endPoint,
        queryParameters: null,
          // options: buildCacheOptions(const Duration(minutes: 5), subKey: endPoint)
      );
      return SingleResponse<BaseResponseModel<MenuModel>>(
          responseData.data ?? {}, (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      Logger.debug('getSessionInfo: catch response error here');
      rethrow;
    }
  }

  @override
  void cleanUserDevice(String userName) async {
    final String deviceId = AppManager().deviceId;
    final params = {'device_id': deviceId, 'username': userName};
    apiProvider.putRequest(Endpoint.CLEAR_USER_DEVICE.value, data: params);
  }

  @override
  Future<BaseResultModel> changePassword(ChangePasswordRequestModel changePasswordRequest) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.CHANGE_PASSWORD.value,
        data: changePasswordRequest.toJson(),
      );
      Logger.debug(responseData.toString());
      return BaseResultModel.fromJson(responseData.data ?? {});
    } catch (e) {
      Logger.debug("ERROR ======> $e");
      rethrow;
    }
  }
}
