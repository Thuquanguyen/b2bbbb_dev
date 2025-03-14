// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefician_account_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeneficianAccountRequestModel _$BeneficianAccountRequestModelFromJson(
    Map<String, dynamic> json) {
  return BeneficianAccountRequestModel(
    accountNumber: json['account_number'] as String?,
    branch: json['branch'] as String?,
    branchName: json['branch_name'] as String?,
    city: json['city'] as String?,
    cityName: json['city_name'] as String?,
    address: json['address'] as String?,
    accountAlias: json['account_alias'] as String?,
    accountName: json['account_name'] as String?,
    currency: json['currency'] as String?,
    addBen: json['add_ben'] as bool,
    bankCode: json['bank_code'] as String?,
  );
}

Map<String, dynamic> _$BeneficianAccountRequestModelToJson(
        BeneficianAccountRequestModel instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'branch': instance.branch,
      'branch_name': instance.branchName,
      'city': instance.city,
      'city_name': instance.cityName,
      'address': instance.address,
      'account_alias': instance.accountAlias,
      'account_name': instance.accountName,
      'currency': instance.currency,
      'add_ben': instance.addBen,
      'bank_code': instance.bankCode,
    };
