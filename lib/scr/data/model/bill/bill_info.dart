class BillInfoCusInfo {
  String? cusCode;
  String? cusName;
  String? cusAddr;
  String? billTotalAmount;
  String? billTotalAmountCcy;
  double? billTotalAmountPay;
  String? enquiryInfo;
  String? paymentNumber;
  String? organizedCode;

  BillInfoCusInfo({
    this.cusCode,
    this.cusName,
    this.cusAddr,
    this.billTotalAmount,
    this.billTotalAmountCcy,
    this.billTotalAmountPay,
    this.enquiryInfo,
    this.paymentNumber,
    this.organizedCode,
  });

  BillInfoCusInfo.fromJson(Map<String, dynamic> json) {
    cusCode = json['cus_code']?.toString();
    cusName = json['cus_name']?.toString();
    cusAddr = json['cus_addr']?.toString();
    billTotalAmount = json['bill_total_amount']?.toString();
    billTotalAmountCcy = json['bill_total_amount_ccy']?.toString();
    billTotalAmountPay = json['bill_total_amount_pay']?.toDouble();
    enquiryInfo = json['enquiry_info']?.toString();
    paymentNumber = json['payment_number']?.toString();
    organizedCode = json['organized_code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cusd_code'] = cusCode;
    data['cus_name'] = cusName;
    data['cus_addr'] = cusAddr;
    data['bill_total_amount'] = billTotalAmount;
    data['bill_total_amount_ccy'] = billTotalAmountCcy;
    data['bill_total_amount_pay'] = billTotalAmountPay;
    data['enquiry_info'] = enquiryInfo;
    data['payment_number'] = paymentNumber;
    data['organized_code'] = organizedCode;
    return data;
  }
}

class BillInfoBillList {
  String? idx;
  String? billId;
  String? billMonth;
  double? billAmt;
  String? billFeeAmt;
  String? billExpired;
  double? billAmtPay;
  double? billFeeAmtPay;
  int? billType;
  String? typeString;
  String? type;
  int? priority;
  String? postingDate;
  String? receivedDate;

  bool? isSelected = false;

  bool? isExpand = false;

  void setSelected(bool value) {
    isSelected = value;
  }

  void setExpand(bool value) {
    isExpand = value;
  }

  BillInfoBillList({
    this.idx,
    this.billId,
    this.billMonth,
    this.billAmt,
    this.billFeeAmt,
    this.billExpired,
    this.billAmtPay,
    this.billFeeAmtPay,
    this.billType,
    this.typeString,
    this.type,
    this.priority,
    this.postingDate,
    this.receivedDate,
    this.isSelected,
  });

  BillInfoBillList.fromJson(Map<String, dynamic> json) {
    idx = json['idx']?.toString();
    billId = json['bill_id']?.toString();
    billMonth = json['bill_month']?.toString();
    billAmt = json['bill_amt']?.toDouble();
    billFeeAmt = json['bill_fee_amt']?.toString();
    billExpired = json['bill_expired']?.toString();
    billAmtPay = json['bill_amt_pay']?.toDouble();
    billFeeAmtPay = json['bill_fee_amt_pay']?.toDouble();
    billType = json['bill_type']?.toInt();
    typeString = json['type_string']?.toString();
    type = json['type']?.toString();
    priority = json['priority']?.toInt();
    postingDate = json['posting_date']?.toString();
    receivedDate = json['received_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idx'] = idx;
    data['bill_id'] = billId;
    data['bill_month'] = billMonth;
    data['bill_amt'] = billAmt;
    data['bill_fee_amt'] = billFeeAmt;
    data['bill_expired'] = billExpired;
    data['bill_amt_pay'] = billAmtPay;
    data['bill_fee_amt_pay'] = billFeeAmtPay;
    data['bill_type'] = billType;
    data['type_string'] = typeString;
    data['type'] = type;
    data['priority'] = priority;
    data['posting_date'] = postingDate;
    data['received_date'] = receivedDate;
    return data;
  }

  DateTime? getPeriodDateTime() {
    try {
      int m = int.parse(billMonth?.substring(0, billMonth?.indexOf('/')) ?? '');
      int y =
          int.parse(billMonth?.substring(billMonth?.indexOf('/') ?? -1) ?? '');
      return DateTime(y, m);
    } catch (e) {
      return null;
    }
  }
}

class BillInfo {
  bool? isOffline;
  bool? isWarning;
  String? merchantCode;
  int? paymentRule;
  List<BillInfoBillList?>? billList;
  BillInfoCusInfo? cusInfo;
  String? paymentMethod;

  BillInfo({
    this.isOffline,
    this.isWarning,
    this.merchantCode,
    this.paymentRule,
    this.billList,
    this.cusInfo,
    this.paymentMethod,
  });

  BillInfo.fromJson(Map<String, dynamic> json) {
    isOffline = json['is_offline'];
    isWarning = json['is_warning'];
    merchantCode = json['merchant_code']?.toString();
    paymentRule = json['payment_rule']?.toInt();
    if (json['bill_list'] != null) {
      final v = json['bill_list'];
      final arr0 = <BillInfoBillList>[];
      v.forEach((v) {
        arr0.add(BillInfoBillList.fromJson(v));
      });
      billList = arr0;
    }
    cusInfo = (json['cus_info'] != null)
        ? BillInfoCusInfo.fromJson(json['cus_info'])
        : null;
    paymentMethod = json['payment_method']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_offline'] = isOffline;
    data['is_warning'] = isWarning;
    data['merchant_code'] = merchantCode;
    data['payment_rule'] = paymentRule;
    if (billList != null) {
      final v = billList;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['bill_list'] = arr0;
    }
    if (cusInfo != null) {
      data['cus_info'] = cusInfo!.toJson();
    }
    data['payment_method'] = paymentMethod;
    return data;
  }
}
