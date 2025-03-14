import 'dart:async';

import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/otp/otp_bloc.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';

abstract class VerifyOTPArgs {
  final String transCode;
  final String secureTrans;
  final String? message;
  final String? transactionId;
  final int verifyOtpDisplayType;
  String? otpCode;

  VerifyOTPArgs({
    required this.transCode,
    required this.secureTrans,
    required this.verifyOtpDisplayType,
    this.transactionId,
    this.message,
  });

  Map<String, dynamic> toMap();
}

class VerifyOtpOpenSavingArgs extends VerifyOTPArgs {
  int? transferTypeCode;

  VerifyOtpOpenSavingArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    String? transactionId,
    String? message,
    int? transferTypeCode,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode == '000000' ? '' : otpCode,
        'transfer_type_code': transferTypeCode ?? 4,
      };
}

class VerifyMadeFundOTPArgs extends VerifyOTPArgs {
  final int transferTypeCode;

  VerifyMadeFundOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    String? transactionId,
    String? message,
    required this.transferTypeCode,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode == '000000' ? '' : otpCode,
        'transfer_type_code': transferTypeCode
      };
}

//Thanh toán hóa đơn
class VerifyOtpBillArgs extends VerifyOTPArgs {
  int? transferTypeCode;

  VerifyOtpBillArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    String? transactionId,
    String? message,
    int? transferTypeCode,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode == '000000' ? '' : otpCode,
        'transfer_type_code': transferTypeCode ?? 4,
      };
}

enum CommitActionType { APPROVE, REJECT, CANCEL }

extension CommitActionTypeExtension on CommitActionType {
  get value => this == CommitActionType.APPROVE ? 0 : (this == CommitActionType.REJECT ? 1 : 2);
}

class CommitTransactionOTPArgs extends VerifyOTPArgs {
  final String verifyTransId;
  final CommitActionType actionType;
  final String? note;
  final bool? isFx;

  CommitTransactionOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    required this.verifyTransId,
    String? transactionId,
    String? message,
    required this.actionType,
    this.note,
    this.isFx,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_trans_id': verifyTransId,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode,
        'action_type': actionType.value,
        'note': note
      };
}

class CommitSavingSettlementOTPArgs extends VerifyOTPArgs {
  CommitSavingSettlementOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    required String? message,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode,
        'transfer_type_code': 5,
      };
}

class CommitSavingApproveOTPArgs extends VerifyOTPArgs {
  final String verifyTransId;
  final CommitActionType actionType;
  final String? note;

  CommitSavingApproveOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    required this.verifyTransId,
    String? transactionId,
    String? message,
    required this.actionType,
    this.note,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_trans_id': verifyTransId,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode,
        'action_type': actionType.value,
        'note': note.isNullOrEmpty ? '.' : note
      };
}

class CommitTaxOnlineApproveOTPArgs extends VerifyOTPArgs {
  final String verifyTransId;
  final CommitActionType actionType;
  final String? note;

  CommitTaxOnlineApproveOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    required this.verifyTransId,
    String? transactionId,
    String? message,
    required this.actionType,
    this.note,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_trans_id': verifyTransId,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode,
        'action_type': actionType.value,
        'note': note.isNullOrEmpty ? '.' : note
      };
}

class CommitPayrollApproveOTPArgs extends VerifyOTPArgs {
  final String verifyTransId;
  final CommitActionType actionType;
  final String? note;

  CommitPayrollApproveOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    required this.verifyTransId,
    String? transactionId,
    String? message,
    required this.actionType,
    this.note,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_trans_id': verifyTransId,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode,
        'action_type': actionType.value,
        'note': note.isNullOrEmpty ? '.' : note
      };
}

class CommitBillTransactionOTPArgs extends VerifyOTPArgs {
  final String verifyTransId;
  final CommitActionType actionType;
  final String? note;

  CommitBillTransactionOTPArgs({
    required String transCode,
    required String secureTrans,
    required int verifyOtpDisplayType,
    required this.verifyTransId,
    String? transactionId,
    String? message,
    required this.actionType,
    this.note,
  }) : super(
          transCode: transCode,
          secureTrans: secureTrans,
          verifyOtpDisplayType: verifyOtpDisplayType,
          message: message,
          transactionId: transactionId,
        );

