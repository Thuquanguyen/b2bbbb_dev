import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/utilities/logger.dart';

class InitDepositsResult {
  String? sercureTrans;
  String? transCode;
  String? productType;
  String? custcif;
  String? debitAccountNumber;
  String? debitAccountName;
  String? debitBranch;
  String? debitCity;
  String? debitCcy;
  double? amount;
  String? amountCcy;
  String? term;
  String? startDate;
  String? endDate;
  String? rate;
  String? demandRate;
  String? mandustry;
  String? nominatedacc;
  String? userCreate;
  String? createdDate;
  String? status;
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
  NameModel? amountSpell;
  String? ceilingRate;
  String? rateTotal;

  InitDepositsResult({
    this.sercureTrans,
    this.transCode,
    this.productType,
    this.custcif,
    this.debitAccountNumber,
    this.debitAccountName,
    this.debitBranch,
    this.debitCity,
    this.debitCcy,
    this.amount,
    this.amountCcy,
    this.term,
    this.startDate,
    this.endDate,
    this.rate,
    this.demandRate,
    this.mandustry,
    this.nominatedacc,
    this.userCreate,
    this.createdDate,
    this.status,
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
    this.amountSpell,
    this.ceilingRate,
    this.rateTotal,
  });

  InitDepositsResult.fromJson(Map<String, dynamic> json) {
    sercureTrans = json['sercure_trans']?.toString();
    transCode = json['trans_code']?.toString();
    productType = json['product_type']?.toString();
    custcif = json['custcif']?.toString();
    debitAccountNumber = json['debit_account_number']?.toString();
    debitAccountName = json['debit_account_name']?.toString();
    debitBranch = json['debit_branch']?.toString();
    debitCity = json['debit_city']?.toString();
    debitCcy = json['debit_ccy']?.toString();
    amount = json['amount']?.toDouble();
    amountCcy = json['amount_ccy']?.toString();
    term = json['term']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    rate = json['rate']?.toString();
    demandRate = json['demand_rate']?.toString();
    mandustry = json['mandustry']?.toString();
    nominatedacc = json['nominatedacc']?.toString();
    userCreate = json['user_create']?.toString();
    createdDate = json['created_date']?.toString();
    status = json['status']?.toString();
    apprUser = json['appr_user']?.toString();
    apprDate = json['appr_date']?.toString();
    apprComment = json['appr_comment']?.toString();
    bankId = json['bank_id']?.toString();
    valueDate = json['value_date']?.toString();
    productCategory = json['product_category']?.toString();
    allInOneProduct = json['all_in_one_product']?.toString();
    introducerCif = json['introducer_cif']?.toString();
    contractNumber = json['contract_number']?.toString();
    isPayIntAtMat = json['is_pay_int_at_mat']?.toString();
    fkProductId = json['fk_product_id']?.toString();
    pdGroupCode = json['pd_group_code']?.toString();
    ctsp = json['ctsp']?.toString();
    voucherCode = json['voucher_code']?.toString();
    voucherRate = json['voucher_rate']?.toString();

    ceilingRate = json['ceiling_rate']?.toString();
    rateTotal = json['rate_total']?.toString();
    amountSpell = NameModel.fromJson(json['amount_spell']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sercure_trans'] = sercureTrans;
    data['trans_code'] = transCode;
    data['product_type'] = productType;
    data['custcif'] = custcif;
    data['debit_account_number'] = debitAccountNumber;
    data['debit_account_name'] = debitAccountName;
    data['debit_branch'] = debitBranch;
    data['debit_city'] = debitCity;
    data['debit_ccy'] = debitCcy;
    data['amount'] = amount;
    data['amount_ccy'] = amountCcy;
    data['term'] = term;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['rate'] = rate;
    data['demand_rate'] = demandRate;
    data['mandustry'] = mandustry;
    data['nominatedacc'] = nominatedacc;
    data['user_create'] = userCreate;
    data['created_date'] = createdDate;
    data['status'] = status;
    data['appr_user'] = apprUser;
    data['appr_date'] = apprDate;
    data['appr_comment'] = apprComment;
    data['bank_id'] = bankId;
    data['value_date'] = valueDate;
    data['product_category'] = productCategory;
    data['all_in_one_product'] = allInOneProduct;
    data['introducer_cif'] = introducerCif;
    data['contract_number'] = contractNumber;
    data['is_pay_int_at_mat'] = isPayIntAtMat;
    data['fk_product_id'] = fkProductId;
    data['pd_group_code'] = pdGroupCode;
    data['ctsp'] = ctsp;
    data['voucher_code'] = voucherCode;
    data['ceiling_rate'] = ceilingRate;
    data['rate_total'] = rateTotal;
    data['amount_spell'] = amountSpell?.toJson();
    return data;
  }

  String getRate() {
    if (rate.isNullOrEmpty) {
      return '';
    }
    return AppTranslate.i18n.yearStr.localized.interpolate({'value': rate});
  }

  String getVoucherRate() {
    Logger.debug('getVoucherRate $voucherRate');

    if (voucherRate.isNullOrEmpty) {
      return '';
    }
    return AppTranslate.i18n.yearStr.localized
        .interpolate({'value': voucherRate});
  }

  String getRateTotal() {
    if (rateTotal.isNullOrEmpty) {
      return '';
    }
    return AppTranslate.i18n.yearStr.localized
        .interpolate({'value': rateTotal});
  }

  bool isShowNoticeCellingRate() {
    if (ceilingRate.isNullOrEmpty) {
      return false;
    }
    try {
      String ceilingRateStr = ceilingRate.isNullOrEmpty ? '0' : ceilingRate!;
      String rateStr = rate.isNullOrEmpty ? '0' : rate!;
      String voucherRateStr = voucherRate.isNullOrEmpty ? '0' : voucherRate!;

      Logger.debug(ceilingRateStr);
      Logger.debug(rateStr);
      Logger.debug(voucherRateStr);

      double mCeilingRate = double.parse(ceilingRateStr);
      double mRate = double.parse(rateStr);
      double mVoucherRate = double.parse(voucherRateStr);

      Logger.debug(
          'isShowNoticeCellingRate ${mCeilingRate < mRate + mVoucherRate}');

      if (mCeilingRate < mRate + mVoucherRate) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger.error('isShowNoticeCellingRate Error $e');
      return false;
    }
  }
}
