import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_payroll_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionPayrollModel extends TransactionBaseModel {
  String? fileCode;
  String? secureTrans;
  String? refId;
  NameModel? status;
  String? beneficiaryName;
  String? currency;
  double? feeAmount;
  int? totalItem;

  TransactionPayrollModel({
    this.fileCode,
    this.secureTrans,
    this.refId,
    this.status,
    this.beneficiaryName,
    this.currency,
    this.feeAmount,
    this.totalItem,
  });

  factory TransactionPayrollModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionPayrollModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionPayrollModelToJson(this);
}
