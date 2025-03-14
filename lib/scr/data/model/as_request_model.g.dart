// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'as_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountServiceRequestModel _$AccountServiceRequestModelFromJson(
    Map<String, dynamic> json) {
  return AccountServiceRequestModel(
    accountNumber: json['account_number'] as String,
    fromDate: json['from_date'] as String,
    toDate: json['to_date'] as String,
    fromAmount: (json['from_amount'] as num).toDouble(),
    toAmount: (json['to_amount'] as num).toDouble(),
    memo: json['memo'] as String,
  );
}

Map<String, dynamic> _$AccountServiceRequestModelToJson(
        AccountServiceRequestModel instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
      'from_amount': instance.fromAmount,
      'to_amount': instance.toAmount,
      'memo': instance.memo,
    };
