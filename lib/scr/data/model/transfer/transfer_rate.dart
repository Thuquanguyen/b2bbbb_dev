class TransferRate {
  String? rateType;
  String? amountCcy;
  double? buyRate;
  double? sellRate;
  double? midRate;

  TransferRate({
    this.rateType,
    this.amountCcy,
    this.buyRate,
    this.sellRate,
    this.midRate,
  });

  TransferRate.fromJson(Map<String, dynamic> json) {
    rateType = json['rate_type']?.toString();
    amountCcy = json['amount_ccy']?.toString();
    buyRate = json['buy_rate']?.toDouble();
    sellRate = json['sell_rate']?.toDouble();
    midRate = json['mid_rate']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rate_type'] = rateType;
    data['amount_ccy'] = amountCcy;
    data['buy_rate'] = buyRate;
    data['sell_rate'] = sellRate;
    data['mid_rate'] = midRate;
    return data;
  }
}
