import 'package:json_annotation/json_annotation.dart';

part 'card_statement_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CardStatementRequestModel {
  CardStatementRequestModel({
    this.contractCardId,
    this.stmtMonth,
  });

  final String? contractCardId;
  final String? stmtMonth;

  factory CardStatementRequestModel.fromJson(Map<String, dynamic> json) => _$CardStatementRequestModelFromJson(json);

  Map<String, dynamic> toJSON() => _$CardStatementRequestModelToJson(this);
}