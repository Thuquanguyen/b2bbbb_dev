// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuModel _$MenuModelFromJson(Map<String, dynamic> json) {
  return MenuModel(
    id: json['id'] as int?,
    parentId: json['parent_id'] as int?,
    labelId: json['label_id'] as String?,
    visible: json['visible'] as bool?,
    lock: json['lock'] as bool?,
  );
}

Map<String, dynamic> _$MenuModelToJson(MenuModel instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'label_id': instance.labelId,
      'visible': instance.visible,
      'lock': instance.lock,
    };
