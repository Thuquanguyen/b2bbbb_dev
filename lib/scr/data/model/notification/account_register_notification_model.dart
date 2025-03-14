import 'package:json_annotation/json_annotation.dart';

part 'account_register_notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountRegisterNotificationModel {
  @JsonKey(name: 'aggregate_Id')
  final String? aggregateId;
  final String? secureTrans;

  AccountRegisterNotificationModel({this.aggregateId, this.secureTrans});

  factory AccountRegisterNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$AccountRegisterNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountRegisterNotificationModelToJson(this);
}
