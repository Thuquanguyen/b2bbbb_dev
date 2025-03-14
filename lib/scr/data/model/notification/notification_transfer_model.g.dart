// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationTransferModel _$NotificationTransferModelFromJson(
    Map<String, dynamic> json) {
  return NotificationTransferModel(
    fcmRes: json['fcm_res'] as String?,
    timeCommitFcm: json['time_commit_fcm'] as String?,
    username: json['username'] as String?,
    timeRequest: json['time_request'] as String?,
    hasRead: json['has_read'] as bool?,
    content: json['content'] == null
        ? null
        : NotificationTransferContentModel.fromJson(
            json['content'] as Map<String, dynamic>),
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$NotificationTransferModelToJson(
        NotificationTransferModel instance) =>
    <String, dynamic>{
      'fcm_res': instance.fcmRes,
      'time_commit_fcm': instance.timeCommitFcm,
      'username': instance.username,
      'time_request': instance.timeRequest,
      'has_read': instance.hasRead,
      'content': instance.content,
      'id': instance.id,
    };
