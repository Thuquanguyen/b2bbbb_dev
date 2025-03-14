// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefician_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeneficianAccountModel _$BeneficianAccountModelFromJson(
    Map<String, dynamic> json) {
  return BeneficianAccountModel(
    accountCurrency: json['account_currency'] as String?,
    custCif: json['cust_cif'] as String?,
    benBranchName: json['ben_branch_name'] as String?,
    benBranch: json['ben_branch'] as String?,
    benCity: json['ben_city'] as String?,
    benName: json['ben_name'] as String?,
    accountNumber: json['account_number'] as String?,
    isAccountBenFromListSaved: json['is_account_ben_from_list_saved'] as bool,
    benAlias: json['ben_alias'] as String?,
  );
}

Map<String, dynamic> _$BeneficianAccountModelToJson(
        BeneficianAccountModel instance) =>
    <String, dynamic>{
      'account_currency': instance.accountCurrency,
      'cust_cif': instance.custCif,
      'ben_branch_name': instance.benBranchName,
      'ben_city': instance.benCity,
      'ben_name': instance.benName,
      'ben_branch': instance.benBranch,
      'account_number': instance.accountNumber,
      'is_account_ben_from_list_saved': instance.isAccountBenFromListSaved,
      'ben_alias': instance.benAlias,
    };
