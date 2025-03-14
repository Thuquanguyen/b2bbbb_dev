import 'package:b2b/scr/data/model/bill_payment_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_init_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionManageInitBaseResponse {
  TransactionManageInitBaseResponse({
    this.secureTrans,
    this.transcodeTrusted,
    this.transferTypeCode,
  });

  String? secureTrans;
  String? transcodeTrusted;
  int? transferTypeCode;

  factory TransactionManageInitBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionManageInitBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionManageInitBaseResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionManageInitResponse extends TransactionManageInitBaseResponse {
  TransactionManageInitResponse({
    this.transactions,
  });

  List<TransactionMainModel>? transactions;

  factory TransactionManageInitResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionManageInitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionManageInitResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BillTransactionManageInitResponse extends TransactionManageInitBaseResponse {
  BillTransactionManageInitResponse({
    this.transactions,
  });

  List<BillPaymentModel>? transactions;

  factory BillTransactionManageInitResponse.fromJson(Map<String, dynamic> json) =>
      _$BillTransactionManageInitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BillTransactionManageInitResponseToJson(this);
}