  @override
  Map<String, dynamic> toMap() => {
        'trans_code': transCode,
        'secure_trans': secureTrans,
        'verify_trans_id': verifyTransId,
        'verify_otp_display_type': verifyOtpDisplayType,
        'OTP': otpCode,
        'action_type': actionType.value,
        'note': note
      };
}

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({Key? key}) : super(key: key);
  static const String routeName = 'verify_otp_screen';

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

const int VERIFY_OTP_TIME = 180;

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String smartOTPCode = '';
  Function(bool isSuccess, OtpVerifyMadeFundState? data)? onResult;

  // Function? reSend;
  VerifyOTPArgs? args;
  bool isLoading = false;

  int otpTimeout = VERIFY_OTP_TIME;
  int startTime = 0;
  String? errorMessage = '';

  StateHandler stateHandler = StateHandler(VerifyOTPScreen.routeName);

  // ignore: prefer_typing_uninitialized_variables
  Timer? timer;

  void runCountdown() {
    if (otpTimeout > 0) {
      otpTimeout = VERIFY_OTP_TIME - ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000).round();
      stateHandler.refresh();
      if (otpTimeout <= 0) {
        otpTimeout = 0;
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.otpTitleOutOfTimeGetOtpStr.localized,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized,
            onTap: () {
              popScreen(context);
            },
          ),
          showCloseButton: false,
          barrierDismissible: false,
        );
        otpCode = '';
        _controller.clear();
      }
    }
  }

  void startCountDown() {
    otpTimeout = VERIFY_OTP_TIME;
    startTime = DateTime.now().millisecondsSinceEpoch;
    timer ??= setInterval(() {
      runCountdown();
    }, 1000);
  }

  void stopCountDown() {
    if (timer != null) {
      clearInterval(timer!);
      timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    startCountDown();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    stopCountDown();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void processVerifyState(OtpVerifyMadeFundState otpVerifyState) {
    if (otpVerifyState.dataState == DataState.preload) {
      showLoading();
    } else if (otpVerifyState.dataState == DataState.data) {
      hideLoading();
      if (otpVerifyState.status == OtpStatus.SUCCESS) {
        stopCountDown();
        showSuccess(AppTranslate.i18n.otpMessageConfirmStr.localized, duration: const Duration(milliseconds: 1000));
        setTimeout(() {
          onResult?.call(true, otpVerifyState);
        }, 1000);
      } else if (otpVerifyState.status == OtpStatus.VERIFY_ERROR_01) {
        errorMessage = otpVerifyState.message;
        _focusNode.requestFocus();
        setState(() {});
      } else if (otpVerifyState.status == OtpStatus.LOGGED_OUT) {
        stopCountDown();
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          otpVerifyState.message ?? '',
          showCloseButton: false,
          barrierDismissible: false,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized,
            onTap: () {
              SessionManager().logout();
            },
          ),
        );
      } else {
        onResult?.call(false, otpVerifyState);
      }
      isLoading = false;
    } else {
      onResult?.call(false, otpVerifyState);
      isLoading = false;
    }
  }

  void processResendVerifyState(OtpResendVerifyState otpVerifyState) {
    Logger.info("start");
    if (otpVerifyState.dataState == DataState.preload) {
      showLoading();
    } else if (otpVerifyState.dataState == DataState.data) {
      if (otpVerifyState.status == OtpStatus.SUCCESS) {
        setTimeout(() {
          hideLoading();
          showToast(AppTranslate.i18n.resendOtpSuccessStr.localized);
          _controller.clear();
          startCountDown();
        }, 1000);
      } else {
        hideLoading();
        setState(
          () {
            errorMessage = otpVerifyState.errMessage;
          },
        );
      }
      isLoading = false;
    } else {
      isLoading = false;
      errorMessage = otpVerifyState.errMessage;
      hideLoading();
      setState(() {});
    }
  }

  void onBack() {
    popScreen(context);
  }

  bool isFilledSmartOTP() {
    return smartOTPCode.isNotEmpty && smartOTPCode.length == 6;
  }

  @override
  Widget build(BuildContext context) {
    args = getArgument<VerifyOTPArgs>(context, 'data');
    onResult = getArgument<Function(bool isSuccess, OtpVerifyMadeFundState? data)>(context, 'onResult');
    // reSend = getArgument<Function>(context, 'reSend');
    smartOTPCode = getArgument<String>(context, 'otpCode') ?? '';

    if (isFilledSmartOTP()) {
      _controller.text = smartOTPCode;
      hideKeyboard(context);
      processOtpCode(smartOTPCode);
    }

    Logger.debug('render main otp screen');
    return BlocConsumer<OtpBloc, OtpState>(
      listenWhen: (previous, current) {
        return (previous.otpVerifyMadeFundState != current.otpVerifyMadeFundState) ||
            (previous.otpResendVerifyState != current.otpResendVerifyState);
      },
      listener: (context, state) {
        Logger.debug("listener");
        OtpVerifyMadeFundState? otpVerifyState = state.otpVerifyMadeFundState;
        if (otpVerifyState != null) {
          processVerifyState(otpVerifyState);
        }
        OtpResendVerifyState? otpResendVerifyState = state.otpResendVerifyState;
        if (otpResendVerifyState != null) {
          processResendVerifyState(otpResendVerifyState);
        }
      },
      builder: (context, state) {
        return AppBarContainer(
          title: AppTranslate.i18n.otpConfirmInformationStr.localized,
          appBarType: AppBarType.NORMAL,
          onTap: () {
            // FocusScope.of(context).unfocus();
          },
          onBack: () {
            onBack.call();
          },
          child: buildScreen(context),
        );
      },
    );
  }

  String otpCode = '';

  void processOtpCode(String value) {
    if (otpCode.length >= 6 && value.length >= 6) {
      return;
    }
    otpCode = value;
    if (otpTimeout > 0 && errorMessage != null && errorMessage!.isNotEmpty) {
      setState(() {
        errorMessage = '';
      });
    }
    if (otpCode.length == 6 && otpTimeout > 0 && args != null) {
      if (!isLoading) {
        isLoading = true;
        if (_focusNode.hasFocus) _focusNode.unfocus();
        setTimeout(() {
          showLoading();
        }, 300);
        setTimeout(() {
          context.read<OtpBloc>().add(OtpEventVerifyMadeFund(args: args!, otpCode: otpCode));
        }, 500);
      }
    }
  }

  Container buildScreen(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              ((args?.message ?? '').isNullOrEmpty ? AppTranslate.i18n.otpTitleInputOtpStr.localized : args!.message) ??
                  '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(102, 102, 103, 1.0),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 160,
              height: 44,
              child: AutofillGroup(
                child: TextField(
                  focusNode: _focusNode,
                  keyboardAppearance: Brightness.light,
                  onChanged: (value) {
                    processOtpCode(value);
                  },
                  controller: _controller,
                  // ignore: prefer_const_literals_to_create_immutables
                  autofillHints: [AutofillHints.oneTimeCode],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 10,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(52, 52, 52, 1.0)),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    counterText: '',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(186, 205, 223, 1.0), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(186, 205, 223, 1.0), width: 1),
                    ),
                  ),
                  maxLength: 6,
                  showCursor: false,
                  autofocus: smartOTPCode.isEmpty,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(height: 20),
            StateBuilder(
              routeName: VerifyOTPScreen.routeName,
              builder: () => Text(
                '${otpTimeout}s',
                style: const TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(102, 102, 103, 1.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                errorMessage ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(255, 103, 99, 1.0),
                ),
              ),
            ),
            const SizedBox(height: 80),
            if (smartOTPCode.isNotNullAndEmpty == false && args?.verifyOtpDisplayType == OtpType.SMS_EMAIL.value)
              Touchable(
                onTap: () {
                  setState(() {
                    errorMessage = '';
                  });
                  // reSend?.call((data) {
                  //   if (data == null) {
                  //     setState(() {
                  //       errorMessage = 'Lỗi không lấy lại được OTP';
                  //     });
                  //   } else {
                  //     resetCountDown();
                  //     args = data;
                  //   }
                  // });
                  setTimeout(() {
                    processResendOtp();
                  }, 300);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppTranslate.i18n.otpTitleGetAgainStr.localized,
                      style: const TextStyle(fontSize: 13, color: Color.fromRGBO(0, 183, 79, 1.0))),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void processResendOtp() {
    Logger.info("start");
    context
        .read<OtpBloc>()
        .add(OtpEventResendVerify(otpTypeCode: args!.verifyOtpDisplayType, transcode: args!.transCode));
  }
}
