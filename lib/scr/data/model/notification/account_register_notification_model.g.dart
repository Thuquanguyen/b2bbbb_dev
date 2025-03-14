// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_register_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountRegisterNotificationModel _$AccountRegisterNotificationModelFromJson(
    Map<String, dynamic> json) {
  return AccountRegisterNotificationModel(
    aggregateId: json['aggregate_Id'] as String?,
    secureTrans: json['secure_trans'] as String?,
  );
}

Map<String, dynamic> _$AccountRegisterNotificationModelToJson(
        AccountRegisterNotificationModel instance) =>
    <String, dynamic>{
      'aggregate_Id': instance.aggregateId,
      'secure_trans': instance.secureTrans,
    };
