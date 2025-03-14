import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'benefician_account_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BeneficianAccountRequestModel {
  BeneficianAccountRequestModel({
    this.accountNumber,
    this.branch,
    this.branchName,
    this.city,
    this.cityName,
    this.address,
    this.accountAlias,
    this.accountName,
    this.currency,
    required this.addBen,
    this.bankCode,
  });

  final String? accountNumber;
  final String? branch;
  final String? branchName;
  final String? city;
  final String? cityName;
  final String? address;
  final String? accountAlias;
  final String? accountName;
  final String? currency;
  final bool addBen;
  final String? bankCode; // bank napas Id

  factory BeneficianAccountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficianAccountRequestModelFromJson(json);

  factory BeneficianAccountRequestModel.fromAccountBeneficianModel(
      BeneficianAccountModel detailBeneficianAccount,
      bool addBen,
      String? alias,
      {String? bankCode,
      String? city,
      String? branch,
      String? accountName,
      String? accountNumber,
      String? cityName,
      String? branchName,
      String? benCcy}) {
    //print("ACCOUNT NUMBER : $accountNumber - $bankCode");
    return BeneficianAccountRequestModel(
        addBen: addBen,
        accountName: (accountName == null)
            ? detailBeneficianAccount.benName
            : accountName,
        accountNumber: (accountNumber == null)
            ? detailBeneficianAccount.accountNumber
            : accountNumber,
        accountAlias: addBen ? alias : null,
        branch: branch,
        city: city,
        currency: benCcy ?? detailBeneficianAccount.accountCurrency ?? 'VND',
        bankCode: bankCode,
        cityName: cityName,
        branchName: branchName);
  }

  Map<String, dynamic> toJSON() => _$BeneficianAccountRequestModelToJson(this);
}
