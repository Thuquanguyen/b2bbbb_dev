// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NameModel<T> _$NameModelFromJson<T>(Map<String, dynamic> json) {
  return NameModel<T>(
    key: json['key'] as String?,
    valueVi: json['value_vi'] as String?,
    valueEn: json['value_en'] as String?,
  );
}

Map<String, dynamic> _$NameModelToJson<T>(NameModel<T> instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value_vi': instance.valueVi,
      'value_en': instance.valueEn,
    };
