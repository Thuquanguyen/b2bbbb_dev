// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_init_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionManageInitBaseResponse _$TransactionManageInitBaseResponseFromJson(
    Map<String, dynamic> json) {
  return TransactionManageInitBaseResponse(
    secureTrans: json['secure_trans'] as String?,
    transcodeTrusted: json['transcode_trusted'] as String?,
    transferTypeCode: json['transfer_type_code'] as int?,
  );
}

Map<String, dynamic> _$TransactionManageInitBaseResponseToJson(
        TransactionManageInitBaseResponse instance) =>
    <String, dynamic>{
      'secure_trans': instance.secureTrans,
      'transcode_trusted': instance.transcodeTrusted,
      'transfer_type_code': instance.transferTypeCode,
    };

TransactionManageInitResponse _$TransactionManageInitResponseFromJson(
    Map<String, dynamic> json) {
  return TransactionManageInitResponse(
    transactions: (json['transactions'] as List<dynamic>?)
        ?.map((e) => TransactionMainModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  )
    ..secureTrans = json['secure_trans'] as String?
    ..transcodeTrusted = json['transcode_trusted'] as String?
    ..transferTypeCode = json['transfer_type_code'] as int?;
}

Map<String, dynamic> _$TransactionManageInitResponseToJson(
        TransactionManageInitResponse instance) =>
    <String, dynamic>{
      'secure_trans': instance.secureTrans,
      'transcode_trusted': instance.transcodeTrusted,
      'transfer_type_code': instance.transferTypeCode,
      'transactions': instance.transactions,
    };

BillTransactionManageInitResponse _$BillTransactionManageInitResponseFromJson(
    Map<String, dynamic> json) {
  return BillTransactionManageInitResponse(
    transactions: (json['transactions'] as List<dynamic>?)
        ?.map((e) => BillPaymentModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  )
    ..secureTrans = json['secure_trans'] as String?
    ..transcodeTrusted = json['transcode_trusted'] as String?
    ..transferTypeCode = json['transfer_type_code'] as int?;
}

Map<String, dynamic> _$BillTransactionManageInitResponseToJson(
        BillTransactionManageInitResponse instance) =>
    <String, dynamic>{
      'secure_trans': instance.secureTrans,
      'transcode_trusted': instance.transcodeTrusted,
      'transfer_type_code': instance.transferTypeCode,
      'transactions': instance.transactions,
    };
