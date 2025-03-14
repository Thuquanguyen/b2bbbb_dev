// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_promote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPromoteModel _$NotificationPromoteModelFromJson(
    Map<String, dynamic> json) {
  return NotificationPromoteModel(
    fcmRes: json['fcm_res'] as String?,
    timeCommitFcm: json['time_commit_fcm'] as String?,
    username: json['username'] as String?,
    timeRequest: json['time_request'] as String?,
    hasRead: json['has_read'] as bool?,
    content: json['content'] == null
        ? null
        : NotificationPromoteContent.fromJson(
            json['content'] as Map<String, dynamic>),
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$NotificationPromoteModelToJson(
        NotificationPromoteModel instance) =>
    <String, dynamic>{
      'fcm_res': instance.fcmRes,
      'time_commit_fcm': instance.timeCommitFcm,
      'username': instance.username,
      'time_request': instance.timeRequest,
      'has_read': instance.hasRead,
      'content': instance.content,
      'id': instance.id,
    };
