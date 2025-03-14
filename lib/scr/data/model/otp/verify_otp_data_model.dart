import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/scr/data/model/auth/login_data_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';

part 'verify_otp_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VerifyOtpDataModel {
  VerifyOtpDataModel({
    this.createdDate,
    this.bankId,
    this.transCode,
    this.azContractContent,
    this.azContractContentByte,
    this.approved,
  });

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) => _$VerifyOtpDataModelFromJson(json);

  String? createdDate;
  String? bankId;
  String? transCode;
  String? azContractContent;
  String? azContractContentByte;
  bool? approved;

  Map<String, dynamic> toJson() => _$VerifyOtpDataModelToJson(this);
}
