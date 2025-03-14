class SavingInitRequest {
  String? productId;
  String? secureId;
  double? amount;
  String? debitAccountNumber;
  String? termCode;
  String? mandustry;
  String? nominatedAccountNumber;
  String? introducerCif;
  String? promotionCode;
  String? contractNumber;
  String? startDate;
  String? endDate;
  String? rate;

  SavingInitRequest({
    this.productId,
    this.secureId,
    this.amount,
    this.debitAccountNumber,
    this.termCode,
    this.mandustry,
    this.nominatedAccountNumber,
    this.introducerCif,
    this.promotionCode,
    this.contractNumber,
    this.startDate,
    this.endDate,
    this.rate,
  });

  SavingInitRequest.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    secureId = json['secure_id']?.toString();
    amount = json['amount']?.toDouble();
    debitAccountNumber = json['debit_account_number']?.toString();
    termCode = json['term_code']?.toString();
    mandustry = json['mandustry']?.toString();
    nominatedAccountNumber = json['nominated_account_number']?.toString();
    introducerCif = json['introducer_cif']?.toString();
    promotionCode = json['promotion_code']?.toString();
    contractNumber = json['contract_number']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    rate = json['rate']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['secure_id'] = secureId;
    data['amount'] = amount;
    data['debit_account_number'] = debitAccountNumber;
    data['term_code'] = termCode;
    data['mandustry'] = mandustry;
    data['nominated_account_number'] = nominatedAccountNumber;
    data['introducer_cif'] = introducerCif;
    data['promotion_code'] = promotionCode;
    data['contract_number'] = contractNumber;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['rate'] = rate;
    return data;
  }
}
