class AmountInfo {
  AmountInfo({required this.amount, required this.currency});

  double amount;
  String currency; // đơn vị . VND, USD
  // String memo;

  Map<String, dynamic> toJSON() => {
        'amount': this.amount,
        'currency': this.currency,
      };
}
