class ConfirmTransferModel {
  ConfirmTransferModel(this.message, this.verifyOtpDisplayType);

  int? verifyOtpDisplayType;
  String? message;

  ConfirmTransferModel.fromJson(Map<String, dynamic> json) {
    verifyOtpDisplayType = json['verify_otp_display_type']?.toInt();
  }
}
