import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExchangeRateModel {
  final List<ExchangeRate>? dataRate;
  final String? updateTime;

  ExchangeRateModel({this.dataRate, this.updateTime});

  ExchangeRateModel copyWith({
    dataRate,
    updateTime,
  }) {
    return ExchangeRateModel(
      dataRate: dataRate ?? this.dataRate,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  Map<String, dynamic> toJSON() => _$ExchangeRateModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExchangeRate {
  final String? code;
  final String? fullName;
  final double? middle;
  final double? buy;
  final double? sell;

  ExchangeRate({
    this.code,
    this.fullName,
    this.middle,
    this.buy,
    this.sell,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);

  Map<String, dynamic> toJSON() => _$ExchangeRateToJson(this);
}
