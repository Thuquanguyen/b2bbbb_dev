import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_screen.dart';
import 'package:b2b/scr/presentation/widgets/custom_animation.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/vploading.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pointycastle/export.dart' as pc;

import 'constants.dart';

StreamSubscription setTimeout(Function callback, int milliseconds) {
  final future = Future.delayed(Duration(milliseconds: milliseconds));
  return future.asStream().listen((event) {}, onDone: () {
    callback();
  });
}

void clearTimeout(StreamSubscription subscription) {
  try {
    subscription.cancel();
  } catch (e) {
    Logger.debug(e.toString());
  }
}

Timer setInterval(Function callback, int milliseconds) {
  return Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
    callback();
  });
}

void clearInterval(Timer subscription) {
  try {
    subscription.cancel();
  } catch (e) {
    Logger.debug(e);
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

IOSAuthMessages getIOSAuthMessages(BiometricType biometricType) {
  return IOSAuthMessages(
    cancelButton: AppTranslate.i18n.biometricTitleCancelStr.localized,
    goToSettingsButton: AppTranslate.i18n.biometricTitleSettingStr.localized,
    goToSettingsDescription: biometricType == BiometricType.face
        ? AppTranslate.i18n.biometricTitleSettingFaceIDStr.localized
        : AppTranslate.i18n.biometricTitleSettingTouchIDStr.localized,
    lockOut: AppTranslate.i18n.biometricTitleOutTryAgainStr.localized,
  );
}

AndroidAuthMessages getAndroidAuthMessages(BiometricType biometricType) {
  return AndroidAuthMessages(
    cancelButton: AppTranslate.i18n.biometricTitleCancelStr.localized,
    goToSettingsButton: AppTranslate.i18n.biometricTitleSettingStr.localized,
    goToSettingsDescription: AppTranslate.i18n.biometricMessageSettingFingerprintStr.localized,
  );
}

String replaceTextToStyle(String content, List<String> titles) {
  String result = content;
  titles.forEach((element) {
    result = result.replaceAll(element, '<b style="color: #00b74f">$element</b>');
  });
  return result;
}

//Loading
const bg1 = Colors.black54; //Color.fromRGBO(5,166,88, 1.0); //Colors.green
const bg2 = Color.fromRGBO(255, 0, 0, 0.6);

void initLoadingStyle(BuildContext? context) {
  VPLoading().setContext(context);
  EasyLoading.instance
    // ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = bg1
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    // ..userInteractions = false
    // ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    // ..indicatorWidget = ImageHelper.loadAsset(AssetHelper.imgVPBankSplashLogo, width: 60, height: 40, fit: BoxFit.contain)
    ..customAnimation = CustomAnimation();
}

StreamSubscription? showLoadingTimeout = null;

void showLoading({
  String? status,
  Widget? indicator,
  bool? dismissOnTap,
  EasyLoadingMaskType? maskType = EasyLoadingMaskType.clear,
}) {
  if (EasyLoading.isShow) {
    return;
  }
  // EasyLoading.instance.progressColor = Colors.transparent;
  EasyLoading.instance.backgroundColor = bg1;
  EasyLoading.instance.boxShadow = <BoxShadow>[];
  EasyLoading.show(
      status: status,
      indicator: const SizedBox(width: 50, height: 50, child: VPBLoadingDialog()),
      dismissOnTap: dismissOnTap,
      maskType: maskType);
  // VPLoading().showLoading();
  if (showLoadingTimeout != null) {
    clearTimeout(showLoadingTimeout!);
    showLoadingTimeout = null;
  }
  showLoadingTimeout = setTimeout(() {
    hideLoading();
  }, 45000);
}

void showSuccess(
  String status, {
  Duration? duration,
  bool? dismissOnTap,
}) {
  EasyLoading.instance.backgroundColor = bg1;
  EasyLoading.showSuccess(status, duration: duration, dismissOnTap: dismissOnTap, maskType: EasyLoadingMaskType.clear);
}

void showError(
  String status, {
  Duration? duration,
  bool? dismissOnTap,
}) {
  EasyLoading.instance.backgroundColor = bg2;
  EasyLoading.showError(status, duration: duration, dismissOnTap: dismissOnTap, maskType: EasyLoadingMaskType.clear);
}

void showInfo(
  String status, {
  Duration? duration,
  bool? dismissOnTap,
}) {
  EasyLoading.showInfo(status, duration: duration, dismissOnTap: dismissOnTap, maskType: EasyLoadingMaskType.clear);
}

void showToast(String message) {
  EasyLoading.showToast(message);
}

void showProgress(
  double value, {
  String? status,
}) {
  EasyLoading.instance.backgroundColor = Colors.green;
  EasyLoading.showProgress(value, status: status, maskType: EasyLoadingMaskType.clear);
}

void hideLoading() {
  if (showLoadingTimeout != null) {
    clearTimeout(showLoadingTimeout!);
    showLoadingTimeout = null;
  }
  // VPLoading().hideLoading();
  if (EasyLoading.isShow) {
    EasyLoading.dismiss();
  }
}

String getFeeTypeString(String type, String vatTitle) {
  switch (type) {
    case 'OUR':
      return AppTranslate.i18n.transferCostStr.localized.interpolate({'vat': vatTitle});
    case 'BEN':
      return AppTranslate.i18n.paidRecipientsStr.localized.interpolate({'vat': vatTitle});
    default:
      return '';
  }
}

String decryptAES(String data, String pwd) {
  final arrByte = encrypt.Encrypted.fromBase64(data);
  final key = encrypt.Key.fromUtf8(pwd);
  final iv = arrByte.bytes.sublist(0, 16);
  final dataByte = arrByte.bytes.sublist(16);
  final encryptedText = encrypt.Encrypted.fromBase64(base64Encode(dataByte));
  final ctr = pc.CTRStreamCipher(pc.AESFastEngine())..init(false, pc.ParametersWithIV(pc.KeyParameter(key.bytes), iv));
  Uint8List decrypted = ctr.process(encryptedText.bytes);
  return String.fromCharCodes(decrypted);
}

String encryptSha256(String data) {
  try {
    final bytesData = encrypt.Encrypted.fromUtf8(data).bytes;
    final sha256 = pc.SHA256Digest();
    return hex.encode(sha256.process(bytesData));
  } catch (e) {
    Logger.debug(e.toString());
  }
  return '';
}

String getLetterAvatar(String name) {
  final tmp = name.split(' ');
  if (tmp.length >= 2) {
    String tmp1 = tmp[0];
    String tmp2 = tmp[tmp.length - 1];
    return '${tmp1[0]}${tmp2[0]}'.toUpperCase();
  } else if (name.length > 1) {
    return '${name[0]}${name[1]}'.toUpperCase();
  } else {
    return name.toUpperCase();
  }
}

String convertDateFormat(String dateTimeString, String oldFormat, String newFormat) {
  DateFormat newDateFormat = DateFormat(newFormat);
  DateTime dateTime = DateFormat(oldFormat).parse(dateTimeString);
  String selectedDate = newDateFormat.format(dateTime);
  return selectedDate;
}

DateTime parseDateTime(String dateTimeString, String formatted) {
  DateTime dateTime = DateFormat(formatted).parse(dateTimeString);
  return dateTime;
}

class IgnoreCertificateErrorOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void initHttpSslIgnore() {
  HttpOverrides.global = IgnoreCertificateErrorOverrides();
}

bool isKeyboardShowing(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom > 0;
}

Map<ModuleAlert, String> getModuleAlert = {
  ModuleAlert.BALANCE: "balance_alert",
  ModuleAlert.TRANSFER: "transfer_alert",
  ModuleAlert.MAKETTING: "maketting_alert"
};

class VPLoading {
  static final VPLoading _singleton = VPLoading._internal();

  factory VPLoading() {
    return _singleton;
  }

  VPLoading._internal();

  BuildContext? _ctx;

  Future? _currentLoading;

  void setContext(BuildContext? context) {
    _ctx = context;
  }

  void showLoading() {
    if (_ctx != null && _currentLoading == null) {
      _currentLoading = showDialog(
        context: _ctx!,
        builder: (context) {
          return const VPBLoadingDialog();
        },
        barrierDismissible: false,
      ).then((_) => _currentLoading = null);
    }
  }

  void hideLoading() {
    if (_ctx != null && _currentLoading != null) {
      Navigator.of(_ctx!).pop();
    }
  }
}

void showDebitModelBottom(
    {List<DebitAccountModel>? dataList,
    required BuildContext context,
    DebitAccountModel? currSelected,
    Function(DebitAccountModel)? callBack}) {
  Logger.debug('showDebitModelBottom ${dataList?.length}');
  if (dataList != null && dataList.isNotEmpty) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: SizeConfig.screenHeight / 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                topRight: Radius.circular(kDefaultPadding),
              ),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kTopPadding),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: kBorderSide,
                    ),
                  ),
                  child: Text(
                    AppTranslate.i18n.chooseSourceAccountStr.localized,
                    style: TextStyles.headerText.inputTextColor,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: kBorderSide,
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            top: kDefaultPadding, bottom: kTopPadding),
                        child: AccountInfoItem(
                          prefixIcon: AssetHelper.icoWallet,
                          workingBalance: item.availableBalance
                                  ?.toInt()
                                  .toString()
                                  .toMoneyFormat ??
                              '0',
                          accountCurrency: item.accountCurrency,
                          accountNumber: item.getSubtitle(),
                          isLastIndex: true,
                          icon:
                              currSelected?.accountNumber == item.accountNumber
                                  ? AssetHelper.icoCheck
                                  : null,
                          margin: EdgeInsets.zero,
                          onPress: () {
                            callBack?.call(item);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
