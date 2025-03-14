class GuaranteeModel {
  String? type;
  String? contractNo;
  String? guaranteeId;
  String? releaseDate;
  String? maturityDate;
  double? guaranteeAmt;
  String? currency;
  String? branchName;
  String? beneficiaryName;

  GuaranteeModel({
    this.type,
    this.contractNo,
    this.guaranteeId,
    this.releaseDate,
    this.maturityDate,
    this.guaranteeAmt,
    this.currency,
    this.branchName,
    this.beneficiaryName,
  });

  GuaranteeModel.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    contractNo = json['contract_no']?.toString();
    guaranteeId = json['guarantee_id']?.toString();
    releaseDate = json['release_date']?.toString();
    maturityDate = json['maturity_date']?.toString();
    guaranteeAmt = json['guarantee_amt']?.toDouble();
    currency = json['currency']?.toString();
    branchName = json['branch_name']?.toString();
    beneficiaryName = json['beneficiary_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['contract_no'] = contractNo;
    data['guarantee_id'] = guaranteeId;
    data['release_date'] = releaseDate;
    data['maturity_date'] = maturityDate;
    data['guarantee_amt'] = guaranteeAmt;
    data['currency'] = currency;
    data['branch_name'] = branchName;
    data['beneficiary_name'] = beneficiaryName;
    return data;
  }
}
