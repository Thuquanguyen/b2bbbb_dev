// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return TransactionModel(
    responseCode: json['responseCode'] as int?,
    message: json['message'] as String?,
    transactionData: json['transactionData'] as String?,
    userID: json['userID'] as String?,
    transactionID: json['transactionID'] as String?,
    transactionStatusID: json['transactionStatusID'] as int?,
    transactionTypeID: json['transactionTypeID'] as int?,
    challenge: json['challenge'] as String?,
  );
}

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'message': instance.message,
      'transactionData': instance.transactionData,
      'userID': instance.userID,
      'transactionID': instance.transactionID,
      'transactionStatusID': instance.transactionStatusID,
      'transactionTypeID': instance.transactionTypeID,
      'challenge': instance.challenge,
    };
