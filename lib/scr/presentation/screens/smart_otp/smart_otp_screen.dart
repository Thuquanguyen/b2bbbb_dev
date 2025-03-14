import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/core/smart_otp/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/qr_code_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

enum OtpType { SMS_EMAIL, BASIC, ADVANCED, NONE }

extension OtpTypeExtention on OtpType {
  int get value {
    switch (this) {
      case OtpType.SMS_EMAIL:
        return 0;
      case OtpType.BASIC:
        return 2;
      case OtpType.ADVANCED:
        return 1;
      default:
        return -1;
    }
  }

  OtpType getValueOf(int code) {
    switch (code) {
      case 0:
        return OtpType.SMS_EMAIL;
      case 2:
        return OtpType.BASIC;
      case 1:
        return OtpType.ADVANCED;
      default:
        return OtpType.NONE;
    }
  }
}

class SmartOTPScreen extends StatefulWidget {
  const SmartOTPScreen({Key? key}) : super(key: key);
  static String routeName = 'smart_otp_screen';

  @override
  _SmartOTPScreenState createState() => _SmartOTPScreenState();
}

int SOTP_TIME = 0;
int TIME_STEP = 0;

class _SmartOTPScreenState extends State<SmartOTPScreen> with WidgetsBindingObserver {
  StateHandler stateHandler = StateHandler(SmartOTPScreen.routeName);

  Function? onResult;
  VerifyOTPArgs? verifyData;
  OtpType? verifyOTPType;

  int otpTimeout = SOTP_TIME;
  OtpType _otpType = OtpType.ADVANCED;
  String otpCode = '------';
  String qrCodeString = '';
  String tokenSn = '';
  int startTime = 0;
  String transactionData = '', challenge = '', transId = '', messId = '';
  TransactionModel? transactionInfo;

  // PermissionStatus _permissionStatus = PermissionStatus.denied;

  // ignore: prefer_typing_uninitialized_variables
  Timer? timer;
  StreamSubscription? timeOut;

  Future<void> decode() async {
    transactionInfo = null;
    transId = '';
    messId = '';
    if (qrCodeString.isNotEmpty) {
      String resData = await SmartOTPManager().decryptQRCode(qrCodeString);
      Logger.debug('qrCodeStringDecode $resData');
      if (resData.isNotEmpty) {
        // transactionData = resData;
        transactionInfo = SmartOTPManager().getInfoFromTransactionData(resData);
        if (transactionInfo != null && transactionInfo?.responseCode == 0) {
          getOTP();
          return;
        }
      }
      showToast(AppTranslate.i18n.smartOtpQrCodeIncorrectStr.localized);
    }
  }

  Future<void> getOTP() async {
    TIME_STEP = await SmartOTPManager().getTimeStep();
    int currentServerTime = await SmartOTPManager().getCurrentServerTime() * 1000;
    SOTP_TIME = TIME_STEP - DateTime.fromMillisecondsSinceEpoch(currentServerTime).second;
    startTime = DateTime.now().millisecondsSinceEpoch;
    otpTimeout = SOTP_TIME;
    if (_otpType == OtpType.BASIC) {
      otpCode = await SmartOTPManager().getOTP();
      tokenSn = await SmartOTPManager().getTokenSn();
      stateHandler.refresh();
    } else {
      // stateHandler.refresh();
      // setTimeout(() async {
        transactionInfo ??= await SmartOTPManager().getTransactionInfo(transId, messId);
        if (transactionInfo != null && transactionInfo?.responseCode == 0) {
          transactionData = transactionInfo?.transactionData ?? '';
          challenge = transactionInfo?.challenge ?? '';
          transId = transactionInfo?.transactionID ?? '';
        } else {
          return;
        }
        String code = await SmartOTPManager().getCRotpWithTransaction(transactionData, challenge);
        tokenSn = await SmartOTPManager().getTokenSn();
        otpCode = code.toString();
        stateHandler.refresh();
      // }, 300);
    }
  }

  void keepAlive() {
    if (timeOut != null) {
      clearTimeout(timeOut!);
      timeOut = null;
    }
    timeOut = setTimeout(() {
      stopOtp(needAlert: true);
    }, 180000);
  }

