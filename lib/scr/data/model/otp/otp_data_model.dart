import 'package:json_annotation/json_annotation.dart';

part 'otp_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OtpDataModel {
  OtpDataModel({
    this.sessionId,
    this.otpSession,
  });

  factory OtpDataModel.fromJson(Map<String, dynamic> json) =>
      _$OtpDataModelFromJson(json);

  String? sessionId;
  String? otpSession;

  Map<String, dynamic> toJson() => _$OtpDataModelToJson(this);
}
