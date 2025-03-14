// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) {
  return LoginModel(
    result: json['result'] == null
        ? null
        : BaseResultModel.fromJson(json['result'] as Map<String, dynamic>),
    data: json['data'] == null
        ? null
        : LoginDataModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
    };
