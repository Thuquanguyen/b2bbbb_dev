class NegotiatingModel {
  String? contractNo;
  double? amount;
  String? currency;
  String? discountDate;
  String? maturityDate;
  double? outsAmt;
  String? rate;
  double? principleDueAmount;
  String? principleDueDate;
  double? intDueAmount;
  String? intDueDate;
  double? totalAmount;
  String? nextDueDate;

  NegotiatingModel({
    this.contractNo,
    this.amount,
    this.currency,
    this.discountDate,
    this.maturityDate,
    this.outsAmt,
    this.rate,
    this.principleDueAmount,
    this.principleDueDate,
    this.intDueAmount,
    this.intDueDate,
    this.totalAmount,
    this.nextDueDate,
  });

  NegotiatingModel.fromJson(Map<String, dynamic> json) {
    contractNo = json['contract_no']?.toString();
    amount = json['amount']?.toDouble();
    currency = json['currency']?.toString();
    discountDate = json['discount_date']?.toString();
    maturityDate = json['maturity_date']?.toString();
    outsAmt = json['outs_amt']?.toDouble();
    rate = json['rate']?.toString();
    principleDueAmount = json['principle_due_amount']?.toDouble();
    principleDueDate = json['principle_due_date']?.toString();
    intDueAmount = json['int_due_amount']?.toDouble();
    intDueDate = json['int_due_date']?.toString();
    totalAmount = json['total_amount']?.toDouble();
    nextDueDate = json['next_due_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contract_no'] = contractNo;
    data['amount'] = amount;
    data['currency'] = currency;
    data['discount_date'] = discountDate;
    data['maturity_date'] = maturityDate;
    data['outs_amt'] = outsAmt;
    data['rate'] = rate;
    data['principle_due_amount'] = principleDueAmount;
    data['principle_due_date'] = principleDueDate;
    data['int_due_amount'] = intDueAmount;
    data['int_due_date'] = intDueDate;
    data['total_amount'] = totalAmount;
    data['next_due_date'] = nextDueDate;
    return data;
  }
}
