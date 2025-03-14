// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary_saved_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeneficiarySavedModel _$BeneficiarySavedModelFromJson(
    Map<String, dynamic> json) {
  return BeneficiarySavedModel(
    benName: json['ben_name'] as String?,
    benBankCode: json['ben_bank_code'] as String?,
    bankNapasId: json['bank_napas_id'] as String?,
    benAccount: json['ben_account'] as String?,
    benCcy: json['ben_ccy'] as String?,
    benBankName: json['ben_bank_name'] as String?,
    benBranch: json['ben_branch'] as String?,
    benBranchName: json['ben_branch_name'] as String?,
    benAlias: json['ben_alias'] as String?,
    benCity: json['ben_city'] as String?,
    benCityName: json['ben_city_name'] as String?,
    benCif: json['ben_cif'] as String?,
    isAccountBenFromListSaved: json['is_account_ben_from_list_saved'] as bool?,
  );
}

Map<String, dynamic> _$BeneficiarySavedModelToJson(
        BeneficiarySavedModel instance) =>
    <String, dynamic>{
      'ben_name': instance.benName,
      'ben_bank_code': instance.benBankCode,
      'bank_napas_id': instance.bankNapasId,
      'ben_account': instance.benAccount,
      'ben_ccy': instance.benCcy,
      'ben_bank_name': instance.benBankName,
      'ben_branch': instance.benBranch,
      'ben_branch_name': instance.benBranchName,
      'ben_alias': instance.benAlias,
      'ben_cif': instance.benCif,
      'ben_city': instance.benCity,
      'ben_city_name': instance.benCityName,
      'is_account_ben_from_list_saved': instance.isAccountBenFromListSaved,
    };
