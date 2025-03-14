import 'package:json_annotation/json_annotation.dart';

part 'beneficiary_saved_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BeneficiarySavedModel {
  String? benName;
  String? benBankCode; //id ngan hang
  String? bankNapasId;
  String? benAccount;
  String? benCcy;
  String? benBankName;
  String? benBranch;
  String? benBranchName;
  String? benAlias;
  String? benCif;
  String? benCity;
  String? benCityName;
  bool? isAccountBenFromListSaved;

  BeneficiarySavedModel({
    this.benName,
    this.benBankCode,
    this.bankNapasId,
    this.benAccount,
    this.benCcy,
    this.benBankName,
    this.benBranch,
    this.benBranchName,
    this.benAlias,
    this.benCity,
    this.benCityName,
    this.benCif,
    this.isAccountBenFromListSaved = true,
  });

  factory BeneficiarySavedModel.fromJson(Map<String, dynamic> json) => _$BeneficiarySavedModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeneficiarySavedModelToJson(this);
}
