// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_ben_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollBenListFilterRequest _$PayrollBenListFilterRequestFromJson(
    Map<String, dynamic> json) {
  return PayrollBenListFilterRequest(
    fileCode: json['file_code'] as String?,
    fillter: json['fillter'] == null
        ? null
        : PayrollBenListFilter.fromJson(
            json['fillter'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PayrollBenListFilterRequestToJson(
        PayrollBenListFilterRequest instance) =>
    <String, dynamic>{
      'file_code': instance.fileCode,
      'fillter': instance.fillter,
    };

PayrollBenListFilter _$PayrollBenListFilterFromJson(Map<String, dynamic> json) {
  return PayrollBenListFilter(
    keywords: json['keywords'] as String?,
    fromAmt: (json['from_amt'] as num?)?.toDouble(),
    toAmt: (json['to_amt'] as num?)?.toDouble(),
    options: json['options'] as int?,
  );
}

Map<String, dynamic> _$PayrollBenListFilterToJson(
        PayrollBenListFilter instance) =>
    <String, dynamic>{
      'keywords': instance.keywords,
      'from_amt': instance.fromAmt,
      'to_amt': instance.toAmt,
      'options': instance.options,
    };

PayrollBenModel _$PayrollBenModelFromJson(Map<String, dynamic> json) {
  return PayrollBenModel(
    transNo: json['trans_no'] as String?,
    benName: json['ben_name'] as String?,
    benAcc: json['ben_acc'] as String?,
    benBank: json['ben_bank'] as String?,
    benBranch: json['ben_branch'] as String?,
    benAmt: json['ben_amt'] as String?,
    benCcy: json['ben_ccy'] as String?,
    feeAmt: json['fee_amt'] as String?,
  );
}

Map<String, dynamic> _$PayrollBenModelToJson(PayrollBenModel instance) =>
    <String, dynamic>{
      'trans_no': instance.transNo,
      'ben_name': instance.benName,
      'ben_acc': instance.benAcc,
      'ben_bank': instance.benBank,
      'ben_branch': instance.benBranch,
      'ben_amt': instance.benAmt,
      'ben_ccy': instance.benCcy,
      'fee_amt': instance.feeAmt,
    };
