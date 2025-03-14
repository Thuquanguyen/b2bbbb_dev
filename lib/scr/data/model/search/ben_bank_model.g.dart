// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ben_bank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BenBankModel _$BenBankModelFromJson(Map<String, dynamic> json) {
  return BenBankModel(
    bankNo: json['bank_no'] as String?,
    shortName: json['short_name'] as String?,
    fullName: json['full_name'] as String?,
    isNapas: json['is_napas'] as bool?,
    bankNapasId: json['bank_napas_id'] as String?,
  );
}

Map<String, dynamic> _$BenBankModelToJson(BenBankModel instance) =>
    <String, dynamic>{
      'bank_no': instance.bankNo,
      'short_name': instance.shortName,
      'full_name': instance.fullName,
      'is_napas': instance.isNapas,
      'bank_napas_id': instance.bankNapasId,
    };
