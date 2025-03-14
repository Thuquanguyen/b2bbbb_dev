import 'package:b2b/scr/data/model/bill/bill_info.dart';
import 'package:b2b/scr/data/model/name_model.dart';

class InitBillResponse {
  String? transCode;
  String? sercureTrans;
  String? bankId;
  String? debitAccountNumber;
  String? debitAccountName;
  double? debitAmount;
  String? debitAccountCcy;
  String? beneficiaryName;
  double? amount;
  String? currency;
  String? memo;
  String? rejectCause;
  String? benBankName;
  String? benBankCode;
  String? benAccountName;
  String? benBranch;
  String? benBranchName;
  String? city;
  NameModel? amountInWords;
  double? exchangeRate;
  double? benExchangeRate;
  NameModel? charges;
  String? chargesAccount;
  double? chargesAmount;
  double? feeAmount;
  double? vatFeeAmount;
  String? feeAmountCcy;
  String? approver;
  String? dateApprover;
  String? createdBy;
  String? createdDate;
  String? outBenFee;
  String? benCcy;
  String? debitBranch;
  String? debitCcy;
  String? debitCity;
  String? chargesCcy;
  int? totalInhouse;
  int? totalOther;
  BillInfo? billInfo;

  InitBillResponse({
    this.transCode,
    this.bankId,
    this.debitAccountNumber,
    this.debitAccountName,
    this.debitAmount,
    this.debitAccountCcy,
    this.beneficiaryName,
    this.amount,
    this.currency,
    this.memo,
    this.rejectCause,
    this.benBankName,
    this.benBankCode,
    this.benAccountName,
    this.benBranch,
    this.benBranchName,
    this.city,
    this.amountInWords,
    this.exchangeRate,
    this.benExchangeRate,
    this.charges,
    this.chargesAccount,
    this.chargesAmount,
    this.feeAmount,
    this.vatFeeAmount,
    this.feeAmountCcy,
    this.approver,
    this.dateApprover,
    this.createdBy,
    this.createdDate,
    this.outBenFee,
    this.benCcy,
    this.debitBranch,
    this.debitCcy,
    this.debitCity,
    this.chargesCcy,
    this.totalInhouse,
    this.totalOther,
    this.billInfo,
    this.sercureTrans,
  });

  InitBillResponse.fromJson(Map<String, dynamic> json) {
    transCode = json['transcode']?.toString();
    sercureTrans = json['sercure_trans']?.toString();
    bankId = json['bank_id']?.toString();
    debitAccountNumber = json['debit_account_number']?.toString();
    debitAccountName = json['debit_account_name']?.toString();
    debitAmount = json['debit_amount']?.toDouble();
    debitAccountCcy = json['debit_account_ccy']?.toString();
    beneficiaryName = json['beneficiary_name']?.toString();
    amount = json['amount']?.toDouble();
    currency = json['currency']?.toString();
    memo = json['memo']?.toString();
    rejectCause = json['reject_cause']?.toString();
    benBankName = json['ben_bank_name']?.toString();
    benBankCode = json['ben_bank_code']?.toString();
    benAccountName = json['ben_account_name']?.toString();
    benBranch = json['ben_branch']?.toString();
    benBranchName = json['ben_branch_name']?.toString();
    city = json['city']?.toString();
    amountInWords = (json['amount_in_words'] != null)
        ? NameModel.fromJson(json['amount_in_words'])
        : null;
    exchangeRate = json['exchange_rate']?.toDouble();
    benExchangeRate = json['ben_exchange_rate']?.toDouble();
    charges =
        (json['charges'] != null) ? NameModel.fromJson(json['charges']) : null;
    chargesAccount = json['charges_account']?.toString();
    chargesAmount = json['charges_amount']?.toDouble();
    feeAmount = json['fee_amount']?.toDouble();
    vatFeeAmount = json['vat_fee_amount']?.toDouble();
    feeAmountCcy = json['fee_amount_ccy']?.toString();
    approver = json['approver']?.toString();
    dateApprover = json['date_approver']?.toString();
    createdBy = json['created_by']?.toString();
    createdDate = json['created_date']?.toString();
    outBenFee = json['out_ben_fee']?.toString();
    benCcy = json['ben_ccy']?.toString();
    debitBranch = json['debit_branch']?.toString();
    debitCcy = json['debit_ccy']?.toString();
    debitCity = json['debit_city']?.toString();
    chargesCcy = json['charges_ccy']?.toString();
    totalInhouse = json['total_inhouse']?.toInt();
    totalOther = json['total_other']?.toInt();
    billInfo = (json['bill_info'] != null)
        ? BillInfo.fromJson(json['bill_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trans_code'] = transCode;
    data['bank_id'] = bankId;
    data['debit_account_number'] = debitAccountNumber;
    data['debit_account_name'] = debitAccountName;
    data['debit_amount'] = debitAmount;
    data['debit_account_ccy'] = debitAccountCcy;
    data['beneficiary_name'] = beneficiaryName;
    data['amount'] = amount;
    data['currency'] = currency;
    data['memo'] = memo;
    data['reject_cause'] = rejectCause;

    data['ben_bank_name'] = benBankName;
    data['ben_bank_code'] = benBankCode;
    data['ben_account_name'] = benAccountName;
    data['ben_branch'] = benBranch;
    data['ben_branch_name'] = benBranchName;
    data['city'] = city;
    if (amountInWords != null) {
      data['amount_in_words'] = amountInWords!.toJson();
    }
    data['exchange_rate'] = exchangeRate;
    data['ben_exchange_rate'] = benExchangeRate;
    if (charges != null) {
      data['charges'] = charges!.toJson();
    }
    data['charges_account'] = chargesAccount;
    data['charges_amount'] = chargesAmount;
    data['fee_amount'] = feeAmount;
    data['vat_fee_amount'] = vatFeeAmount;
    data['fee_amount_ccy'] = feeAmountCcy;
    data['approver'] = approver;
    data['date_approver'] = dateApprover;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['out_ben_fee'] = outBenFee;
    data['ben_ccy'] = benCcy;
    data['debit_branch'] = debitBranch;
    data['debit_ccy'] = debitCcy;
    data['debit_city'] = debitCity;
    data['charges_ccy'] = chargesCcy;
    data['total_inhouse'] = totalInhouse;
    data['total_other'] = totalOther;
    if (billInfo != null) {
      data['bill_info'] = billInfo!.toJson();
    }
    return data;
  }
}
