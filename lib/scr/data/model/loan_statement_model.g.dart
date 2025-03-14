// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanStatementModel _$LoanStatementModelFromJson(Map<String, dynamic> json) {
  return LoanStatementModel(
    transactionDate: json['transaction_date'] as String?,
    transactionType: json['transaction_type'] as String?,
    disbursementAmount: (json['disbursement_amount'] as num?)?.toDouble(),
    principleRepayment: (json['principle_repayment'] as num?)?.toDouble(),
    overduePrinciple: (json['overdue_principle'] as num?)?.toDouble(),
    interestRepayment: (json['interest_repayment'] as num?)?.toDouble(),
    overdueInterest: (json['overdue_interest'] as num?)?.toDouble(),
    overdueFee: (json['overdue_fee'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$LoanStatementModelToJson(LoanStatementModel instance) =>
    <String, dynamic>{
      'transaction_date': instance.transactionDate,
      'transaction_type': instance.transactionType,
      'disbursement_amount': instance.disbursementAmount,
      'principle_repayment': instance.principleRepayment,
      'overdue_principle': instance.overduePrinciple,
      'interest_repayment': instance.interestRepayment,
      'overdue_interest': instance.overdueInterest,
      'overdue_fee': instance.overdueFee,
    };
