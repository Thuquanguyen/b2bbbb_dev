// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_history_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationHistoryBalanceModel _$NotificationHistoryBalanceModelFromJson(
    Map<String, dynamic> json) {
  return NotificationHistoryBalanceModel(
    timeRequest: json['time_request'] as String?,
    username: json['username'] as String?,
    timeCommitFcm: json['time_commit_fcm'] as String?,
    fcmRes: json['fcm_res'] as String?,
    hasRead: json['has_read'] as bool?,
    id: json['id'] as String?,
    content: json['content'] as String?,
  )..contentDecrypted = json['content_decrypted'] as String?;
}

Map<String, dynamic> _$NotificationHistoryBalanceModelToJson(
        NotificationHistoryBalanceModel instance) =>
    <String, dynamic>{
      'time_request': instance.timeRequest,
      'username': instance.username,
      'time_commit_fcm': instance.timeCommitFcm,
      'fcm_res': instance.fcmRes,
      'has_read': instance.hasRead,
      'id': instance.id,
      'content': instance.content,
      'content_decrypted': instance.contentDecrypted,
    };
