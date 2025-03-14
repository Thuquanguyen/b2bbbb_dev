// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterTypeModel _$RegisterTypeModelFromJson(Map<String, dynamic> json) {
  return RegisterTypeModel(
    result: json['result'] == null
        ? null
        : BaseResultModel.fromJson(json['result'] as Map<String, dynamic>),
    data: json['data'] == null
        ? null
        : RegisterTypeDataModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RegisterTypeModelToJson(RegisterTypeModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
    };
