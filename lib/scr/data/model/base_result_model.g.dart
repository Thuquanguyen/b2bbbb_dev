// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResultModel _$BaseResultModelFromJson(Map<String, dynamic> json) {
  return BaseResultModel(
    code: json['code'] as String?,
    messageVi: json['message_vi'] as String?,
    messageEn: json['message_en'] as String?,
    appIosVersion: json['app_ios_version'] as String?,
    appAndroidVersion: json['app_android_version'] as String?,
    apiVersion: json['api_version'] as String?,
  );
}

Map<String, dynamic> _$BaseResultModelToJson(BaseResultModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message_vi': instance.messageVi,
      'message_en': instance.messageEn,
      'app_ios_version': instance.appIosVersion,
      'app_android_version': instance.appAndroidVersion,
      'api_version': instance.apiVersion,
    };
