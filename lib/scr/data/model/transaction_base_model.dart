import 'package:json_annotation/json_annotation.dart';

class TransactionBaseModel {
  @JsonKey(ignore: true)
  bool isSelected;
  String? transCode;
  String? debitAccountNumber;
  String? debitAccountName;
  double? amount;
  String? createdDate;
  String? memo;

  TransactionBaseModel({
    this.isSelected = false,
    this.transCode,
    this.debitAccountNumber,
    this.debitAccountName,
    this.amount,
    this.createdDate,
    this.memo,
  });
}
