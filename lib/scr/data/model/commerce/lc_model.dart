class LcModel {
  String? refNo;
  String? type;
  double? value;
  String? currency;
  String? releaseDate;
  String? expirationDate;
  double? paidamt;
  double? residualValue;
  String? applicationName;
  String? beneficiary;
  String? branch;

  LcModel({
    this.refNo,
    this.type,
    this.value,
    this.currency,
    this.releaseDate,
    this.expirationDate,
    this.paidamt,
    this.residualValue,
    this.applicationName,
    this.beneficiary,
    this.branch,
  });

  LcModel.fromJson(Map<String, dynamic> json) {
    refNo = json['ref_no']?.toString();
    type = json['type']?.toString();
    value = json['value']?.toDouble();
    currency = json['currency']?.toString();
    releaseDate = json['release_date']?.toString();
    expirationDate = json['expiration_date']?.toString();
    paidamt = json['paidamt']?.toDouble();
    residualValue = json['residual_value']?.toDouble();
    applicationName = json['application_name']?.toString();
    beneficiary = json['beneficiary']?.toString();
    branch = json['branch']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ref_no'] = refNo;
    data['type'] = type;
    data['value'] = value;
    data['currency'] = currency;
    data['release_date'] = releaseDate;
    data['expiration_date'] = expirationDate;
    data['paidamt'] = paidamt;
    data['residual_value'] = residualValue;
    data['application_name'] = applicationName;
    data['beneficiary'] = beneficiary;
    data['branch'] = branch;
    return data;
  }
}
