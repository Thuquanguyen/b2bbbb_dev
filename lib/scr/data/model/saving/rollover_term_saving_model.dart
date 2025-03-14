import 'package:b2b/scr/data/model/saving/item_term_saving_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rollover_term_saving_model.g.dart';



@JsonSerializable(fieldRename: FieldRename.snake)
class RolloverTermSavingModel {
  RolloverTermSavingModel(this.endOfPeriod, this.periodically, this.prepaid);

  final EndOfPeriod? endOfPeriod;
  final Periodically? periodically;
  final EndOfPeriod? prepaid;

  factory RolloverTermSavingModel.fromJson(Map<String, dynamic> json) => _$RolloverTermSavingModelFromJson(json);

  Map<String, dynamic> toJSON() => _$RolloverTermSavingModelToJson(this);
}

@JsonSerializable()
class EndOfPeriod {
  EndOfPeriod(this.data, this.desc);

  final List<ItemTermSavingModel?>? data;
  final String? desc;

  factory EndOfPeriod.fromJson(Map<String, dynamic> json) => _$EndOfPeriodFromJson(json);

  Map<String, dynamic> toJSON() => _$EndOfPeriodToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Periodically {
  Periodically(this.yearly, this.quarterly, this.every6Months, this.monthly, this.desc);

  final EndOfPeriod? yearly, quarterly, monthly;
  @JsonKey(name: 'every_6_months')
  final EndOfPeriod? every6Months;
  final String? desc;

  factory Periodically.fromJson(Map<String, dynamic> json) => _$PeriodicallyFromJson(json);

  Map<String, dynamic> toJSON() => _$PeriodicallyToJson(this);
}
