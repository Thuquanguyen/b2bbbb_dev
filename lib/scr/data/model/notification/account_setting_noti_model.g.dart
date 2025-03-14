// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_setting_noti_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSettingNotiModel _$AccountSettingNotiModelFromJson(
    Map<String, dynamic> json) {
  return AccountSettingNotiModel(
    aggregateId: json['aggregate_Id'] as String?,
    enable: json['enable'] as bool?,
    secureTrans: json['secure_trans'] as String?,
    accountNumber: json['account_number'] as String?,
    accountCurrency: json['account_currency'] as String?,
    availableBalance: (json['available_balance'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$AccountSettingNotiModelToJson(
        AccountSettingNotiModel instance) =>
    <String, dynamic>{
      'aggregate_Id': instance.aggregateId,
      'enable': instance.enable,
      'secure_trans': instance.secureTrans,
      'account_number': instance.accountNumber,
      'account_currency': instance.accountCurrency,
      'available_balance': instance.availableBalance,
    };
