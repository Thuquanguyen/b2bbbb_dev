part of 'otp_bloc.dart';

enum OtpStatus { SUCCESS, ERROR, LOCKED, LOGGED_OUT, VERIFY_ERROR_00, VERIFY_ERROR_01 }

@immutable
class OtpState extends Equatable {
  const OtpState(
      {this.otpVerifyState,
      this.otpResendState,
      this.otpGetActiveSOTPState,
      this.otpVerifyMadeFundState,
      this.otpResendVerifyState});

  final OtpAuthState? otpVerifyState;
  final OtpAuthState? otpResendState;
  final OtpVerifyMadeFundState? otpGetActiveSOTPState;
  final OtpVerifyMadeFundState? otpVerifyMadeFundState;
  final OtpResendVerifyState? otpResendVerifyState;

  @override
  List<Object?> get props =>
      [otpVerifyState, otpResendState, otpGetActiveSOTPState, otpVerifyMadeFundState, otpResendVerifyState];
}

class OtpResendVerifyState {
  const OtpResendVerifyState({
    this.model,
    this.dataState = DataState.init,
    this.status,
    this.errMessage,
  });

  final OtpResendModel? model;
  final DataState dataState;
  final OtpStatus? status;
  final String? errMessage;
}

class OtpAuthState {
  const OtpAuthState({
    this.model,
    this.dataState = DataState.init,
    this.status,
  });

  final OtpModel? model;
  final DataState dataState;
  final OtpStatus? status;
}

class OtpVerifyMadeFundState {
  const OtpVerifyMadeFundState({
    this.model,
    this.dataState = DataState.init,
    this.status,
    this.message
  });

  final VerifyOtpDataModel? model;
  final DataState? dataState;
  final OtpStatus? status;
  final String? message;
}
