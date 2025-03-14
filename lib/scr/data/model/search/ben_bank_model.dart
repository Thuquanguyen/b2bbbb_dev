import 'package:json_annotation/json_annotation.dart';

part 'ben_bank_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BenBankModel {
  final String? bankNo;
  final String? shortName;
  final String? fullName;
  final bool? isNapas;
  final String? bankNapasId;

  const BenBankModel({this.bankNo, this.shortName, this.fullName, this.isNapas, this.bankNapasId});

  factory BenBankModel.fromJson(Map<String, dynamic> json) => _$BenBankModelFromJson(json);

  Map<String, dynamic> toJson() => _$BenBankModelToJson(this);

  String getLogo() {
    return "assets/icons/bank_logo/ic_bank_$bankNo.png";
  }
}
