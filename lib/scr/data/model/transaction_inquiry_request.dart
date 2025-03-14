import 'package:json_annotation/json_annotation.dart';

part 'transaction_inquiry_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionInquiryRequest {
  TransactionInquiryRequest({
    this.serviceType,
    this.status,
    this.transCode,
    this.accountingEntry,
    this.fromAmount,
    this.toAmount,
    this.fromDate,
    this.toDate,
  });

  String? serviceType;
  String? status;
  String? transCode;
  String? accountingEntry;
  double? fromAmount;
  double? toAmount;
  String? fromDate;
  String? toDate;

  factory TransactionInquiryRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionInquiryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInquiryRequestToJson(this);
}
