// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return SessionModel(
    providerId: json['provider_id'] as String?,
    user: json['user'] == null
        ? null
        : SessionUserDataModel.fromJson(json['user'] as Map<String, dynamic>),
    customer: json['customer'] == null
        ? null
        : SessionCustomerDataModel.fromJson(
            json['customer'] as Map<String, dynamic>),
    topicKey:
        (json['topic_key'] as List<dynamic>?)?.map((e) => e as String).toList(),
    tokenIdentityNotification: json['token_identity_notification'] as String?,
  );
}

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'user': instance.user,
      'customer': instance.customer,
      'topic_key': instance.topicKey,
      'token_identity_notification': instance.tokenIdentityNotification,
    };
