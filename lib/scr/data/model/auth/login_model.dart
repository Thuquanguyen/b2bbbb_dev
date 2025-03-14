import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/scr/data/model/auth/login_data_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';

part 'login_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginModel {
  LoginModel({
    this.result,
    this.data,
  });

  BaseResultModel? result;
  LoginDataModel? data;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
