// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponseModel<T> _$BaseResponseModelFromJson<T>(Map<String, dynamic> json) {
  return BaseResponseModel<T>(
    result: json['result'] == null
        ? null
        : BaseResultModel.fromJson(json['result'] as Map<String, dynamic>),
    data: json['data'],
  );
}

Map<String, dynamic> _$BaseResponseModelToJson<T>(
        BaseResponseModel<T> instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
    };
