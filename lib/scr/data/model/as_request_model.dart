import 'package:json_annotation/json_annotation.dart';

part 'as_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountServiceRequestModel {
  AccountServiceRequestModel(
      {required this.accountNumber,
      required this.fromDate,
      required this.toDate,
      required this.fromAmount,
      required this.toAmount,
      required this.memo});

  final String accountNumber;
  final String fromDate;
  final String toDate;
  final double fromAmount;
  final double toAmount;
  final String memo;

  factory AccountServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountServiceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountServiceRequestModelToJson(this);
}
