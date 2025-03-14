// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateModel _$ExchangeRateModelFromJson(Map<String, dynamic> json) {
  return ExchangeRateModel(
    dataRate: (json['data_rate'] as List<dynamic>?)
        ?.map((e) => ExchangeRate.fromJson(e as Map<String, dynamic>))
        .toList(),
    updateTime: json['update_time'] as String?,
  );
}

Map<String, dynamic> _$ExchangeRateModelToJson(ExchangeRateModel instance) =>
    <String, dynamic>{
      'data_rate': instance.dataRate,
      'update_time': instance.updateTime,
    };

ExchangeRate _$ExchangeRateFromJson(Map<String, dynamic> json) {
  return ExchangeRate(
    code: json['code'] as String?,
    fullName: json['full_name'] as String?,
    middle: (json['middle'] as num?)?.toDouble(),
    buy: (json['buy'] as num?)?.toDouble(),
    sell: (json['sell'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$ExchangeRateToJson(ExchangeRate instance) =>
    <String, dynamic>{
      'code': instance.code,
      'full_name': instance.fullName,
      'middle': instance.middle,
      'buy': instance.buy,
      'sell': instance.sell,
    };
