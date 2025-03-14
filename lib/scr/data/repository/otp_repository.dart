import 'dart:developer';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:dio/dio.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/data/model/otp/otp_model.dart';

abstract class OtpRepository {
  Future<SingleResponse<dynamic>> verifyOtp(String username, String otpCode, String otpSession);

  Future<SingleResponse<dynamic>> resendOtp(String username, String otpSession);

  Future<SingleResponse<dynamic>> getActivationCodeStartOTP();

  Future<SingleResponse<dynamic>> verifyMadeFund(Map<String, dynamic> params, String url);

  Future<BaseResponseModel<SingleResponse>> resendVerifyOtp(int verifyDisplayType, String transcode);
}

class OtpRepositoryImpl extends OtpRepository {
  OtpRepositoryImpl({required this.apiProvider}) : super();
  final ApiProviderRepositoryImpl apiProvider;

  @override
  Future<SingleResponse<OtpModel>> verifyOtp(String username, String otpCode, String otpSession) async {
    try {
      final params = {
        'otp_code': otpCode,
        'otp_session': otpSession,
        'username': username,
      };
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.VERIFY_OTP.value,
        data: params,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            'access_token': apiAccessToken,
          },
        ),
      );
      return SingleResponse<OtpModel>(responseData.data ?? {}, (dynamic item) => OtpModel.fromJson(item));
    } catch (e) {
      log('verifyOtp: catch response error here');
      rethrow;
    }
  }

  @override
  Future<SingleResponse<OtpModel>> resendOtp(String username, String otpSession) async {
    try {
      final params = {
        'otp_session': otpSession,
        'username': username,
      };
      final responseData = await apiProvider.putRequest<Map<String, dynamic>>(
        Endpoint.RESEND_OTP.value,
        data: params,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            'access_token': apiAccessToken,
          },
        ),
      );
      return SingleResponse<OtpModel>(responseData.data ?? {}, (dynamic item) => OtpModel.fromJson(item));
    } catch (e) {
      log('resendOtp: catch response error here');
      rethrow;
    }
  }

  @override
  Future<SingleResponse<BaseResultModel>> getActivationCodeStartOTP() async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        Endpoint.GET_ACTIVATION_CODE_SMART_OTP.value,
      );
      return SingleResponse<BaseResultModel>(responseData.data ?? {}, (dynamic item) => BaseResultModel.fromJson(item));
    } catch (e) {
      log('login: catch response error here');
      rethrow;
    }
  }

  @override
  Future<SingleResponse<BaseResponseModel>> verifyMadeFund(Map<String, dynamic> params, String url) async {
    try {
      final responseData = await apiProvider.postRequest<Map<String, dynamic>>(
        url,
        data: params,
      );
      return SingleResponse<BaseResponseModel>(responseData.data ?? {}, (dynamic item) => BaseResponseModel.fromJson(item));
    } catch (e) {
      log('resendOtp: catch response error here');
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> resendVerifyOtp(int verifyDisplayType, String transcode) async {
    try {
      var rawResponse = await apiProvider.putRequest(
        Endpoint.RESEND_VERIFY_OTP.value,
        data: {
          "trans_code": transcode,
          "transfer_type_code": verifyDisplayType,
        },
      );
      return BaseResponseModel<SingleResponse>.fromJson(rawResponse.data);
    } catch (e) {
      rethrow;
    }
  }
}
