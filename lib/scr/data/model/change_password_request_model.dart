import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChangePasswordRequestModel {
  ChangePasswordRequestModel({
    required this.oldPasswd,
    required this.newPasswd,
    required this.confirmNewPasswd,
  });

  String oldPasswd;
  String newPasswd;
  String confirmNewPasswd;

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestModelToJson(this);
}
