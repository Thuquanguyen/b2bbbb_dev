// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionUserDataModel _$SessionUserDataModelFromJson(Map<String, dynamic> json) {
  return SessionUserDataModel(
    username: json['username'] as String?,
    otpMethod: json['otp_method'] as String?,
    otpPhone: json['otp_phone'] as String?,
    otpEmail: json['otp_email'] as String?,
    certId: json['cert_id'] as String?,
    fullName: json['full_name'] as String?,
    roleCode: json['role_code'] as String?,
    roleName: json['role_name'] == null
        ? null
        : NameModel.fromJson(json['role_name'] as Map<String, dynamic>),
    otpMethodName: json['otp_method_name'] == null
        ? null
        : NameModel.fromJson(json['otp_method_name'] as Map<String, dynamic>),
    lastLogin: json['last_login'] as String?,
    enableSmartotp: json['enable_smartotp'] as bool,
  );
}

Map<String, dynamic> _$SessionUserDataModelToJson(
        SessionUserDataModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'otp_method': instance.otpMethod,
      'otp_phone': instance.otpPhone,
      'otp_email': instance.otpEmail,
      'full_name': instance.fullName,
      'cert_id': instance.certId,
      'role_code': instance.roleCode,
      'role_name': instance.roleName,
      'otp_method_name': instance.otpMethodName,
      'last_login': instance.lastLogin,
      'enable_smartotp': instance.enableSmartotp,
    };
