import 'dart:developer';
import 'dart:io';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:b2b/commons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/auth/biometric_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/first_login_screen.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';

import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:local_auth/local_auth.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/utilities/message_handler.dart';

enum PinScreenType {
  VERIFY_APP,
  VERIFY_APP_FOR_CHANGE,
  VERIFY_OTP,
  VERIFY_OTP_FOR_CHANGE,
  SETUP_PIN_APP,
  SETUP_PIN_CONFIRM_APP,
  SETUP_PIN_OTP,
  SETUP_PIN_CONFIRM_OTP,
  SETTING_SETUP_PIN_APP,
  SETTING_SETUP_PIN_CONFIRM_APP,
}

class PINScreenArgs {
  final String pinCode;
  final PinScreenType pinCodeType;
  final Function? callback;

  // ignore: sort_constructors_first
  PINScreenArgs(
      {this.pinCodeType = PinScreenType.VERIFY_APP,
      this.pinCode = '',
      this.callback});

  String toString() {
    return '[pinCode=$pinCode, pinCodeType=${pinCodeType}, callback=$callback]';
  }
}

class PINScreen extends StatefulWidget {
  const PINScreen({Key? key}) : super(key: key);
  static const String routeName = 'pin_screen';

  @override
  _PINScreenState createState() => _PINScreenState();
}

class _PINScreenState extends State<PINScreen> {
  var callback = () {};
  String pinCode = '';
  int pinCodeCount = 5;
  String errorMessage = '';
  late PINScreenArgs? pinCodeScreenArgs;
  StateHandler? _handler;

  final _titles = {
    PinScreenType.VERIFY_APP: AppTranslate.i18n.pinTitleConfirmStr.localized,
    PinScreenType.VERIFY_APP_FOR_CHANGE:
        AppTranslate.i18n.pinTitleConfirmStr.localized,
    PinScreenType.VERIFY_OTP: 'Smart OTP',
    //AppTranslate.i18n.pinTitleConfirmStr.localized,
    PinScreenType.VERIFY_OTP_FOR_CHANGE: 'Smart OTP',
    //AppTranslate.i18n.pinTitleConfirmStr.localized,
    PinScreenType.SETUP_PIN_APP: AppTranslate.i18n.pinTitleSetupStr.localized,
    PinScreenType.SETUP_PIN_CONFIRM_APP:
        AppTranslate.i18n.pinTitleConfirmStr.localized,
    PinScreenType.SETUP_PIN_OTP:
        AppTranslate.i18n.pinTitleSetupOtpStr.localized,
    PinScreenType.SETUP_PIN_CONFIRM_OTP:
        AppTranslate.i18n.pinTitleConfirmOtpStr.localized,
    PinScreenType.SETTING_SETUP_PIN_APP:
        AppTranslate.i18n.pinTitleSetupStr.localized,
    PinScreenType.SETTING_SETUP_PIN_CONFIRM_APP:
        AppTranslate.i18n.pinTitleConfirmStr.localized,
  };

  final _message = {
    PinScreenType.VERIFY_APP:
        AppTranslate.i18n.pinMessageInputUseAppStr.localized,
    PinScreenType.VERIFY_APP_FOR_CHANGE:
        AppTranslate.i18n.pinMessageInputUseAppOldStr.localized,
    PinScreenType.VERIFY_OTP:
        AppTranslate.i18n.pinMessageInputUseOTPStr.localized,
    PinScreenType.VERIFY_OTP_FOR_CHANGE:
        AppTranslate.i18n.pinMessageInputUseOTPOldStr.localized,
    PinScreenType.SETUP_PIN_APP:
        AppTranslate.i18n.pinMessageSetupPinAndNextStr.localized,
    PinScreenType.SETUP_PIN_CONFIRM_APP:
        AppTranslate.i18n.pinMessageSetupAgainStr.localized,
    PinScreenType.SETUP_PIN_OTP:
        AppTranslate.i18n.pinMessageSetupPinAndNextStr.localized,
    PinScreenType.SETUP_PIN_CONFIRM_OTP:
        AppTranslate.i18n.pinMessageSetupAgainStr.localized,
    PinScreenType.SETTING_SETUP_PIN_APP:
        AppTranslate.i18n.pinMessageSetupPinAndNextStr.localized,
    PinScreenType.SETTING_SETUP_PIN_CONFIRM_APP:
        AppTranslate.i18n.pinMessageSetupAgainStr.localized,
  };

