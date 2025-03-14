import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saving_transaction_model.g.dart';

enum SavingProductType {
  AZ,
  CLOSEAZ,
}

extension Name on SavingProductType {
  String? get localizedName {
    if (this == SavingProductType.AZ) {
      return AppTranslate.i18n.savProdTypeAzStr.localized;
    }

    if (this == SavingProductType.CLOSEAZ) {
      return AppTranslate.i18n.savProdTypeCloseazStr.localized;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionSavingModel extends TransactionBaseModel {
  String? sercureTrans;
  String? secureId;
  String? productType;
  String? custcif;
  String? debitBranch;
  String? debitBranchName;
  String? debitCity;
  String? debitCityName;
  String? debitCcy;
  String? amountCcy;
  String? term;
  NameModel? termDisplay;
  NameModel? status;
  NameModel? amountSpell;
  String? startDate;
  String? endDate;
  String? rate;
  String? ceilingRate;
  String? rateTotal;
  String? demandRate;
  String? mandustry;
  NameModel? mandustryDisplay;
  NameModel? productName;
  String? nominatedacc;
  String? userCreate;
  String? amndStatus;
  String? apprUser;
  String? apprDate;
  String? apprComment;
  String? bankId;
  String? valueDate;
  String? productCategory;
  String? allInOneProduct;
  String? introducerCif;
  String? contractNumber;
  String? isPayIntAtMat;
  String? fkProductId;
  String? pdGroupCode;
  String? ctsp;
  String? voucherCode;
  String? voucherRate;

  TransactionSavingModel({
    this.sercureTrans,
    this.secureId,
    this.productType,
    this.custcif,
    this.debitBranch,
    this.debitBranchName,
    this.debitCity,
    this.debitCityName,
    this.debitCcy,
    this.amountCcy,
    this.term,
    this.termDisplay,
    this.status,
    this.amountSpell,
    this.startDate,
    this.endDate,
    this.rate,
    this.ceilingRate,
    this.rateTotal,
    this.demandRate,
    this.mandustry,
    this.mandustryDisplay,
    this.productName,
    this.nominatedacc,
    this.userCreate,
    this.amndStatus,
    this.apprUser,
    this.apprDate,
    this.apprComment,
    this.bankId,
    this.valueDate,
    this.productCategory,
    this.allInOneProduct,
    this.introducerCif,
    this.contractNumber,
    this.isPayIntAtMat,
    this.fkProductId,
    this.pdGroupCode,
    this.ctsp,
    this.voucherCode,
    this.voucherRate,
  });

  factory TransactionSavingModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionSavingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionSavingModelToJson(this);

  SavingProductType? get getProductType {
    if (productType?.toLowerCase() == 'az') {
      return SavingProductType.AZ;
    }
    if (productType?.toLowerCase() == 'closeaz') {
      return SavingProductType.CLOSEAZ;
    }

    return null;
  }
}
