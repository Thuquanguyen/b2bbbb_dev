// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    username: json['username'] as String?,
    time: json['time'] as String?,
    account: json['account'] as String?,
    balance: json['balance'] as String?,
    ccy: json['ccy'] as String?,
    desc: json['desc'] as String?,
    id: json['id'] as String?,
    hasRead: json['has_read'] as bool?,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
    transCode: json['trans_code'] as String?,
  )..timeInDateTime = json['time_in_date_time'] == null
      ? null
      : DateTime.parse(json['time_in_date_time'] as String);
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'time': instance.time,
      'account': instance.account,
      'balance': instance.balance,
      'ccy': instance.ccy,
      'desc': instance.desc,
      'time_in_date_time': instance.timeInDateTime?.toIso8601String(),
      'id': instance.id,
      'has_read': instance.hasRead,
      'date_time': instance.dateTime?.toIso8601String(),
      'trans_code': instance.transCode,
    };
