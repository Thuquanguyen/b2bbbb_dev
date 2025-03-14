// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_resend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpResendModel _$OtpResendModelFromJson(Map<String, dynamic> json) {
  return OtpResendModel(
    verifyOtpDisplayType: json['verify_otp_display_type'] as int?,
    verifyTransId: json['verify_trans_id'] as String?,
  );
}

Map<String, dynamic> _$OtpResendModelToJson(OtpResendModel instance) =>
    <String, dynamic>{
      'verify_otp_display_type': instance.verifyOtpDisplayType,
      'verify_trans_id': instance.verifyTransId,
    };
