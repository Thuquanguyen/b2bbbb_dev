part of 'otp_bloc.dart';

@immutable
abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OtpEventVerify extends OtpEvent {
  OtpEventVerify(
      {required this.username,
      required this.otpCode,
      required this.otpSession});

  final String username;
  final String otpCode;
  final String otpSession;
}

class OtpEventResend extends OtpEvent {
  OtpEventResend({required this.username, required this.otpSession});

  final String username;
  final String otpSession;
}

class OtpEventGetActivationCodeSmartOTP extends OtpEvent {
  OtpEventGetActivationCodeSmartOTP();
}

class OtpEventVerifyMadeFund extends OtpEvent {
  OtpEventVerifyMadeFund({required this.args, required this.otpCode}) {
    args.otpCode = otpCode;
  }

  Map<String, dynamic> toMap() {
    return args.toMap();
  }

  String getUrl() {
    if (args is VerifyMadeFundOTPArgs) {
      return Endpoint.MADE_FUND_VERIFY.value;
    }
    if (args is CommitTransactionOTPArgs) {
      if ((args as CommitTransactionOTPArgs).isFx == true) {
        return Endpoint.TRANSACTION_FX_MANAGE_COMMIT.value;
      } else {
        return Endpoint.COMMIT_TRANSACTION.value;
      }
    } else if (args is VerifyOtpOpenSavingArgs) {
      return Endpoint.OPEN_SAVING_VERIFY.value;
    }
    if (args is CommitSavingSettlementOTPArgs) {
      return Endpoint.CLOSE_AZ_COMMIT.value;
    }
    if (args is CommitSavingApproveOTPArgs) {
      return Endpoint.TRANSACTION_SAVING_MANAGE_COMMIT.value;
    }
    if (args is CommitPayrollApproveOTPArgs) {
      return Endpoint.TRANSACTION_PAYROLL_MANAGE_COMMIT.value;
    }
    if (args is CommitTaxOnlineApproveOTPArgs) {
      return Endpoint.MANAGE_TAX_ONLINE_COMMIT.value;
    }
    if (args is CommitBillTransactionOTPArgs) {
      return Endpoint.COMMIT_BILL_MANAGE.value;
    }

    if (args is VerifyOtpBillArgs) {
      return Endpoint.BILL_VERIFY.value;
    }

    return '';
  }

  final VerifyOTPArgs args;
  final String otpCode;
}

class OtpEventResendVerify extends OtpEvent {
  OtpEventResendVerify({required this.otpTypeCode, required this.transcode});

  final int otpTypeCode;
  final String transcode;
}
