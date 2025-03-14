// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSavingModel _$TransactionSavingModelFromJson(
    Map<String, dynamic> json) {
  return TransactionSavingModel(
    sercureTrans: json['sercure_trans'] as String?,
    secureId: json['secure_id'] as String?,
    productType: json['product_type'] as String?,
    custcif: json['custcif'] as String?,
    debitBranch: json['debit_branch'] as String?,
    debitBranchName: json['debit_branch_name'] as String?,
    debitCity: json['debit_city'] as String?,
    debitCityName: json['debit_city_name'] as String?,
    debitCcy: json['debit_ccy'] as String?,
    amountCcy: json['amount_ccy'] as String?,
    term: json['term'] as String?,
    termDisplay: json['term_display'] == null
        ? null
        : NameModel.fromJson(json['term_display'] as Map<String, dynamic>),
    status: json['status'] == null
        ? null
        : NameModel.fromJson(json['status'] as Map<String, dynamic>),
    amountSpell: json['amount_spell'] == null
        ? null
        : NameModel.fromJson(json['amount_spell'] as Map<String, dynamic>),
    startDate: json['start_date'] as String?,
    endDate: json['end_date'] as String?,
    rate: json['rate'] as String?,
    ceilingRate: json['ceiling_rate'] as String?,
    rateTotal: json['rate_total'] as String?,
    demandRate: json['demand_rate'] as String?,
    mandustry: json['mandustry'] as String?,
    mandustryDisplay: json['mandustry_display'] == null
        ? null
        : NameModel.fromJson(json['mandustry_display'] as Map<String, dynamic>),
    productName: json['product_name'] == null
        ? null
        : NameModel.fromJson(json['product_name'] as Map<String, dynamic>),
    nominatedacc: json['nominatedacc'] as String?,
    userCreate: json['user_create'] as String?,
    amndStatus: json['amnd_status'] as String?,
    apprUser: json['appr_user'] as String?,
    apprDate: json['appr_date'] as String?,
    apprComment: json['appr_comment'] as String?,
    bankId: json['bank_id'] as String?,
    valueDate: json['value_date'] as String?,
    productCategory: json['product_category'] as String?,
    allInOneProduct: json['all_in_one_product'] as String?,
    introducerCif: json['introducer_cif'] as String?,
    contractNumber: json['contract_number'] as String?,
    isPayIntAtMat: json['is_pay_int_at_mat'] as String?,
    fkProductId: json['fk_product_id'] as String?,
    pdGroupCode: json['pd_group_code'] as String?,
    ctsp: json['ctsp'] as String?,
    voucherCode: json['voucher_code'] as String?,
    voucherRate: json['voucher_rate'] as String?,
  )
    ..transCode = json['trans_code'] as String?
    ..debitAccountNumber = json['debit_account_number'] as String?
    ..debitAccountName = json['debit_account_name'] as String?
    ..amount = (json['amount'] as num?)?.toDouble()
    ..createdDate = json['created_date'] as String?
    ..memo = json['memo'] as String?;
}

Map<String, dynamic> _$TransactionSavingModelToJson(
        TransactionSavingModel instance) =>
    <String, dynamic>{
      'trans_code': instance.transCode,
      'debit_account_number': instance.debitAccountNumber,
      'debit_account_name': instance.debitAccountName,
      'amount': instance.amount,
      'created_date': instance.createdDate,
      'memo': instance.memo,
      'sercure_trans': instance.sercureTrans,
      'secure_id': instance.secureId,
      'product_type': instance.productType,
      'custcif': instance.custcif,
      'debit_branch': instance.debitBranch,
      'debit_branch_name': instance.debitBranchName,
      'debit_city': instance.debitCity,
      'debit_city_name': instance.debitCityName,
      'debit_ccy': instance.debitCcy,
      'amount_ccy': instance.amountCcy,
      'term': instance.term,
      'term_display': instance.termDisplay,
      'status': instance.status,
      'amount_spell': instance.amountSpell,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'rate': instance.rate,
      'ceiling_rate': instance.ceilingRate,
      'rate_total': instance.rateTotal,
      'demand_rate': instance.demandRate,
      'mandustry': instance.mandustry,
      'mandustry_display': instance.mandustryDisplay,
      'product_name': instance.productName,
      'nominatedacc': instance.nominatedacc,
      'user_create': instance.userCreate,
      'amnd_status': instance.amndStatus,
      'appr_user': instance.apprUser,
      'appr_date': instance.apprDate,
      'appr_comment': instance.apprComment,
      'bank_id': instance.bankId,
      'value_date': instance.valueDate,
      'product_category': instance.productCategory,
      'all_in_one_product': instance.allInOneProduct,
      'introducer_cif': instance.introducerCif,
      'contract_number': instance.contractNumber,
      'is_pay_int_at_mat': instance.isPayIntAtMat,
      'fk_product_id': instance.fkProductId,
      'pd_group_code': instance.pdGroupCode,
      'ctsp': instance.ctsp,
      'voucher_code': instance.voucherCode,
      'voucher_rate': instance.voucherRate,
    };
