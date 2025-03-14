// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_promote_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPromoteContent _$NotificationPromoteContentFromJson(
    Map<String, dynamic> json) {
  return NotificationPromoteContent(
    imageUrl: json['image_url'] as String?,
    imgAction: json['img_action'] as String?,
    content: json['content'] as String?,
    id: (json['id'] as num?)?.toDouble(),
    backLink: json['back_link'] as String?,
    dateCreated: json['date_created'] as String?,
  );
}

Map<String, dynamic> _$NotificationPromoteContentToJson(
        NotificationPromoteContent instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'img_action': instance.imgAction,
      'content': instance.content,
      'id': instance.id,
      'back_link': instance.backLink,
      'date_created': instance.dateCreated,
    };
