// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_statement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardStatementRequestModel _$CardStatementRequestModelFromJson(
    Map<String, dynamic> json) {
  return CardStatementRequestModel(
    contractCardId: json['contract_card_id'] as String?,
    stmtMonth: json['stmt_month'] as String?,
  );
}

Map<String, dynamic> _$CardStatementRequestModelToJson(
        CardStatementRequestModel instance) =>
    <String, dynamic>{
      'contract_card_id': instance.contractCardId,
      'stmt_month': instance.stmtMonth,
    };
