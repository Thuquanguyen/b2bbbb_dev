import 'package:b2b/scr/data/model/name_model.dart';

class LoanListModel {
  String? contractNumber;
  String? accountCurrency;
  double? currentOutstanding;
  double? thisPeriodPrincipleAmount;
  double? thisPeriodInterestAmount;
  String? nextPayInterestDate;
  String? nextPayPrincipleDate;
  String? coCode;
  String? coName;
  NameModel? term;
  int? lendingAmount;
  String? lendingDate;
  String? maturityDate;
  String? contractType;
  NameModel? contractTypeDisplay;
  String? rate;
  int? approvalMoney;
  int? inAmt;
  int? prAmt;
  int? intPenalty;
  int? totalOvd;

  LoanListModel({
    this.contractNumber,
    this.accountCurrency,
    this.currentOutstanding,
    this.thisPeriodPrincipleAmount,
    this.thisPeriodInterestAmount,
    this.nextPayInterestDate,
    this.nextPayPrincipleDate,
    this.coCode,
    this.coName,
    this.term,
    this.lendingAmount,
    this.lendingDate,
    this.maturityDate,
    this.contractType,
    this.contractTypeDisplay,
    this.rate,
    this.approvalMoney,
    this.inAmt,
    this.prAmt,
    this.intPenalty,
    this.totalOvd,
  });

  LoanListModel.fromJson(Map<String, dynamic> json) {
    contractNumber = json['contract_number']?.toString();
    accountCurrency = json['account_currency']?.toString();
    currentOutstanding = json['current_outstanding']?.toDouble();
    thisPeriodPrincipleAmount =
        json['this_period_principle_amount']?.toDouble();
    thisPeriodInterestAmount = json['this_period_interest_amount']?.toDouble();
    nextPayInterestDate = json['next_pay_interest_date']?.toString();
    nextPayPrincipleDate = json['next_pay_principle_date']?.toString();
    coCode = json['co_code']?.toString();
    coName = json['co_name']?.toString();
    term = contractTypeDisplay = (json['term_display'] != null)
        ? NameModel.fromJson(json['term_display'])
        : null;
    lendingAmount = json['lending_amount']?.toInt();
    lendingDate = json['lending_date']?.toString();
    maturityDate = json['maturity_date']?.toString();
    contractType = json['contract_type']?.toString();
    contractTypeDisplay = (json['contract_type_display'] != null)
        ? NameModel.fromJson(json['contract_type_display'])
        : null;
    rate = json['rate']?.toString();
    approvalMoney = json['approval_money']?.toInt();
    inAmt = json['in_amt']?.toInt();
    prAmt = json['pr_amt']?.toInt();
    intPenalty = json['int_penalty']?.toInt();
    totalOvd = json['total_ovd']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contract_number'] = contractNumber;
    data['account_currency'] = accountCurrency;
    data['current_outstanding'] = currentOutstanding;
    data['this_period_principle_amount'] = thisPeriodPrincipleAmount;
    data['this_period_interest_amount'] = thisPeriodInterestAmount;
    data['next_pay_interest_date'] = nextPayInterestDate;
    data['next_pay_principle_date'] = nextPayPrincipleDate;
    data['co_code'] = coCode;
    data['co_name'] = coName;
    data['term'] = term;
    data['lending_amount'] = lendingAmount;
    data['lending_date'] = lendingDate;
    data['maturity_date'] = maturityDate;
    data['contract_type'] = contractType;
    if (contractTypeDisplay != null) {
      data['contract_type_display'] = contractTypeDisplay!.toJson();
    }
    data['rate'] = rate;
    data['approval_money'] = approvalMoney;
    data['in_amt'] = inAmt;
    data['pr_amt'] = prAmt;
    data['int_penalty'] = intPenalty;
    data['total_ovd'] = totalOvd;
    return data;
  }

  double? getTotalAmountDueDate() {
    return (thisPeriodPrincipleAmount ?? 0) + (thisPeriodInterestAmount ?? 0);
  }
}
