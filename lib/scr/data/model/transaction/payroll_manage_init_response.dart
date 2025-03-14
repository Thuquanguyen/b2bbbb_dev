import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payroll_manage_init_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PayrollManageInitResponse {
  PayrollManageInitResponse({
    this.transactions,
    this.secureTrans,
    this.totalInhouse,
    this.totalOther,
  });

  TransactionMainModel? transactions;
  String? secureTrans;
  int? totalInhouse;
  int? totalOther;

  factory PayrollManageInitResponse.fromJson(Map<String, dynamic> json) =>
      _$PayrollManageInitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollManageInitResponseToJson(this);
}
