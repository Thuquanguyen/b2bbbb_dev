import 'package:json_annotation/json_annotation.dart';

part 'login_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginDataModel {
  LoginDataModel({
    this.sessionId,
    this.otpSession,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => _$LoginDataModelFromJson(json);

  String? sessionId;
  String? otpSession;

  Map<String, dynamic> toJson() => _$LoginDataModelToJson(this);
}
