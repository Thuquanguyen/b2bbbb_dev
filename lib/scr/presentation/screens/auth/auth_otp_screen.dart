import 'dart:async';

import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/first_login_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/otp/otp_bloc.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/auth/pin_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class AuthOTPScreen extends StatefulWidget {
  const AuthOTPScreen({Key? key}) : super(key: key);
  static const String routeName = 'auth_otp_screen';

  @override
  _AuthOTPScreenState createState() => _AuthOTPScreenState();
}

const int OTP_TIME = 180;

class _AuthOTPScreenState extends State<AuthOTPScreen> {
  final _controller = TextEditingController();

  int otpTimeout = OTP_TIME;
  int startTime = 0;
  String? title;
  String? otpSession;
  String? username;
  String? errorMessage = '';
  bool isLoading = false;

  StateHandler stateHandler = StateHandler(AuthOTPScreen.routeName);

  // ignore: prefer_typing_uninitialized_variables
  late Timer timer;

  void runCountdown() {
    if (otpTimeout > 0) {
      otpTimeout = OTP_TIME - ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000).round();
      stateHandler.refresh();
      if (otpTimeout <= 0) {
        otpTimeout = 0;
        setState(() {
          errorMessage = AppTranslate.i18n.otpTitleOutOfTimeGetOtpStr.localized;
        });
        _controller.clear();
      }
    }
  }

  void resetCountDown() {
    otpTimeout = OTP_TIME;
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void initState() {
    super.initState();
    resetCountDown();
    timer = setInterval(() {
      runCountdown();
    }, 1000);
  }

  @override
  void dispose() {
    super.dispose();
    clearInterval(timer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unnecessary_null_comparison
    //
  }

  void processVerifyState(OtpAuthState otpVerifyState) {
    if (otpVerifyState.dataState == DataState.preload) {
      showLoading();
    } else if (otpVerifyState.dataState == DataState.data) {
      isLoading = false;
      //print(otpVerifyState.model?.data?.toString());
      if (otpVerifyState.status == OtpStatus.SUCCESS) {
        showSuccess(AppTranslate.i18n.otpMessageConfirmStr.localized);
        final sessionId = otpVerifyState.model?.data?.sessionId ?? '';
        SessionManager().setSessionId(sessionId);
        setTimeout(() {
          hideLoading();
          // LocalStorageHelper.sharedPreferenceSetString(SESSION_ID, sessionId);
          Navigator.of(context).pushReplacementNamed(PINScreen.routeName,
              arguments: PINScreenArgs(pinCodeType: PinScreenType.SETUP_PIN_APP));
        }, 500);
      } else {
        // _controller.clear();
        hideLoading();
        if (otpVerifyState.status == OtpStatus.LOCKED) {
          showDialogCustom(
              context,
              AssetHelper.icoAuthError,
              AppTranslate.i18n.dialogTitleNotificationStr.localized,
              otpVerifyState.model?.result?.getMessage() ??
                  AppTranslate.i18n.authAccountLockedIncorrectOtpStr.localized,
              button1: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.dialogButtonCloseStr.localized,
                  onTap: () {
                    onBack.call();
                  }));
        } else {
          setState(() {
            errorMessage = otpVerifyState.model?.result?.getMessage();
          });
        }
      }
    } else {
      isLoading = false;
    }
  }

  void processResendState(OtpAuthState otpResendState) {
    if (otpResendState.dataState == DataState.preload) {
      _controller.clear();
      showLoading();
    } else if (otpResendState.dataState == DataState.data) {
      if (otpResendState.status == OtpStatus.SUCCESS) {
        setTimeout(() {
          showToast(AppTranslate.i18n.otpSendAgainStr.localized);
          hideLoading();
        }, 500);
        resetCountDown();
        stateHandler.refresh();
      } else {
        setState(() {
          errorMessage = otpResendState.model?.result?.getMessage();
        });
      }
    }
  }

  Future<void> onBack() async {
    await AccountManager().loadUsers();
    if (AccountManager().getUsers().isNotEmpty) {
      pushReplacementNamed(context, ReLoginScreen.routeName, animation: false);
    } else {
      pushReplacementNamed(context, FirstLoginScreen.routeName, animation: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = getArguments(context);

    title = args['title'] ?? '';
    otpSession = args['otp_session'] ?? '';
    username = args['username'] ?? '';

    //print('render main otp screen');
    return BlocConsumer<OtpBloc, OtpState>(
      listenWhen: (previous, current) =>
          (previous.otpVerifyState != current.otpVerifyState) || (previous.otpResendState != current.otpResendState),
      listener: (context, state) {
        OtpAuthState? otpVerifyState = state.otpVerifyState;
        OtpAuthState? otpResendState = state.otpResendState;
        if (otpVerifyState != null) {
          processVerifyState(otpVerifyState);
        } else if (otpResendState != null) {
          processResendState(otpResendState);
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
              title ?? AppTranslate.i18n.otpTitleInputOtpStr.localized,
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
                  keyboardAppearance: Brightness.light,
                  onChanged: (value) {
                    if (otpCode.length >= 6 && value.length >= 6) {
                      return;
                    }
                    otpCode = value;
                    if (otpTimeout > 0) {
                      setState(() {
                        errorMessage = '';
                      });
                    }
                    if (otpCode.length == 6 && otpTimeout > 0) {
                      if (!isLoading) {
                        isLoading = true;
                        showLoading();
                        setTimeout(() {
                          context.read<OtpBloc>().add(
                              OtpEventVerify(otpCode: otpCode, otpSession: otpSession ?? '', username: username ?? ''));
                        }, 1000);
                      }
                    }
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
                        borderSide: BorderSide(color: Color.fromRGBO(186, 205, 223, 1.0), width: 1)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(186, 205, 223, 1.0), width: 1),
                    ),
                  ),
                  maxLength: 6,
                  showCursor: false,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(height: 20),
            StateBuilder(
              routeName: AuthOTPScreen.routeName,
              builder: () => Text(
                '${otpTimeout}s',
                style: const TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(102, 102, 103, 1.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
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
            const SizedBox(height: 90),
            Touchable(
              onTap: () {
                setState(() {
                  errorMessage = '';
                });
                context.read<OtpBloc>().add(OtpEventResend(otpSession: otpSession ?? '', username: username ?? ''));
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
}