  void runCountdown() {
    if (otpTimeout > 0) {
      otpTimeout = SOTP_TIME - ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000).round();
      if (otpTimeout > SOTP_TIME) otpTimeout = SOTP_TIME;
      stateHandler.refresh();
    } else {
      getOTP();
    }
  }

  Future<void> startOtp() async {
    keepAlive();
    if (timer != null) {
      clearInterval(timer!);
      timer = null;
    }
    timer = setInterval(() {
      runCountdown();
    }, 500);
    getOTP();
  }

  Future<void> stopOtp({bool needAlert = false}) async {
    if (timer != null) {
      clearInterval(timer!);
      timer = null;
    }
    if (needAlert == true) {
      showDialogCustom(
        context,
        AssetHelper.icoForgotPass,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        AppTranslate.i18n.smartOtpUseQuestionStr.localized,
        barrierDismissible: false,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
          onTap: () {
            popScreen(context);
          },
        ),
        button2: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.containerItemContinueStr.localized.toUpperCase(),
          onTap: () {
            startOtp();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    startOtp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    if (timer != null) {
      clearInterval(timer!);
      timer = null;
    }
    if (timeOut != null) {
      clearTimeout(timeOut!);
      timeOut = null;
    }

  }

  void pressORCode() {
    if (_otpType == OtpType.ADVANCED) {
      pushNamed(context, QRCodeScreen.routeName, arguments: {
        'onResult': (data) {
          Logger.debug('QRCODE $data');
          qrCodeString = data;
          setTimeout(() {
            decode();
          }, 300);
        }
      });
    }
  }

  // Future<void> requestPermission(Permission permission) async {
  //   _permissionStatus = await permission.request();
  // }

  @override
  Widget build(BuildContext context) {
    verifyData = getArgument<VerifyOTPArgs>(context, 'data');
    onResult = getArgument<Function>(context, 'onResult');
    verifyOTPType = getArgument<OtpType>(context, 'otpType');
    if (verifyOTPType != null) {
      _otpType = verifyOTPType!;
    }
    return AppBarContainer(
      title: 'Smart OTP',
      appBarType: AppBarType.MEDIUM,
      onTapDown: () {
        keepAlive();
      },
      child: Column(
        children: [
          Container(
            // height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 36),
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 58,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'smart_otp_code'.localized,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('smart_otp_auto_update_later'.localized,
                              style: const TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 14)),
                        ],
                      ),
                      StateBuilder(
                        builder: () {
                          return CircularPercentIndicator(
                            radius: 58.0,
                            lineWidth: 3.5,
                            percent: TIME_STEP > 0 ? max(otpTimeout,0) / TIME_STEP : 0.0,
                            center: Text(otpTimeout.toString(),
                                style: const TextStyle(
                                    fontFamily: 'sans-serif', fontSize: 22, color: Color.fromRGBO(102, 102, 103, 1.0))),
                            progressColor: Colors.green,
                            backgroundColor: Colors.grey.shade100,
                          );
                        },
                        routeName: SmartOTPScreen.routeName,
                      ),
                      Text('smart_otp_minus'.localized,
                          style: const TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                  child: StateBuilder(
                      routeName: SmartOTPScreen.routeName,
                      builder: () {
                        return Text(
                          otpCode,
                          style: const TextStyle(
                            letterSpacing: 8,
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(102, 102, 103, 1.0),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 16,
                ),
                //TODO: Ma phe duyet
                StateBuilder(
                  builder: () {
                    return SizedBox(
                      height: 24,
                      child: (_otpType == OtpType.ADVANCED && otpCode.isNotEmpty && otpCode != '------')
                          ? Text(
                              AppTranslate.i18n.smartOtpVerifyCodeStr.localized + ': ' + challenge,
                              style: TextStyles.smallText.greenColor,
                            )
                          : null,
                    );
                  }, routeName: SmartOTPScreen.routeName,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kBoxShadowCommon],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(width: 0.5, color: Colors.black12)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20),
            child: StateBuilder(
              builder: () {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'S/N: $tokenSn',
                          style: TextStyles.smallText.greenColor,
                        ),
                        Text(
                          DateFormat('kk:mm:ss dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(startTime)),
                          style: TextStyles.smallText.greenColor,
                        )
                      ],
                    ),
                  ],
                );
              },
              routeName: SmartOTPScreen.routeName,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Html(data: AppTranslate.i18n.smartOtpMessageWarningStr.localized),
          ),
          StateBuilder(
            builder: () {
              return Touchable(
                onTap: () async {
                  // if(await Permission.camera.isGranted) {
                  pressORCode();
                  // } else {
                  //   requestPermission(Permission.camera);
                  // }
                },
                child: SizedBox(
                  height: 40,
                  child: _otpType == OtpType.ADVANCED
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code,
                              size: 30,
                              color: AppColors.gPrimaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Scan QR CODE", style: TextStyles.gHeader.greenColor),
                          ],
                        )
                      : null,
                ),
              );
            },
            routeName: SmartOTPScreen.routeName,
          ),
          const Spacer(),
          if (verifyOTPType != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundedButtonWidget(
                title: AppTranslate.i18n.cotpsConfirmStr.localized.toUpperCase(),
                onPress: () {
                  if (otpCode.isNotEmpty && otpCode != '------') onResult?.call(otpCode);
                },
              ),
            ),
          if (verifyOTPType == null)
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
          if (verifyOTPType == null)
            StateBuilder(
                routeName: SmartOTPScreen.routeName,
                holder: 'sotp_tabbar',
                builder: () {
                  return Container(
                    height: 54 + SizeConfig.bottomSafeAreaPadding,
                    padding: EdgeInsets.only(bottom: SizeConfig.bottomSafeAreaPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          width: 0.5,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Touchable(
                          onTap: () {
                            if (_otpType != OtpType.ADVANCED) {
                              _otpType = OtpType.ADVANCED;
                              otpCode = '------';
                              tokenSn = '';
                              getOTP();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageHelper.loadFromAsset(
                                  AssetHelper.icoSotpAdvanced,
                                  width: 26,
                                  height: 24,
                                  tintColor: _otpType == OtpType.ADVANCED ? Colors.green : Colors.black38,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  AppTranslate.i18n.smartOtpAdvancedStr.localized,
                                  style: TextStyles.semiBoldText
                                      .setColor(_otpType == OtpType.ADVANCED ? Colors.green : Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Touchable(
                          onTap: () {
                            if (_otpType != OtpType.BASIC) {
                              _otpType = OtpType.BASIC;
                              getOTP();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageHelper.loadFromAsset(
                                  AssetHelper.icoSotpBasic,
                                  width: 24,
                                  height: 24,
                                  tintColor: _otpType == OtpType.BASIC ? Colors.green : Colors.black38,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  AppTranslate.i18n.smartOtpNormalStr.localized,
                                  style: TextStyles.semiBoldText
                                      .setColor(_otpType == OtpType.BASIC ? Colors.green : Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        // widget is resumed
        startOtp();
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        stopOtp();
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }
}
