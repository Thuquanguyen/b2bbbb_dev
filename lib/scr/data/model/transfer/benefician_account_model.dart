import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'benefician_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BeneficianAccountModel {
  BeneficianAccountModel(
      {this.accountCurrency,
      this.custCif,
      this.benBranchName,
      this.benBranch,
      this.benCity,
      this.benName,
      this.accountNumber,
      this.isAccountBenFromListSaved = false,
      this.benAlias});

  final String? accountCurrency;
  final String? custCif;
  final String? benBranchName;
  final String? benCity;
  final String? benName;
  final String? benBranch;
  final String? accountNumber;
  final bool isAccountBenFromListSaved;
  String? benAlias;

  factory BeneficianAccountModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficianAccountModelFromJson(json);

  Map<String, dynamic> toJSON() => _$BeneficianAccountModelToJson(this);

  String getSubTitle({String? value, bool? isCardNumber}) {
    if (value != null) {
      return value;
    }
    if (isCardNumber == true) {
      return '${AppTranslate.i18n.cardNumberStr.localized} $accountNumber';
    }
    return accountNumber ?? '';
  }

  BeneficianAccountModel clone() {
    return BeneficianAccountModel(
        accountCurrency: accountCurrency,
        custCif: custCif,
        benBranchName: benBranchName,
        benBranch: benBranch,
        benCity: benCity,
        benName: benName,
        isAccountBenFromListSaved: isAccountBenFromListSaved,
        benAlias: benAlias);
  }
}
