import 'dart:convert';

enum FcmActionType { TransferAlert, BalanceAlert, SAVING, PAY_ROLL, bill, PROMOTE }

extension FcmExt on FcmActionType {
  String getValue() {
    if (this == FcmActionType.TransferAlert) {
      return 'transfer_alert';
    } else if (this == FcmActionType.BalanceAlert) {
      return 'balance_alert';
    } else if (this == FcmActionType.SAVING) {
      return 'saving_alert';
    } else if (this == FcmActionType.PAY_ROLL) {
      return 'payroll_alert';
    } else if (this == FcmActionType.bill) {
      return 'bill_alert';
    } else if (this == FcmActionType.PROMOTE) {
      return 'marketing_alert';
    }
    return '';
  }
}

class FcmMetaData {
  String? userReceive;
  String? module;
  String? topic;

  FcmMetaData({
    this.userReceive,
    this.module,
    this.topic,
  });

  FcmMetaData.fromJson(Map<String, dynamic> json) {
    userReceive = json["user_receive"]?.toString();
    module = json["module"]?.toString();
    topic = json["topic"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["user_receive"] = userReceive;
    data["module"] = module;
    data["topic"] = topic;
    return data;
  }
}

class FcmData {
  String? body;
  FcmMetaData? metaData;

  FcmData({this.body, this.metaData});

  FcmData.fromJson(Map<String, dynamic> json) {
    body = json['body']?.toString();
    try {
      if (json['meta_data'] != null) {
        metaData = FcmMetaData.fromJson(jsonDecode(json['meta_data']));
      }
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["body"] = body;
    data["meta_data"] = metaData?.toJson();
    return data;
  }
}
