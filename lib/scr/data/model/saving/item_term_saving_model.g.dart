// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_term_saving_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemTermSavingModel _$ItemTermSavingModelFromJson(Map<String, dynamic> json) {
  return ItemTermSavingModel(
    intRate: json['int_rate'] as num?,
    ccy: json['ccy'] as String?,
    termNameVi: json['term_name_vi'] as String?,
    termNameEn: json['term_name_en'] as String?,
    maxAmt: (json['max_amt'] as num?)?.toDouble() ?? -1,
    minAmt: (json['min_amt'] as num?)?.toDouble() ?? -1,
    termCode: json['term_code'] as String?,
  );
}

Map<String, dynamic> _$ItemTermSavingModelToJson(
        ItemTermSavingModel instance) =>
    <String, dynamic>{
      'ccy': instance.ccy,
      'term_name_vi': instance.termNameVi,
      'term_name_en': instance.termNameEn,
      'term_code': instance.termCode,
      'int_rate': instance.intRate,
      'max_amt': instance.maxAmt,
      'min_amt': instance.minAmt,
    };
