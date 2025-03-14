// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return AccountModel(
    DataAccount.fromJson(json['data_business_account'] as Map<String, dynamic>),
    DataAccount.fromJson(json['data_payment_account'] as Map<String, dynamic>),
    DataAccount.fromJson(
        json['data_specialized_account'] as Map<String, dynamic>),
    DataAccount.fromJson(json['data_saving_account'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'data_business_account': instance.dataBusinessAccount,
      'data_payment_account': instance.dataPaymentAccount,
      'data_specialized_account': instance.dataSpecializedAccount,
      'data_saving_account': instance.dataSavingAccount,
    };

DataAccount _$DataAccountFromJson(Map<String, dynamic> json) {
  return DataAccount(
    json['group_id'] as String,
    NameModel.fromJson(json['group_name'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>)
        .map((e) => AccountInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DataAccountToJson(DataAccount instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'group_name': instance.groupName,
      'data': instance.data,
    };

GroupName _$GroupNameFromJson(Map<String, dynamic> json) {
  return GroupName(
    json['key'] as String? ?? '',
    json['value_vi'] as String?,
    json['value_en'] as String?,
  );
}

Map<String, dynamic> _$GroupNameToJson(GroupName instance) => <String, dynamic>{
      'key': instance.key,
      'value_vi': instance.valueVi,
      'value_en': instance.valueEn,
    };

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
  return AccountInfo(
    json['account_number'] as String?,
    json['account_currency'] as String?,
    json['account_category'] as String?,
    json['account_name'] as String?,
    json['branch_code'] as String?,
    json['branch_name'] as String?,
    (json['working_balance'] as num?)?.toDouble(),
    (json['available_balance'] as num?)?.toDouble(),
    (json['locked_amount'] as num?)?.toDouble(),
    (json['limit_amount'] as num?)?.toDouble(),
    json['opened_date'] as String?,
    json['az_expried_date'] as String?,
    json['az_init_rate'] as String?,
    json['az_term'] as String?,
    json['az_product_code'] as String?,
    json['contract_no'] as String?,
    json['customer_type'] as String?,
    json['ac_status'] as String?,
  );
}

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'account_currency': instance.accountCurrency,
      'account_category': instance.accountCategory,
      'account_name': instance.accountName,
      'branch_code': instance.branchCode,
      'branch_name': instance.branchName,
      'working_balance': instance.workingBalance,
      'available_balance': instance.availableBalance,
      'locked_amount': instance.lockedAmount,
      'limit_amount': instance.limitAmount,
      'opened_date': instance.openedDate,
      'az_expried_date': instance.azExpriedDate,
      'az_init_rate': instance.azInitRate,
      'az_term': instance.azTerm,
      'az_product_code': instance.azProductCode,
      'contract_no': instance.contractNo,
      'customer_type': instance.customerType,
      'ac_status': instance.acStatus,
    };
