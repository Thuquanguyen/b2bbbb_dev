import 'dart:developer';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/pin_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
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
import 'package:flutter_html/flutter_html.dart';

// ignore: prefer_typing_uninitialized_variables
class SmartOTPActiveScreen extends StatefulWidget {
  const SmartOTPActiveScreen({Key? key}) : super(key: key);
  static const String routeName = 'smart_otp_active_screen';

  @override
  _SmartOTPActiveScreenState createState() => _SmartOTPActiveScreenState();
}

class _SmartOTPActiveScreenState extends State<SmartOTPActiveScreen> {
  final _controller = TextEditingController();

  // int otpTimeout = 60;
  String? title;
  String? otpSession;
  String? username;
  String? errorMessage = '';
  String? inputMessage;
  bool isFirst = true;
  final FocusNode focus = FocusNode();

  StateHandler stateHandler = StateHandler(SmartOTPActiveScreen.routeName);

  // late Timer timer;

  void runCountdown() {
    // if (otpTimeout > 0) {
    //   otpTimeout = otpTimeout - 1;
    //   stateHandler.refresh();
    //   if (otpTimeout == 0) {
    //     setState(() {
    //       errorMessage = 'otp_title_out_of_time_get_otp'.localized;
    //     });
    //     _controller.clear();
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    // timer = setInterval(() {
    //   runCountdown();
    // }, 1000);
  }

  @override
  void dispose() {
    super.dispose();
    // clearInterval(timer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unnecessary_null_comparison
    //
  }

  void loadFirst() {
    if (isFirst) {
      isFirst = false;
      setTimeout(() {
        getActivationCode();
      }, 300);
    }
  }

  void getActivationCode() {
    context.read<OtpBloc>().add(OtpEventGetActivationCodeSmartOTP());
  }

