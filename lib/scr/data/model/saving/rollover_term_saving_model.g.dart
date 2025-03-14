// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rollover_term_saving_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolloverTermSavingModel _$RolloverTermSavingModelFromJson(
    Map<String, dynamic> json) {
  return RolloverTermSavingModel(
    json['end_of_period'] == null
        ? null
        : EndOfPeriod.fromJson(json['end_of_period'] as Map<String, dynamic>),
    json['periodically'] == null
        ? null
        : Periodically.fromJson(json['periodically'] as Map<String, dynamic>),
    json['prepaid'] == null
        ? null
        : EndOfPeriod.fromJson(json['prepaid'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RolloverTermSavingModelToJson(
        RolloverTermSavingModel instance) =>
    <String, dynamic>{
      'end_of_period': instance.endOfPeriod,
      'periodically': instance.periodically,
      'prepaid': instance.prepaid,
    };

EndOfPeriod _$EndOfPeriodFromJson(Map<String, dynamic> json) {
  return EndOfPeriod(
    (json['data'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : ItemTermSavingModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['desc'] as String?,
  );
}

Map<String, dynamic> _$EndOfPeriodToJson(EndOfPeriod instance) =>
    <String, dynamic>{
      'data': instance.data,
      'desc': instance.desc,
    };

Periodically _$PeriodicallyFromJson(Map<String, dynamic> json) {
  return Periodically(
    json['yearly'] == null
        ? null
        : EndOfPeriod.fromJson(json['yearly'] as Map<String, dynamic>),
    json['quarterly'] == null
        ? null
        : EndOfPeriod.fromJson(json['quarterly'] as Map<String, dynamic>),
    json['every_6_months'] == null
        ? null
        : EndOfPeriod.fromJson(json['every_6_months'] as Map<String, dynamic>),
    json['monthly'] == null
        ? null
        : EndOfPeriod.fromJson(json['monthly'] as Map<String, dynamic>),
    json['desc'] as String?,
  );
}

Map<String, dynamic> _$PeriodicallyToJson(Periodically instance) =>
    <String, dynamic>{
      'yearly': instance.yearly,
      'quarterly': instance.quarterly,
      'monthly': instance.monthly,
      'every_6_months': instance.every6Months,
      'desc': instance.desc,
    };
