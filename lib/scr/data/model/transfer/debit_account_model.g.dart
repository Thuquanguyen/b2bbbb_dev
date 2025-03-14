// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitAccountModel _$DebitAccountModelFromJson(Map<String, dynamic> json) {
  return DebitAccountModel(
    accountNumber: json['account_number'] as String?,
    accountCurrency: json['account_currency'] as String?,
    availableBalance: (json['available_balance'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$DebitAccountModelToJson(DebitAccountModel instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'account_currency': instance.accountCurrency,
      'available_balance': instance.availableBalance,
    };

DebitAccountResponseModel _$DebitAccountResponseModelFromJson(
    Map<String, dynamic> json) {
  return DebitAccountResponseModel(
    debbitAccountList: (json['debbit_account_list'] as List<dynamic>?)
        ?.map((e) => DebitAccountModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    accountDefault: json['account_default'] as String?,
  );
}

Map<String, dynamic> _$DebitAccountResponseModelToJson(
        DebitAccountResponseModel instance) =>
    <String, dynamic>{
      'debbit_account_list': instance.debbitAccountList,
      'account_default': instance.accountDefault,
    };
