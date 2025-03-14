// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_confirm_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionManageConfirmResponse _$TransactionManageConfirmResponseFromJson(
    Map<String, dynamic> json) {
  return TransactionManageConfirmResponse(
    verifyOtpDisplayType: json['verify_otp_display_type'] as int?,
    verifyTransId: json['verify_trans_id'] as String?,
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$TransactionManageConfirmResponseToJson(
        TransactionManageConfirmResponse instance) =>
    <String, dynamic>{
      'verify_otp_display_type': instance.verifyOtpDisplayType,
      'verify_trans_id': instance.verifyTransId,
      'message': instance.message,
    };
