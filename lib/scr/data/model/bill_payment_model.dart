import 'package:b2b/scr/data/model/bill/bill_info.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/scr/data/model/name_model.dart';

part 'bill_payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BillPaymentModel extends TransactionMainModel {
  final BillInfoTransaction? billInfo;

  BillPaymentModel({
    this.billInfo,
  });

  factory BillPaymentModel.fromJson(Map<String, dynamic> json) => _$BillPaymentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BillPaymentModelToJson(this);
  
  List<String>? get periodTransCodes {
    return billInfo?.periodList?.map<String>((p) => p.code ?? '').toList();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BillInfoTransaction {
  final String? serviceCode;
  final String? providerCode;
  final String? billCode;
  final List<BillPeriod>? periodList;
  final BillInfoCusInfo? cusInfo;

  BillInfoTransaction({
    this.serviceCode,
    this.providerCode,
    this.billCode,
    this.periodList,
    this.cusInfo,
  });

  factory BillInfoTransaction.fromJson(Map<String, dynamic> json) => _$BillInfoTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$BillInfoTransactionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BillPeriod {
  final String? billNum;
  final String? code;
  final String? name;
  final double? amount;
  final String? type;

  BillPeriod({
    this.billNum,
    this.code,
    this.name,
    this.amount,
    this.type,
  });

  factory BillPeriod.fromJson(Map<String, dynamic> json) => _$BillPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$BillPeriodToJson(this);
}
