import 'package:json_annotation/json_annotation.dart';

part 'dr_contract_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DRContractModel {
  final String? refNum;
  final String? type;
  final double? amount;
  final String? currency;
  final String? valueDate;
  final String? traceDate;
  final String? maturityDate;
  final String? dueDate;
  final double? paidAmt;
  final double? outsAmnt;
  final String? applicationName;
  final String? beneficiaryName;

  DRContractModel({
    this.refNum,
    this.type,
    this.amount,
    this.currency,
    this.valueDate,
    this.traceDate,
    this.maturityDate,
    this.dueDate,
    this.paidAmt,
    this.outsAmnt,
    this.applicationName,
    this.beneficiaryName,
  });

  factory DRContractModel.fromJson(Map<String, dynamic> json) => _$DRContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$DRContractModelToJson(this);
}
