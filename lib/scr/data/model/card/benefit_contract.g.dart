// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefit_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BenefitContract _$BenefitContractFromJson(Map<String, dynamic> json) {
  return BenefitContract(
    json['main_contract'] as String?,
    json['contract_id'] as String?,
    json['contract_name'] as String?,
    json['is_credit'] as bool?,
    json['type'] as int?,
  );
}

Map<String, dynamic> _$BenefitContractToJson(BenefitContract instance) =>
    <String, dynamic>{
      'main_contract': instance.mainContract,
      'contract_id': instance.contractId,
      'contract_name': instance.contractName,
      'is_credit': instance.isCredit,
      'type': instance.type,
    };
