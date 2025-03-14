import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';

class TransactionInfo {
  String? status;
  NameModel? statusDisplay;
  String? reason;
  String? account;
  String? accountFee;
  String? transCode;
  String? sercureTrans;
  String? createdDateTime;
  String? createdBy;

  TransactionInfo({
    this.status,
    this.statusDisplay,
    this.reason,
    this.account,
    this.accountFee,
    this.transCode,
    this.sercureTrans,
    this.createdDateTime,
    this.createdBy,
  });

  TransactionInfo.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    statusDisplay = NameModel.fromJson(json['status_display']);
    reason = json['reason']?.toString();
    account = json['account']?.toString();
    accountFee = json['account_fee']?.toString();
    transCode = json['trans_code']?.toString();
    sercureTrans = json['sercure_trans']?.toString();
    createdDateTime = json['created_date_time']?.toString();
    createdBy = json['created_by']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['status_display'] = statusDisplay?.toJson();
    data['reason'] = reason;
    data['account'] = account;
    data['account_fee'] = accountFee;
    data['trans_code'] = transCode;
    data['sercure_trans'] = sercureTrans;
    data['created_date_time'] = createdDateTime;
    data['created_by'] = createdBy;
    return data;
  }
}

class TaxOnline {
  String? reqId;
  String? taxCode;
  String? customerName;
  String? customerEmail;
  String? customerPhoneNumber;
  String? career;
  String? address;
  String? caSerialNumber;
  String? representor;
  String? representorId;
  String? chiefAccountantName;
  String? chiefAccountantId;
  TransactionInfo? transInfo;

  TaxOnline({
    this.reqId,
    this.taxCode,
    this.customerName,
    this.customerEmail,
    this.customerPhoneNumber,
    this.career,
    this.address,
    this.caSerialNumber,
    this.representor,
    this.representorId,
    this.chiefAccountantName,
    this.chiefAccountantId,
    this.transInfo,
  });

  TaxOnline.fromJson(Map<String, dynamic> json) {
    reqId = json['req_id']?.toString();
    taxCode = json['tax_code']?.toString();
    customerName = json['customer_name']?.toString();
    customerEmail = json['customer_email']?.toString();
    customerPhoneNumber = json['customer_phone_number']?.toString();
    career = json['career']?.toString();
    address = json['address']?.toString();
    caSerialNumber = json['ca_serial_number']?.toString();
    representor = json['representor']?.toString();
    representorId = json['representor_id']?.toString();
    chiefAccountantName = json['chief_accountant_name']?.toString();
    chiefAccountantId = json['chief_accountant_id']?.toString();
    transInfo = (json['trans_info'] != null) ? TransactionInfo.fromJson(json['trans_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['req_id'] = reqId;
    data['tax_code'] = taxCode;
    data['customer_name'] = customerName;
    data['customer_email'] = customerEmail;
    data['customer_phone_number'] = customerPhoneNumber;
    data['career'] = career;
    data['address'] = address;
    data['ca_serial_number'] = caSerialNumber;
    data['representor'] = representor;
    data['representor_id'] = representorId;
    data['chief_accountant_name'] = chiefAccountantName;
    data['chief_accountant_id'] = chiefAccountantId;
    if (transInfo != null) {
      data['trans_info'] = transInfo!.toJson();
    }
    return data;
  }

  bool shouldShowActionButtons(bool isChecker, String? currentUsername) {
    return isChecker && transInfo?.statusDisplay?.taxCheckerShowAction == true ||
        isChecker == false &&
            transInfo?.statusDisplay?.taxMakerShowAction == true &&
            transInfo?.createdBy == currentUsername;
  }

  bool get shouldShowRejectReason {
    return transInfo?.statusDisplay?.key == 'REJ';
  }
}
