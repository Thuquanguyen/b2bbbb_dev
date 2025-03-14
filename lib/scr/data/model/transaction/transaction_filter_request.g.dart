// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filter_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionFilterRequest _$TransactionFilterRequestFromJson(
    Map<String, dynamic> json) {
  return TransactionFilterRequest(
    serviceType: json['service_type'] as String,
    status: json['status'] as String,
    transCode: json['trans_code'] as String,
    accountingEntry: json['accounting_entry'] as String,
    fromAmount: (json['from_amount'] as num).toDouble(),
    toAmount: (json['to_amount'] as num).toDouble(),
    fromDate: json['from_date'] as String,
    toDate: json['to_date'] as String,
  );
}

Map<String, dynamic> _$TransactionFilterRequestToJson(
        TransactionFilterRequest instance) =>
    <String, dynamic>{
      'service_type': instance.serviceType,
      'status': instance.status,
      'trans_code': instance.transCode,
      'accounting_entry': instance.accountingEntry,
      'from_amount': instance.fromAmount,
      'to_amount': instance.toAmount,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
    };