  @override
  Widget build(BuildContext context) {
    pinCodeScreenArgs = getArguments<PINScreenArgs>(context);
    log(pinCodeScreenArgs.toString());
    _handler ??= StateHandler(PINScreen.routeName + hashCode.toString());
    return BlocConsumer<AuthenBloc, AuthenState>(
      listenWhen: (previous, current) =>
          previous.registerState != current.registerState,
      listener: (context, state) {
        if (state.registerState == DataState.preload) {
          showLoading();
        } else if (state.registerState == DataState.data) {
          setTimeout(() {
            hideLoading();
          }, 300);
          if (state.registerStatus == AuthenStatus.SUCCESS) {
            LocalStorageHelper.setAppPinCode(pinCode);
            LocalStorageHelper.setString(AuthenType.PINCODE.name,
                state.registerModel?.data?.authenPasswd ?? '');
            setTimeout(() {
              if (pinCodeScreenArgs?.pinCodeType ==
                  PinScreenType.SETUP_PIN_CONFIRM_APP) {
                nextScreen();
              } else if (pinCodeScreenArgs?.pinCodeType ==
                  PinScreenType.SETTING_SETUP_PIN_CONFIRM_APP) {
                popScreen(context);
                showToast(
                    AppTranslate.i18n.authPinLoginSetupSuccessStr.localized);
              }
            }, 200);
          } else {
            errorMessage = state.registerModel?.result?.getMessage() ?? '';
            _handler?.refresh();
          }
        } else if (state.registerState == DataState.error) {}
      },
      builder: (context, state) {
        return AppBarContainer(
          title: _titles[pinCodeScreenArgs?.pinCodeType],
          onBack: () async {
            if (pinCodeScreenArgs?.pinCodeType == PinScreenType.SETUP_PIN_APP ||
                pinCodeScreenArgs?.pinCodeType ==
                    PinScreenType.SETUP_PIN_CONFIRM_APP) {
              await AccountManager().loadUsers();
              if (AccountManager().getUsers().isNotEmpty) {
                pushReplacementNamed(context, ReLoginScreen.routeName,
                    animation: false);
              } else {
                pushReplacementNamed(context, FirstLoginScreen.routeName,
                    animation: false);
              }
            } else {
              Navigator.of(context).pop();
            }
          },
          appBarType: AppBarType.FULL,
          child: buildScreen(context),
        );
      },
    );
  }

