// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_payroll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionPayrollModel _$TransactionPayrollModelFromJson(
    Map<String, dynamic> json) {
  return TransactionPayrollModel(
    fileCode: json['file_code'] as String?,
    secureTrans: json['secure_trans'] as String?,
    refId: json['ref_id'] as String?,
    status: json['status'] == null
        ? null
        : NameModel.fromJson(json['status'] as Map<String, dynamic>),
    beneficiaryName: json['beneficiary_name'] as String?,
    currency: json['currency'] as String?,
    feeAmount: (json['fee_amount'] as num?)?.toDouble(),
    totalItem: json['total_item'] as int?,
  )
    ..transCode = json['trans_code'] as String?
    ..debitAccountNumber = json['debit_account_number'] as String?
    ..debitAccountName = json['debit_account_name'] as String?
    ..amount = (json['amount'] as num?)?.toDouble()
    ..createdDate = json['created_date'] as String?
    ..memo = json['memo'] as String?;
}

Map<String, dynamic> _$TransactionPayrollModelToJson(
        TransactionPayrollModel instance) =>
    <String, dynamic>{
      'trans_code': instance.transCode,
      'debit_account_number': instance.debitAccountNumber,
      'debit_account_name': instance.debitAccountName,
      'amount': instance.amount,
      'created_date': instance.createdDate,
      'memo': instance.memo,
      'file_code': instance.fileCode,
      'secure_trans': instance.secureTrans,
      'ref_id': instance.refId,
      'status': instance.status,
      'beneficiary_name': instance.beneficiaryName,
      'currency': instance.currency,
      'fee_amount': instance.feeAmount,
      'total_item': instance.totalItem,
    };
