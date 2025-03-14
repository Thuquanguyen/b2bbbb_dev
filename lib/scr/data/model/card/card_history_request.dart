import 'package:json_annotation/json_annotation.dart';

part 'card_history_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CardHistoryRequestModel {
  CardHistoryRequestModel({
    this.contractCardId,
    this.fromDate,
    this.toDate,
  });

  final String? contractCardId;
  final String? fromDate;
  final String? toDate;

  factory CardHistoryRequestModel.fromJson(Map<String, dynamic> json) => _$CardHistoryRequestModelFromJson(json);

  Map<String, dynamic> toJSON() => _$CardHistoryRequestModelToJson(this);
}