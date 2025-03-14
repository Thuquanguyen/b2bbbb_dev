class CardContractInfo {
  String? contractNumber;
  String? contractName;
  String? contractRegNumber;
  String? addressLine1;
  int? contractLimit;
  int? contractBlocked;
  int? contractTotalBalance;
  int? contractAvail;
  String? dateOpen;
  String? cardType;
  String? name;
  String? contractCurrency;
  String? fbranch;
  int? minPaymentContract;
  int? fullPaymentContract;
  String? conlv1;

  CardContractInfo({
    this.contractNumber,
    this.contractName,
    this.contractRegNumber,
    this.addressLine1,
    this.contractLimit,
    this.contractBlocked,
    this.contractTotalBalance,
    this.contractAvail,
    this.dateOpen,
    this.cardType,
    this.name,
    this.contractCurrency,
    this.fbranch,
    this.minPaymentContract,
    this.fullPaymentContract,
    this.conlv1,
  });

  CardContractInfo.fromJson(Map<String, dynamic> json) {
    contractNumber = json['contract_number']?.toString();
    contractName = json['contract_name']?.toString();
    contractRegNumber = json['contract_reg_number']?.toString();
    addressLine1 = json['address_line1']?.toString();
    contractLimit = json['contract_limit']?.toInt();
    contractBlocked = json['contract_blocked']?.toInt();
    contractTotalBalance = json['contract_total_balance']?.toInt();
    contractAvail = json['contract_avail']?.toInt();
    dateOpen = json['date_open']?.toString();
    cardType = json['card_type']?.toString();
    name = json['name']?.toString();
    contractCurrency = json['contract_currency']?.toString();
    fbranch = json['fbranch']?.toString();
    minPaymentContract = json['min_payment_contract']?.toInt();
    fullPaymentContract = json['full_payment_contract']?.toInt();
    conlv1 = json['conlv1']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contract_number'] = contractNumber;
    data['contract_name'] = contractName;
    data['contract_reg_number'] = contractRegNumber;
    data['address_line1'] = addressLine1;
    data['contract_limit'] = contractLimit;
    data['contract_blocked'] = contractBlocked;
    data['contract_total_balance'] = contractTotalBalance;
    data['contract_avail'] = contractAvail;
    data['date_open'] = dateOpen;
    data['card_type'] = cardType;
    data['name'] = name;
    data['contract_currency'] = contractCurrency;
    data['fbranch'] = fbranch;
    data['min_payment_contract'] = minPaymentContract;
    data['full_payment_contract'] = fullPaymentContract;
    data['conlv1'] = conlv1;
    return data;
  }
}
