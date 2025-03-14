class BillInitRequestData {
  String? serviceCode;
  String? providerCode;
  String? customerCode;
  List<String?>? listOrder;
  String? debitAccount;
  bool? saveBill;
  String? billAlias;
  double? totalAmount;

  BillInitRequestData({
    this.serviceCode,
    this.providerCode,
    this.customerCode,
    this.listOrder,
    this.debitAccount,
    this.saveBill,
    this.billAlias,
    this.totalAmount,
  });

  BillInitRequestData.fromJson(Map<String, dynamic> json) {
    serviceCode = json['service_code']?.toString();
    providerCode = json['provider_code']?.toString();
    customerCode = json['customer_code']?.toString();
    billAlias = json['account_alias']?.toString();
    saveBill = json['save_bill']?.toBool();
    if (json['list_order'] != null) {
      final v = json['list_order'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      listOrder = arr0;
    }
    debitAccount = json['debit_account']?.toString();
    totalAmount = json['amount']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['service_code'] = serviceCode;
    data['provider_code'] = providerCode;
    data['customer_code'] = customerCode;
    data['account_alias'] = billAlias;
    data['save_bill'] = saveBill;
    if (listOrder != null) {
      final v = listOrder;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data['list_order'] = arr0;
    }
    data['debit_account'] = debitAccount;
    data['amount'] = totalAmount;
    return data;
  }
}
