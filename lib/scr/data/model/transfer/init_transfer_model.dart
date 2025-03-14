import 'package:b2b/scr/data/model/name_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/language/app_translate.dart';

part 'init_transfer_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InitTransferModel {
  InitTransferModel(
      {this.transcode_old,
      this.debitExcrate,
      this.fkBeneficiaryId,
      this.custcif,
      this.debitAcc,
      this.debitName,
      this.debitBranch,
      this.debitBranchName,
      this.debitCityName,
      this.debitCcy,
      this.benAcc,
      this.benAccEncrypt,
      this.benBranch,
      this.benBranchName,
      this.benName,
      this.benAdd,
      this.benBankName,
      this.benBankCode,
      this.benBankAdd,
      this.interBankCode,
      this.benCcy,
      this.benCity,
      this.benCityName,
      this.amount,
      this.amountCcy,
      this.debitAmount,
      this.benExcrate,
      this.feeAmount,
      this.vatFeeAmount,
      this.vatAmount,
      this.totalAmount,
      this.ourBenFee,
      this.chargeAcc,
      this.chargeCcy,
      this.chargeAmount,
      this.valueDate,
      this.memo,
      this.fkTrantypeId,
      this.userCreated,
      this.sercureTrans,
      this.transcode,
      this.benBankNapasCode,
      this.amountSpell});

  final String? sercureTrans;
  final String? transcode;
  final String? transcode_old;
  final String? fkBeneficiaryId;
  final String? custcif;
  final String? debitAcc;
  final String? debitName;
  final String? debitBranch;
  final String? debitBranchName;
  final String? debitCityName;
  final String? debitCcy;
  final String? benAcc;
  final String? benAccEncrypt;
  final String? benBranch;
  final String? benBranchName;
  final String? benName;
  final String? benAdd;
  final String? benBankName;
  final String? benBankCode;
  final String? benBankAdd;
  final String? interBankCode;
  final String? benCcy;
  final String? benCity;
  final String? benCityName;
  final double? amount;
  final String? amountCcy;
  final double? debitAmount;
  final double? benExcrate;
  final double? debitExcrate;
  final double? feeAmount;
  final double? vatFeeAmount;
  final double? vatAmount;
  final double? totalAmount;
  final String? ourBenFee;
  final String? chargeAcc;
  final String? chargeCcy;
  final double? chargeAmount;
  final String? valueDate;
  final String? memo;
  final String? fkTrantypeId;
  final String? userCreated;
  final String? benBankNapasCode;
  final NameModel? amountSpell;

  factory InitTransferModel.fromJson(Map<String, dynamic> json) =>
      _$InitTransferModelFromJson(json);

  Map<String, dynamic> toJSON() => _$InitTransferModelToJson(this);

  String getDebitAccountSubtitle() {
    return debitAcc ?? '';
  }

  String getSubTitle({String? value, bool? isCardNumber}) {
    if (value != null) {
      return value;
    }
    if (isCardNumber == true) {
      return '${AppTranslate.i18n.cardNumberStr.localized} $benAcc';
    }
    return benAcc ?? '';
  }
}
