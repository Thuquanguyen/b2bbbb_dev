import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_term_saving_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ItemTermSavingModel {
  ItemTermSavingModel({
    this.intRate,
    this.ccy,
    this.termNameVi,
    this.termNameEn,
    this.maxAmt,
    this.minAmt,
    this.termCode,
  });

  final String? ccy, termNameVi, termNameEn, termCode;
  final num? intRate;
  @JsonKey(defaultValue: -1)
  double? maxAmt;

  @JsonKey(defaultValue: -1)
  double? minAmt;

  factory ItemTermSavingModel.fromJson(Map<String, dynamic> json) => _$ItemTermSavingModelFromJson(json);

  Map<String, dynamic> toJSON() => _$ItemTermSavingModelToJson(this);

  String getTermName() {
    return (AppTranslate().currentLanguage == SupportLanguages.Vi ? termNameVi : termNameEn) ?? '';
  }
}
