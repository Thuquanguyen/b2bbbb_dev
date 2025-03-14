// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpDataModel _$OtpDataModelFromJson(Map<String, dynamic> json) {
  return OtpDataModel(
    sessionId: json['session_id'] as String?,
    otpSession: json['otp_session'] as String?,
  );
}

Map<String, dynamic> _$OtpDataModelToJson(OtpDataModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'otp_session': instance.otpSession,
    };
