// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpModel _$OtpModelFromJson(Map<String, dynamic> json) {
  return OtpModel(
    result: json['result'] == null
        ? null
        : BaseResultModel.fromJson(json['result'] as Map<String, dynamic>),
    data: json['data'] == null
        ? null
        : LoginDataModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OtpModelToJson(OtpModel instance) => <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
    };
