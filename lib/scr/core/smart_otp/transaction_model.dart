//{"responseCode":99,
// "message":"Data does not exist",
// "userID":null,"transactionID":null,
// "transactionTypeID":0,"transactionData":null,
// "transactionStatusID":0,
// "challenge":null,
// "isOnline":0,
// "eSignerTypeID":0,
// "channelID":0}
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  TransactionModel({
    this.responseCode,
    this.message,
    this.transactionData,
    this.userID,
    this.transactionID,
    this.transactionStatusID,
    this.transactionTypeID,
    this.challenge,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  int? responseCode;
  String? message;
  String? transactionData;
  String? userID;
  String? transactionID;
  int? transactionStatusID;
  int? transactionTypeID;
  String? challenge;

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
