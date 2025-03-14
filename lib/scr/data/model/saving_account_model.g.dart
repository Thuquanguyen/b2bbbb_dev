// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingAccountModel _$SavingAccountModelFromJson(Map<String, dynamic> json) {
  return SavingAccountModel(
    accountNo: json['account_no'] as String?,
    acountCcy: json['acount_ccy'] as String?,
    balance: (json['balance'] as num?)?.toDouble(),
    rate: json['rate'] as String?,
    term: json['term'] as String?,
    termDisplay: json['term_display'] == null
        ? null
        : NameModel.fromJson(json['term_display'] as Map<String, dynamic>),
    startDate: json['start_date'] as String?,
    endDate: json['end_date'] as String?,
    branch: json['branch'] as String?,
    contractNo: json['contract_no'] as String?,
    isOnline: json['is_online'] as bool?,
  );
}

Map<String, dynamic> _$SavingAccountModelToJson(SavingAccountModel instance) =>
    <String, dynamic>{
      'account_no': instance.accountNo,
      'acount_ccy': instance.acountCcy,
      'balance': instance.balance,
      'rate': instance.rate,
      'term': instance.term,
      'term_display': instance.termDisplay,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'branch': instance.branch,
      'contract_no': instance.contractNo,
      'is_online': instance.isOnline,
    };
