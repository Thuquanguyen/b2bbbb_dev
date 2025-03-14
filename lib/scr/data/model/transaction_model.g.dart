// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionMainModel _$TransactionMainModelFromJson(Map<String, dynamic> json) {
  return TransactionMainModel(
    bankId: json['bank_id'] as String?,
    debitAccountBalance: (json['debit_account_balance'] as num?)?.toDouble(),
    debitAmount: (json['debit_amount'] as num?)?.toDouble(),
    debitAccountCcy: json['debit_account_ccy'] as String?,
    beneficiaryName: json['beneficiary_name'] as String?,
    currency: json['currency'] as String?,
    status: json['status'] == null
        ? null
        : NameModel.fromJson(json['status'] as Map<String, dynamic>),
    benAccountName: json['ben_account_name'] as String?,
    benBranch: json['ben_branch'] as String?,
    benBranchName: json['ben_branch_name'] as String?,
    benBankName: json['ben_bank_name'] as String?,
    benBankCode: json['ben_bank_code'] as String?,
    benCcy: json['ben_ccy'] as String?,
    city: json['city'] as String?,
    transactionType: json['transaction_type'] == null
        ? null
        : NameModel.fromJson(json['transaction_type'] as Map<String, dynamic>),
    amountInWords: json['amount_in_words'] == null
        ? null
        : NameModel.fromJson(json['amount_in_words'] as Map<String, dynamic>),
    exchangeRate: (json['exchange_rate'] as num?)?.toDouble(),
    charges: json['charges'] == null
        ? null
        : NameModel.fromJson(json['charges'] as Map<String, dynamic>),
    vatFeeAmount: (json['vat_fee_amount'] as num?)?.toDouble(),
    feeAmount: (json['fee_amount'] as num?)?.toDouble(),
    feeAmountCcy: json['fee_amount_ccy'] as String?,
    approver: json['approver'] as String?,
    dateApprover: json['date_approver'] as String?,
    createdBy: json['created_by'] as String?,
    createdDateTime: json['created_date_time'] == null
        ? null
        : DateTime.parse(json['created_date_time'] as String),
    groupDate: json['group_date'] as String?,
    chargesAccount: json['charges_account'] as String?,
    rejectCause: json['reject_cause'] as String?,
    totalInhouse: json['total_inhouse'] as int?,
    totalOther: json['total_other'] as int?,
  )
    ..transCode = json['trans_code'] as String?
    ..debitAccountNumber = json['debit_account_number'] as String?
    ..debitAccountName = json['debit_account_name'] as String?
    ..amount = (json['amount'] as num?)?.toDouble()
    ..createdDate = json['created_date'] as String?
    ..memo = json['memo'] as String?;
}

Map<String, dynamic> _$TransactionMainModelToJson(
        TransactionMainModel instance) =>
    <String, dynamic>{
      'trans_code': instance.transCode,
      'debit_account_number': instance.debitAccountNumber,
      'debit_account_name': instance.debitAccountName,
      'amount': instance.amount,
      'created_date': instance.createdDate,
      'memo': instance.memo,
      'bank_id': instance.bankId,
      'debit_account_balance': instance.debitAccountBalance,
      'debit_amount': instance.debitAmount,
      'debit_account_ccy': instance.debitAccountCcy,
      'beneficiary_name': instance.beneficiaryName,
      'currency': instance.currency,
      'status': instance.status,
      'ben_bank_name': instance.benBankName,
      'ben_bank_code': instance.benBankCode,
      'ben_account_name': instance.benAccountName,
      'ben_branch': instance.benBranch,
      'ben_branch_name': instance.benBranchName,
      'ben_ccy': instance.benCcy,
      'city': instance.city,
      'transaction_type': instance.transactionType,
      'amount_in_words': instance.amountInWords,
      'exchange_rate': instance.exchangeRate,
      'charges': instance.charges,
      'vat_fee_amount': instance.vatFeeAmount,
      'fee_amount': instance.feeAmount,
      'fee_amount_ccy': instance.feeAmountCcy,
      'approver': instance.approver,
      'date_approver': instance.dateApprover,
      'created_by': instance.createdBy,
      'created_date_time': instance.createdDateTime?.toIso8601String(),
      'group_date': instance.groupDate,
      'charges_account': instance.chargesAccount,
      'reject_cause': instance.rejectCause,
      'total_inhouse': instance.totalInhouse,
      'total_other': instance.totalOther,
    };
