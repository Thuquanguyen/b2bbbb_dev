// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dr_contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DRContractModel _$DRContractModelFromJson(Map<String, dynamic> json) {
  return DRContractModel(
    refNum: json['ref_num'] as String?,
    type: json['type'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    currency: json['currency'] as String?,
    valueDate: json['value_date'] as String?,
    traceDate: json['trace_date'] as String?,
    maturityDate: json['maturity_date'] as String?,
    dueDate: json['due_date'] as String?,
    paidAmt: (json['paid_amt'] as num?)?.toDouble(),
    outsAmnt: (json['outs_amnt'] as num?)?.toDouble(),
    applicationName: json['application_name'] as String?,
    beneficiaryName: json['beneficiary_name'] as String?,
  );
}

Map<String, dynamic> _$DRContractModelToJson(DRContractModel instance) =>
    <String, dynamic>{
      'ref_num': instance.refNum,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'value_date': instance.valueDate,
      'trace_date': instance.traceDate,
      'maturity_date': instance.maturityDate,
      'due_date': instance.dueDate,
      'paid_amt': instance.paidAmt,
      'outs_amnt': instance.outsAmnt,
      'application_name': instance.applicationName,
      'beneficiary_name': instance.beneficiaryName,
    };
