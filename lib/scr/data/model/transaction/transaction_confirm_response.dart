import 'package:json_annotation/json_annotation.dart';

part 'transaction_confirm_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionManageConfirmResponse {
  TransactionManageConfirmResponse({
    this.verifyOtpDisplayType,
    this.verifyTransId,
    this.message,
  });

  int? verifyOtpDisplayType;
  String? verifyTransId;
  String? message;

  factory TransactionManageConfirmResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionManageConfirmResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionManageConfirmResponseToJson(this);
}
