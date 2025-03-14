// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkerModel _$MarkerModelFromJson(Map<String, dynamic> json) {
  return MarkerModel(
    json['id'] as String,
    json['name'] as String,
    json['address'] as String,
    (json['lat'] as num).toDouble(),
    (json['lng'] as num).toDouble(),
    json['atmWorkingTime'] as String?,
    json['cdmWorkingTime'] as String?,
    json['branchWorkingTime'] as String?,
    json['is_atm247'] as bool?,
    json['is_cdm247'] as bool?,
    json['is_branch247'] as bool?,
    (json['type'] as List<dynamic>).map((e) => e as String).toList(),
    json['note'] as String?,
  );
}

Map<String, dynamic> _$MarkerModelToJson(MarkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_cdm247': instance.isCdm247,
      'is_atm247': instance.isAtm247,
      'is_branch247': instance.isBranch247,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'cdmWorkingTime': instance.cdmWorkingTime,
      'atmWorkingTime': instance.atmWorkingTime,
      'branchWorkingTime': instance.branchWorkingTime,
      'name': instance.name,
      'note': instance.note,
      'type': instance.type,
    };
