import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/scr/data/model/auth/login_data_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';

part 'otp_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OtpModel {
  OtpModel({
    this.result,
    this.data,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) => _$OtpModelFromJson(json);

  BaseResultModel? result;
  LoginDataModel? data;

  // Map<String, dynamic> toJson() => _$OtpModelToJson(this);
}
