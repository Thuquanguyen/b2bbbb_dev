// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardHistoryRequestModel _$CardHistoryRequestModelFromJson(
    Map<String, dynamic> json) {
  return CardHistoryRequestModel(
    contractCardId: json['contract_card_id'] as String?,
    fromDate: json['from_date'] as String?,
    toDate: json['to_date'] as String?,
  );
}

Map<String, dynamic> _$CardHistoryRequestModelToJson(
        CardHistoryRequestModel instance) =>
    <String, dynamic>{
      'contract_card_id': instance.contractCardId,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
    };