  @override
  Widget build(BuildContext context) {
    final args = getArguments(context);

    if (args != null) {
      title = args['title'] ?? '';
      otpSession = args['otp_session'] ?? '';
      username = args['username'] ?? '';
    }
    loadFirst();
    Logger.debug('render main otp screen');
    return BlocConsumer<OtpBloc, OtpState>(
        listenWhen: (previous, current) => previous.otpGetActiveSOTPState != current.otpGetActiveSOTPState,
        listener: (context, state) {
          var otpGetActiveSOTPState = state.otpGetActiveSOTPState;
          log(otpGetActiveSOTPState?.dataState?.toString() ?? '');
          if (otpGetActiveSOTPState?.dataState == DataState.preload) {
            showLoading();
          } else if (otpGetActiveSOTPState?.dataState == DataState.data) {
            hideLoading();
            if (otpGetActiveSOTPState?.status == OtpStatus.SUCCESS) {
              FocusScope.of(context).requestFocus(focus);
              inputMessage = otpGetActiveSOTPState?.message;
              stateHandler.refresh();
            } else {
              inputMessage = null;
              stateHandler.refresh();
              showDialogCustom(
                context,
                AssetHelper.icoAuthError,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                otpGetActiveSOTPState?.message ?? AppTranslate.i18n.smartOtpErrorActiveCodeStr.localized,
                button1: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.dialogButtonCloseStr.localized,
                  onTap: () {
                    FocusScope.of(context).requestFocus(focus);
                  },
                ),
                button2: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.biometricButtonTryAgainStr.localized,
                  onTap: () {
                    getActivationCode();
                  },
                ),
              );
            }
          } else if (otpGetActiveSOTPState?.dataState == DataState.error) {
            inputMessage = null;
            stateHandler.refresh();
            hideLoading();
            log(otpGetActiveSOTPState?.message ?? '');
            showDialogCustom(
              context,
              AssetHelper.icoAuthError,
              AppTranslate.i18n.dialogTitleNotificationStr.localized,
              AppTranslate.i18n.smartOtpErrorActiveCodeStr.localized,
              button1:
                  renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized),
            );
          } else {
            hideLoading();
          }
          // if (state.otpVerifyState == DataState.preload) {
          //   showLoading();
          // } else if (state.otpVerifyState == DataState.data) {
          //   Logger.debug(state.otpVerifyModel?.data?.toString());
          //   if (state.otpVerifyStatus == OtpStatus.SUCCESS) {
          //     showSuccess('otp_message_confirm'.localized);
          //     final sessionId = state.otpVerifyModel?.data?.sessionId ?? '';
          //     setTimeout(() {
          //       hideLoading();
          //       // LocalStorageHelper.sharedPreferenceSetString(SESSION_ID, sessionId);
          //       Navigator.of(context).pushReplacementNamed(PINScreen.routeName,
          //           arguments: AuthenScreenArgs(pinCodeType: PinScreenType.SETUP_PIN_APP));
          //     }, 500);
          //   } else {
          //     hideLoading();
          //     setState(() {
          //       otpTimeout = 0;
          //       errorMessage = state.otpVerifyModel?.result?.getMessage();
          //     });
          //   }
          // } else if (state.otpResendState == DataState.preload) {
          //   showLoading();
          // } else if (state.otpResendState == DataState.data) {
          //   if (state.otpResendStatus == OtpStatus.SUCCESS) {
          //     setTimeout(() {
          //       showToast('otp_send_again'.localized);
          //       hideLoading();
          //     }, 500);
          //     otpTimeout = 60;
          //     stateHandler.refresh();
          //   } else {
          //     setState(() {
          //       otpTimeout = 0;
          //       errorMessage = state.otpResendModel?.result?.getMessage();
          //     });
          //   }
          // }
        },
        builder: (context, state) {
          return AppBarContainer(
            title: AppTranslate.i18n.sotpActivationTitleStr.localized,
            appBarType: AppBarType.NORMAL,
            onTap: () {
              // FocusScope.of(context).unfocus();
            },
            onBack: () {
              // Navigator.of(context).pushReplacementNamed(FirstLoginScreen.routeName);
              // pushReplacementNamed(context, FirstLoginScreen.routeName, animation: false);
              popScreen(context);
            },
            child: buildScreen(context),
          );
        });
  }

  Future<void> doActive(String otp) async {
    final resultCode = await SmartOTPManager().doActive(otp);
    final result = SmartOTPManager().getResult(resultCode);
    setTimeout((){
      hideLoading();
    }, 300);
    setTimeout(() async {
      if (result?.isSuccess() == true) {
        String? pin = await LocalStorageHelper.getOtpPinCode();
        if (pin.isNullOrEmpty) {
          pushReplacementNamed(
            context,
            PINScreen.routeName,
            arguments: PINScreenArgs(pinCodeType: PinScreenType.SETUP_PIN_OTP),
          );
        } else {
          pushReplacementNamed(
            context,
            PINScreen.routeName,
            arguments: PINScreenArgs(
              pinCode: pin,
              pinCodeType: PinScreenType.SETUP_PIN_CONFIRM_OTP,
            ),
          );
        }
      } else {
        log(result.toString());
        if (result != null) {
          setTimeout(() {
            showDialogCustom(
              context,
              AssetHelper.icoAuthError,
              AppTranslate.i18n.dialogTitleNotificationStr.localized,
              result.message.localization(),
              button1: renderDialogTextButton(
                context: context,
                title: AppTranslate.i18n.dialogButtonCloseStr.localized,
              ),
            );
          }, 300);
        } else {}
      }
    }, 500);
  }

  Container buildScreen(BuildContext context) {
    return Container(
      // alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            height: getInScreenSize(220),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [kBoxShadowCommon],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: StateBuilder(
                    builder: () {
                      return Html(
                        data:
                            '<p style="text-align:center; color: #666">${title ?? inputMessage ?? AppTranslate.i18n.otpTitleInputOtpActivationCodeStr.localized}</p>',
                      );
                    },
                    routeName: SmartOTPActiveScreen.routeName,
                  ),
                ),
                // const Spacer(),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: 160,
                    height: 44,
                    child: AutofillGroup(
                      child: TextField(
                          keyboardAppearance: Brightness.light,
                          focusNode: focus,
                          onChanged: (value) {
                            final otp = value;
                            setState(() {
                              errorMessage = '';
                            });
                            if (otp.length == 6) {
                              hideKeyboard(context);
                              setTimeout(() {
                                showLoading();
                                setTimeout(() {
                                  doActive(otp);
                                }, 300);
                              }, 300);
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
                          autofocus: false,
                          keyboardType: TextInputType.number),
                    )),
                const Spacer(),
                Touchable(
                  onTap: () {
                    // setState(() {
                    //   errorMessage = '';
                    // });
                    // context
                    //     .read<OtpBloc>()
                    //     .add(OtpEventResend(otpSession: otpSession ?? '', username: username ?? ''));
                    hideKeyboard(context);
                    getActivationCode();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppTranslate.i18n.otpTitleGetActivationCodeAgainStr.localized,
                        style: const TextStyle(fontSize: 13, color: Color.fromRGBO(0, 183, 79, 1.0))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Html(
                data: AppTranslate.i18n.sotpActiveStr.localized,
              ),
            ),
          )
        ],
      ),
    );
  }
}
