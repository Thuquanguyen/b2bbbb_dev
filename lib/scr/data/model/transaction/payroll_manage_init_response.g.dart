// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_manage_init_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollManageInitResponse _$PayrollManageInitResponseFromJson(
    Map<String, dynamic> json) {
  return PayrollManageInitResponse(
    transactions: json['transactions'] == null
        ? null
        : TransactionMainModel.fromJson(
            json['transactions'] as Map<String, dynamic>),
    secureTrans: json['secure_trans'] as String?,
    totalInhouse: json['total_inhouse'] as int?,
    totalOther: json['total_other'] as int?,
  );
}

Map<String, dynamic> _$PayrollManageInitResponseToJson(
        PayrollManageInitResponse instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'secure_trans': instance.secureTrans,
      'total_inhouse': instance.totalInhouse,
      'total_other': instance.totalOther,
    };
