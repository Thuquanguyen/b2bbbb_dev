// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequestModel _$ChangePasswordRequestModelFromJson(
    Map<String, dynamic> json) {
  return ChangePasswordRequestModel(
    oldPasswd: json['old_passwd'] as String,
    newPasswd: json['new_passwd'] as String,
    confirmNewPasswd: json['confirm_new_passwd'] as String,
  );
}

Map<String, dynamic> _$ChangePasswordRequestModelToJson(
        ChangePasswordRequestModel instance) =>
    <String, dynamic>{
      'old_passwd': instance.oldPasswd,
      'new_passwd': instance.newPasswd,
      'confirm_new_passwd': instance.confirmNewPasswd,
    };
