// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDataModel _$LoginDataModelFromJson(Map<String, dynamic> json) {
  return LoginDataModel(
    sessionId: json['session_id'] as String?,
    otpSession: json['otp_session'] as String?,
  );
}

Map<String, dynamic> _$LoginDataModelToJson(LoginDataModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'otp_session': instance.otpSession,
    };
