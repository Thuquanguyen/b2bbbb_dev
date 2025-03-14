import 'package:json_annotation/json_annotation.dart';

part 'otp_resend_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OtpResendModel {
  OtpResendModel({
    this.verifyOtpDisplayType,
    this.verifyTransId,
  });

  int? verifyOtpDisplayType;
  String? verifyTransId;

  factory OtpResendModel.fromJson(Map<String, dynamic> json) => _$OtpResendModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResendModelToJson(this);
}