  Widget buildScreen(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 20.toScreenSize,
          right: 20.toScreenSize,
          top: 6.toScreenSize,
          bottom: 8.toScreenSize),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(_message[pinCodeScreenArgs?.pinCodeType] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)),
          ),
          const SizedBox(
            height: 8,
          ),
          const Spacer(),
          StateBuilder(
            builder: () => renderDot(context),
            routeName: PINScreen.routeName + hashCode.toString(),
          ),
          const Spacer(),
          StateBuilder(
            builder: () {
              return Container(
                  height: 42,
                  alignment: Alignment.center,
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepOrange),
                  ));
            },
            routeName: PINScreen.routeName + hashCode.toString(),
          ),
          const Spacer(),
          renderNumPad(context),
          const Spacer(),
          Touchable(
            onTap: () async {
              if (pinCodeScreenArgs?.pinCodeType ==
                  PinScreenType.SETUP_PIN_APP) {
                //khong su dung pin
                LocalStorageHelper.setAppPinCode('');
                LocalStorageHelper.setString(AuthenType.PINCODE.name, '');
                await nextScreen();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Text(
                pinCodeScreenArgs?.pinCodeType == PinScreenType.SETUP_PIN_APP
                    ? AppTranslate.i18n.pinTitleNotUseStr.localized
                    : '',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget renderDot(BuildContext context) {
    final List<bool> pinMark = [false, false, false, false];
    for (int i = 0; i < pinCode.length; i++) {
      pinMark[i] = true;
    }
    return SizedBox(
      width: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: pinMark
            .map((bool e) => Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: e == true ? Colors.white70 : Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ))
            .toList(),
      ),
    );
  }

  Future<void> nextScreen() async {
    final localAuth = LocalAuthentication();
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics =
        (await localAuth.getAvailableBiometrics()).cast<BiometricType>();
    Logger.debug('canCheckBiometrics ${availableBiometrics.isNotEmpty}');
    setTimeout(() {
      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        pushReplacementNamed(context, BiometricScreen.routeName);
      } else {
        pushReplacementNamed(context, MainScreen.routeName, animation: true);
      }
    }, 300);
  }

  processSetUpApp() {
    showLoading();
    setTimeout(() {
      hideLoading();
      pushReplacementNamed(
        context,
        PINScreen.routeName,
        animation: false,
        arguments: PINScreenArgs(
          pinCodeType:
              pinCodeScreenArgs?.pinCodeType == PinScreenType.SETUP_PIN_APP
                  ? PinScreenType.SETUP_PIN_CONFIRM_APP
                  : PinScreenType.SETTING_SETUP_PIN_CONFIRM_APP,
          pinCode: pinCode,
        ),
      );
    }, 300);
  }

  processConfirmApp() {
    if (pinCode != pinCodeScreenArgs?.pinCode) {
      showLoading();
      setTimeout(() {
        hideLoading();
        errorMessage = AppTranslate.i18n.pinMessageNotDuplicateStr.localized;
        pinCode = '';
        _handler?.refresh();
      }, 200);
    } else {
      setTimeout(() {
        context
            .read<AuthenBloc>()
            .add(AuthenEventRegisterLoginType(authenType: AuthenType.PINCODE));
      }, 200);
    }
  }

  void processVerifyApp() {
    if (pinCodeScreenArgs?.pinCode == pinCode) {
      if (pinCodeScreenArgs?.callback != null) {
        setTimeout(() {
          pinCodeScreenArgs?.callback?.call();
        }, 100);
      }
    } else {
      setTimeout(() {
        pinCodeCount--;
        pinCode = '';
        errorMessage = AppTranslate.i18n.pinMessageIncorrectStr.localized +
            ' $pinCodeCount ' +
            AppTranslate.i18n.pinMessageTurnStr.localized;
        if (pinCodeCount <= 0) {
          showLoading();
          setTimeout(() {
            hideLoading();
            popScreen(context);
          }, 500);
        }
        _handler?.refresh();
      }, 300);
    }
  }

  processSetUpOtp() {
    showLoading();
    setTimeout(() {
      hideLoading();
      pushReplacementNamed(
        context,
        PINScreen.routeName,
        animation: false,
        arguments: PINScreenArgs(
          pinCodeType: PinScreenType.SETUP_PIN_CONFIRM_OTP,
          pinCode: pinCode,
          callback: pinCodeScreenArgs?.callback,
        ),
      );
    }, 300);
  }

  processConfirmOtp() async {
    if (pinCode != pinCodeScreenArgs?.pinCode) {
      showLoading();
      setTimeout(() {
        hideLoading();
        errorMessage = AppTranslate.i18n.pinMessageNotDuplicateStr.localized;
        pinCode = '';
        _handler?.refresh();
      }, 200);
    } else {
      if (pinCode.isNotEmpty) {
        SmartOTPManager().setPIN(pinCode);
      } else {
        showToast("Cannot setting OTP Pin Code");
        return;
      }
      setTimeout(() {
        MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
        showDialogCustom(
          context,
          AssetHelper.icoSmartOtpDialog,
          AppTranslate.i18n.sotpActivatedDialogTitleStr.localized,
          AppTranslate.i18n.sotpActivatedDialogContentStr.localized,
          button1: renderDialogButtonIcon(
            context: context,
            title: AppTranslate.i18n.titleGotitStr.localized,
            icon: AssetHelper.icoSmartOtp,
            dismiss: true,
            onTap: () {
              setTimeout(() {
                popScreen(context);
              }, 300);
            },
          ),
        );
      }, 500);
    }
  }

  Future<void> processVerifyOtp() async {
    if (pinCodeScreenArgs?.pinCode == pinCode) {
      // int code = await SmartOTPManager().loginPIN(pinCode);
      // SmartOTPResult? result = SmartOTPManager().getResult(code);
      // if (result != null && result.isSuccess()) {
        if (pinCodeScreenArgs?.callback != null) {
          setTimeout(() {
            pinCodeScreenArgs?.callback?.call();
          }, 500);
        }
      // } else {
      //   if (result != null) {
      //     errorMessage = result.message.localization();
      //   } else {
      //     errorMessage = AppTranslate.i18n.authTitleErrorStr.localized;
      //   }
      //   _handler?.refresh();
      // }
    } else {
      setTimeout(() {
        pinCodeCount--;
        pinCode = '';
        errorMessage = AppTranslate.i18n.pinMessageIncorrectStr.localized +
            ' $pinCodeCount ' +
            AppTranslate.i18n.pinMessageTurnStr.localized;
        if (pinCodeCount <= 0) {
          showLoading();
          setTimeout(() {
            hideLoading();
            showDialogCustom(
                context,
                AssetHelper.icoAuthError,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                AppTranslate.i18n.sotpAccountDisableStr.localized,
                barrierDismissible: false,
                showCloseButton: false,
                button1: renderDialogTextButton(
                    context: context,
                    title: AppTranslate.i18n.dialogButtonCloseStr.localized,
                    onTap: () {
                      SmartOTPManager().deleteUser(AccountManager().currentUsername);
                      popScreen(context);
                    }));
          }, 500);
        }
        _handler?.refresh();
      }, 300);
    }
  }

  void pressDelete() {
    pinCode = pinCode.substring(0, pinCode.length - 1);
    _handler?.refresh();
  }

  void pressNum(String num) {
    pinCode = '$pinCode$num';
    errorMessage = '';
    if (pinCode.length == 4) {
      if (pinCodeScreenArgs?.pinCodeType == PinScreenType.SETUP_PIN_APP ||
          pinCodeScreenArgs?.pinCodeType ==
              PinScreenType.SETTING_SETUP_PIN_APP) {
        processSetUpApp();
      } else if (pinCodeScreenArgs?.pinCodeType ==
              PinScreenType.SETUP_PIN_CONFIRM_APP ||
          pinCodeScreenArgs?.pinCodeType ==
              PinScreenType.SETTING_SETUP_PIN_CONFIRM_APP) {
        processConfirmApp();
      } else if (pinCodeScreenArgs?.pinCodeType ==
          PinScreenType.SETUP_PIN_OTP) {
        processSetUpOtp();
      } else if (pinCodeScreenArgs?.pinCodeType ==
          PinScreenType.SETUP_PIN_CONFIRM_OTP) {
        processConfirmOtp();
      } else if (pinCodeScreenArgs?.pinCodeType == PinScreenType.VERIFY_OTP ||
          pinCodeScreenArgs?.pinCodeType ==
              PinScreenType.VERIFY_OTP_FOR_CHANGE) {
        processVerifyOtp();
      } else if (pinCodeScreenArgs?.pinCodeType == PinScreenType.VERIFY_APP ||
          pinCodeScreenArgs?.pinCodeType ==
              PinScreenType.VERIFY_APP_FOR_CHANGE) {
        processVerifyApp();
      }
    }
    _handler?.refresh();
  }

  Widget renderButtonNumber(BuildContext context, String num) {
    return Container(
      width: getInScreenSize(78, max: 78),
      height: getInScreenSize(78, max: 78),
      decoration: BoxDecoration(
          border: Border.all(
            color:
                num == '' || num == 'DEL' ? Colors.transparent : Colors.white70,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(
            getInScreenSize(39, max: 39),
          ))),
      child: num.isNotEmpty
          ? ElevatedButton(
              style: ButtonStyle(
                  animationDuration: const Duration(milliseconds: 50),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(getInScreenSize(39, max: 39)),
                    ),
                  )),
              child: Text(
                num == 'DEL' ? '⌫' : num,
                style: TextStyle(
                  fontFamily: 'sans-serif',
                  color: Colors.white,
                  fontWeight:
                      Platform.isAndroid ? FontWeight.w300 : FontWeight.w200,
                  fontSize: (Platform.isAndroid && num == 'DEL') ? 26 : 34,
                ),
              ),
              onPressed: () {
                if (num != '' && num != 'DEL' && pinCode.length < 4) {
                  pressNum(num);
                } else if (num == 'DEL' && pinCode.isNotEmpty) {
                  pressDelete();
                }
              },
            )
          : SizedBox(
              height: getInScreenSize(78, max: 78),
              width: getInScreenSize(78, max: 78),
            ),
    );
  }

  Widget renderNumPad(BuildContext context) {
    final List<String> numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'DEL'
    ];
    return Container(
      width: getInScreenSize(310, max: 310),
      height: getInScreenSize(420, max: 420),
      alignment: Alignment.center,
      child: Wrap(
        runAlignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: getInScreenSize(26, max: 26),
        runSpacing: getInScreenSize(26, max: 26),
        children: [
          ...numbers.map((String e) => renderButtonNumber(context, e)).toList()
        ],
      ),
    );
  }
}
