// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_type_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterTypeDataModel _$RegisterTypeDataModelFromJson(
    Map<String, dynamic> json) {
  return RegisterTypeDataModel(
    authenPasswd: json['authen_passwd'] as String?,
    authenType: json['authen_type'] as int?,
  );
}

Map<String, dynamic> _$RegisterTypeDataModelToJson(
        RegisterTypeDataModel instance) =>
    <String, dynamic>{
      'authen_passwd': instance.authenPasswd,
      'authen_type': instance.authenType,
    };
