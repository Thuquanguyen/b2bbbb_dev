import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/config.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/smart_otp/transaction_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manage_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/pin_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_active_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_intro_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_list_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/term/term_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:b2b/utilities/message_handler.dart' as mh;

part 'smart_otp_config.dart';

class SmartOTPManager {
  factory SmartOTPManager() => _instance;

  SmartOTPManager._() {
    Logger.debug('SMART OTP INIT');
  }

  List<SmartOTPResult> results = buildResult();
  static final _instance = SmartOTPManager._();

  final _platform = const MethodChannel('com.vpbank/smart_otp_channel');

  String _username = '';
  String _userId = '';

  Map<String, bool> usersHasActive = {};

  bool isAppActivated = false;
  bool isAppLoggedIn = false;

  void logout() {
    isAppLoggedIn = false;
  }

  void setAppActivated(bool value) {
    isAppActivated = value;
  }

  void checkError() {
    if (_username.isEmpty) {
      throw 'UserName is empty';
    }
  }

  SmartOTPResult? getResult(int code) {
    for (int i = 0; i < results.length; i++) {
      if (results[i].code == code) {
        return results[i];
      }
    }
    return null;
  }

  TransactionModel getInfoFromTransactionData(String qr) {
    final qrData = qr.split('#');
    if (qrData.length == 2) {
      final transactionInfoArr = qrData.first.split('|');
      final transactionData = qrData.last;
      try {
        if (transactionInfoArr.length == 5) {
          final transactionId = transactionInfoArr[2];
          final int transactionTypeID = int.parse(transactionInfoArr[3]);
          const int transactionStatus = 2;
          final challenge = transactionInfoArr.last;
          return TransactionModel(
              responseCode: 0,
              transactionID: transactionId,
              challenge: challenge,
              transactionStatusID: transactionStatus,
              transactionData: transactionData,
              userID: _userId,
              transactionTypeID: transactionTypeID,
              message: AppTranslate.i18n.titleSuccessStr.localized);
        }
      } catch (e) {
        Logger.debug(e);
      }
    }
    return TransactionModel(responseCode: -1);
  }

  Future<bool> getCheckReviewOTPIntro() async {
    try {
      return await LocalStorageHelper.getBool(CHECK_REVIEW_OTP_INTRO) ?? false;
    } catch (e) {
      Logger.debug("cache : ${e}");
      return false;
    }
  }

  void saveCheckReviewOTPIntro() async {
    try {
      await LocalStorageHelper.setBool(CHECK_REVIEW_OTP_INTRO, true);
    } catch (e) {
      Logger.debug("cache : ${e}");
    }
  }

  void verifyOTP(
    BuildContext context,
    VerifyOTPArgs data, {
    required Function(bool isSuccess, OtpVerifyMadeFundState? data) onResult,
  }) {
    Map<String, dynamic> verifyOtpScreenArgs = {
      'data': data,
      'onResult': onResult,
    };
    if (data.verifyOtpDisplayType == 0) {
      pushNamed(
        context,
        VerifyOTPScreen.routeName,
        arguments: verifyOtpScreenArgs,
      );
    } else if (data.verifyOtpDisplayType == 1) {
      showOtpForUser(
        context,
        AccountManager().currentUsername,
        data: data,
        otpType: OtpType.ADVANCED,
        onResult: (isActivated, otpCode) {
          if (!isActivated) {
            pushNamed(
              context,
              VerifyOTPScreen.routeName,
              arguments: verifyOtpScreenArgs,
            );
          } else {
            verifyOtpScreenArgs['otpCode'] = otpCode;
            pushNamed(
              context,
              VerifyOTPScreen.routeName,
              arguments: verifyOtpScreenArgs,
              isTransparentRoute: otpCode != null,
            );
          }
        },
      );
    } else {
      verifyOtpScreenArgs['otpCode'] = '000000';
      pushNamed(
        context,
        VerifyOTPScreen.routeName,
        arguments: verifyOtpScreenArgs,
        isTransparentRoute: true,
      );
    }
  }

  void showRegisterSOTPScreen(BuildContext context) {
    setTimeout(() {
      pushNamed(context, SmartOTPIntroScreen.routeName, arguments: {
        'onNext': (BuildContext _context) {
          pushNamed(
            _context,
            TermScreen.routeName,
            arguments: TermModel(
              AppTranslate.i18n.homeTitleTermHeaderStr.localized,
              AppTranslate.i18n.urlOtpTermStr.localized,
              () {
                pushReplacementNamed(
                  context,
                  SmartOTPActiveScreen.routeName,
                );
              },
            ),
          );
        }
      });
    }, 300);
  }

  Future<void> showOtpForUser(BuildContext context, String username,
      {Function(bool isActivated, String? otpCode)? onResult,
      OtpType? otpType,
      VerifyOTPArgs? data}) async {
    Logger.debug('showOtpForUser');
    showLoading();
    SmartOTPManager().setCurrentUser(username);
    var isActivated = await SmartOTPManager().checkUserIdExistence();

    Logger.debug('isActivated : $isActivated');
    if (!isActivated && onResult != null) {
      hideLoading();
      onResult.call(false, null);
      return;
    } else {

      var isActivatedInOtherDevice =
          await SmartOTPManager().checkAppActivated2();

      Logger.debug('isActivatedInOtherDevice $isActivatedInOtherDevice');

      hideLoading();
      if (isActivatedInOtherDevice == true) {
        if (SessionManager().isLoggedIn()) {
          showDialogCustom(
            context,
            AssetHelper.icoSmartOtpDialog,
            AppTranslate.i18n.dialogTitleNotificationStr.localized,
            AppTranslate
                .i18n.sotpActivatedOtherDeviceDialogContentStr.localized,
            button1: renderDialogTextButton(
              context: context,
              title: AppTranslate.i18n.dialogButtonSkipStr.localized,
              onTap: () {
                onResult?.call(true, null);
              },
            ),
            button2: renderDialogButtonIcon(
              context: context,
              title: AppTranslate.i18n.titleRegisterStr.localized,
              icon: AssetHelper.icoSmartOtp,
              dismiss: true,
              onTap: () async {
                // await SmartOTPManager().deleteUser(_username);
                setTimeout(() {
                  showRegisterSOTPScreen(context);
                }, 300);
              },
            ),
          );
        } else {
          onResult?.call(false, null);
        }
        return;
      }

      await setSelectedUserId();

      String pin = await LocalStorageHelper.getOtpPinCode();
      pushNamed(
        context,
        PINScreen.routeName,
        arguments: PINScreenArgs(
          pinCode: pin,
          pinCodeType: PinScreenType.VERIFY_OTP,
          callback: () {
            pushReplacementNamed(context, SmartOTPScreen.routeName, arguments: {
              'data': data,
              'onResult': (otpCode) {
                onResult?.call(true, otpCode);
              },
              'otpType': otpType
            });
          },
        ),
      );
    }
  }

  Future<void> startMain(BuildContext context, Function? callback) async {
    // String? pin = await LocalStorageHelper.getOtpPinCode();
    // if (pin == null || pin.isEmpty) {
    pushNamed(
      context,
      SmartOTPListScreen.routeName,
      arguments: AccountManageArgument((type) {
        callback?.call(type);
      }),
    );
    // } else {
    //   pushNamed(
    //     context,
    //     PINScreen.routeName,
    //     arguments: PINScreenArgs(
    //       pinCode: pin,
    //       pinCodeType: PinScreenType.VERIFY_OTP,
    //       callback: () {
    //         pushReplacementNamed(
    //           context,
    //           SmartOTPListScreen.routeName,
    //           arguments: AccountManageArgument(
    //             (type) {
    //               callback?.call(type);
    //             },
    //           ),
    //         );
    //       },
    //     ),
    //   );
    // }
  }

  void showTermAndCondition(BuildContext context) {
    pushNamed(
      context,
      TermScreen.routeName,
      arguments: TermModel(
        AppTranslate.i18n.homeTitleTermHeaderStr.localized,
        AppTranslate.i18n.urlOtpTermStr.localized,
        null,
      ),
    );
  }

  Future<void> showChangePinScreen(BuildContext context) async {
    String? pin = await LocalStorageHelper.getOtpPinCode();
    if (pin == null) {
      showToast(AppTranslate.i18n.accountMangeTitleNotActivePinStr.localized);
      return;
    }
    pushNamed(
      context,
      PINScreen.routeName,
      arguments: PINScreenArgs(
        pinCode: pin,
        pinCodeType: PinScreenType.VERIFY_OTP_FOR_CHANGE,
        callback: () {
          pushReplacementNamed(
            context,
            PINScreen.routeName,
            arguments: PINScreenArgs(
              pinCodeType: PinScreenType.SETUP_PIN_OTP,
              callback: () {
                popScreen(context);
                showToast(AppTranslate.i18n.titleChangePinSuccessStr.localized);
              },
            ),
          );
        },
      ),
    );
  }

  bool canActiveSOTP(User user) {
    return user.enableSmartotp == true;
  }

  Future<bool> isActivatedSOTP(User user) async {
    Logger.debug('isActivatedSOTP $_userId User name ${user.username}');
    setCurrentUser(user.username ?? '');
    if (_userId.isNotNullAndEmpty && usersHasActive[_userId] == true) {
      return true;
    }
    return false;
  }

  void markUserActive(bool activated) {
    Logger.debug('markUserActive ${_userId} value $activated');
    if (_userId.isNotNullAndEmpty) {
      usersHasActive[_userId] = activated;
    }
  }

  Future<void> checkNeedActivationSOTP(BuildContext context, User user,
      {bool force = false, bool isFirstTime = true}) async {
    Logger.debug('checkNeedActivationSOTP');
    if (user.enableSmartotp == true) {
      setCurrentUser(user.username ?? '');
      bool isActivated = false;
      if (isFirstTime) {
        isActivated = await SmartOTPManager().checkUserIdExistence();
      } else {
        isActivated = usersHasActive[_userId] ?? false;
      }

      if (force == true) {
        showRegisterSOTPScreen(context);
        return;
      }

      if (!isActivated) {
        setTimeout(() {
          showDialogCustom(
            context,
            AssetHelper.icoSmartOtpDialog,
            AppTranslate.i18n.sotpNotActiveDialogTitleStr.localized,
            AppTranslate.i18n.sotpNotActiveDialogContentStr.localized,
            button1: renderDialogTextButton(
                context: context,
                title: AppTranslate.i18n.dialogButtonCancelStr.localized),
            button2: renderDialogButtonIcon(
              context: context,
              title: AppTranslate.i18n.titleRegisterStr.localized,
              icon: AssetHelper.icoSmartOtp,
              dismiss: true,
              onTap: () {
                showRegisterSOTPScreen(context);
              },
            ),
          );
        }, 500);
      }
    }
  }

  void deactivateSOTP() async {
    Logger.debug('deactivateSOTP');
    await deleteUser(AccountManager().currentUsername);
    markUserActive(false);
    mh.MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
  }

  void setCurrentUser(String username) {
    _username = username.toUpperCase();
    _userId = '$SOTP_PREFIX$_username';
  }

  Future<void> setSelectedUserId() async {
    try {
      await _platform.invokeMethod('setSelectedUserId', {'user_id': _userId});
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
  }

  Future<void> setPIN(String pin) async {
    try {
      String _pin = await LocalStorageHelper.getOtpPinCode();
      if (_pin.isNullOrEmpty) {
        await _platform.invokeMethod('setPIN', {'pin': pin});
        LocalStorageHelper.setOtpPinCode(pin);
      }
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
  }

  Future<void> changePIN(String pin, String newPin) async {
    try {
      final code = await loginPIN(pin);
      if (code == 0) {
        await _platform
            .invokeMethod('changePIN', {'pin': pin, 'new_pin': newPin});
      }
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
  }

  Future<int> loginPIN(String pin) async {
    try {
      if (!SmartOTPManager().isAppLoggedIn) {
        int code = await _platform.invokeMethod('loginPIN', {'pin': pin});
        if (code == 0) {
          isAppLoggedIn = true;
        }
        return code;
      } else {
        return 0;
      }
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return -1;
  }

  Future<String> getOTP() async {
    try {
      String code = await _platform.invokeMethod('getOTP');
      return code;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return '------';
  }

  Future<int> doActive(String activeCode) async {
    try {
      final deviceToken = SessionManager().deviceToken;
      final int result = await _platform.invokeMethod('doActive', {
        'active_code': '$SOTP_PREFIX$activeCode',
        'push_token': deviceToken,
        'app_id': SOTP_APP_ID,
        'active_url': getKeyPassUrl(),
      });
      Logger.debug('active code: $result');
      markUserActive(result == 0);
      //reload setting screen

      if (result == 0) {
        mh.MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
      }

      return result;
    } on PlatformException catch (error) {
      log('error: ${error.message}');
    }
    return -1;
  }

  Future<void> deleteAllExistingTokens() async {
    try {
      await _platform.invokeMethod('deleteAllExistingTokens');
      await LocalStorageHelper.clearOtpPinCode();
      setAppActivated(false);
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
  }

  Future<bool> checkUserIdExistence() async {
    if (_username.isEmpty) {
      throw 'UserName is empty';
    }
    try {
      if (isAppActivated == false) {
        isAppActivated = await SmartOTPManager().checkAppActivated();
      }
      Logger.debug(
          '--------------------------- isAppActivated $isAppActivated');
      var isActivated = false;
      String pin = await LocalStorageHelper.getOtpPinCode();
      if (isAppActivated) {
        int loginCode = 0;

        if (isAppLoggedIn == false) {
          loginCode = await SmartOTPManager().loginPIN(pin);
        }

        if (loginCode != 0) {
          deleteAllExistingTokens();
          isAppActivated = false;
        } else {
          if (Platform.isAndroid) {
            String jsStr = await _platform.invokeMethod(
              'getListUser',
            );
            isActivated = jsStr.contains(_userId.toUpperCase());
          } else {
            isActivated = await _platform.invokeMethod(
              'checkUserIdExistence',
              {'user_id': _userId},
            );
          }
        }
      }
      markUserActive(isActivated);
      return isActivated;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return false;
  }

  Future<bool> checkAppActivated() async {
    try {
      print('checkAppActivated checkAppActivated checkAppActivated');
      if (!SmartOTPManager().isAppActivated) {
        final bool appActivated =
            await _platform.invokeMethod('checkAppActivated');
        Logger.debug('\nisAppActivated $appActivated');
        setAppActivated(appActivated);
        return appActivated;
      } else {
        return true;
      }
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return false;
    }
  }

  Future<bool> checkAppActivated2() async {
    try {
      final String result = await _platform
          .invokeMethod('checkAppActivated2', {'user_id': _userId});
      Logger.debug(result);
      final tokenInfo = jsonDecode(result);
      if (tokenInfo is Map<String, dynamic>) {
        int responseCode = tokenInfo['responseCode'] as int;
        if (responseCode == 0) {
          final data = tokenInfo['data'] as Map<String, dynamic>;
          int status = data['status'];
          return status == 2;
        }
      }
      return false;
    } on Exception catch (error) {
      Logger.debug('error: ${error.toString()}');
      return false;
    }
  }

  Future<bool> deleteUser(String? username) async {
    if (username.isNullOrEmpty) {
      return true;
    }
    try {
      Logger.debug('deleteUser start');
      setCurrentUser(username!);
      final bool appActivatedInOtherDevice = await _platform
          .invokeMethod('deleteUserByUserId', {'user_id': _userId});
      Logger.debug('deleteUser result $appActivatedInOtherDevice');
      return appActivatedInOtherDevice;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return false;
    }
  }

  Future<bool> checkActivatedPIN() async {
    try {
      final bool pinActivated =
          await _platform.invokeMethod('checkActivatedPIN', {});
      return pinActivated;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return false;
  }

  Future<String?> getSelectedUserId() async {
    try {
      final String userId = await _platform.invokeMethod('getSelectedUserId');
      return userId;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return null;
    }
  }

  Future<String> getTokenSn() async {
    try {
      final String token = await _platform.invokeMethod('getTokenSn');
      return token;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return '';
  }

  Future<int> getCurrentServerTime() async {
    try {
      final int serverTime =
          await _platform.invokeMethod('getCurrentServerTime');
      return serverTime;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return -1;
  }

  Future<String> getCRotpWithTransaction(
      String transInfo, String challengeCode) async {
    try {
      final String code = await _platform.invokeMethod(
          'getCRotpWithTransaction',
          {'transaction_info': transInfo, 'challenge_code': challengeCode});
      return code;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return '------';
  }

  Future<int> getTimeStep() async {
    try {
      final int timeStep = await _platform.invokeMethod('getTimeStep');
      return timeStep;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return 60;
  }

  Future<TransactionModel?> getTransactionInfo(
      String transId, String messId) async {
    try {
      final String transInfo = await _platform.invokeMethod(
          'getTransactionInfo',
          {'transaction_id': transId, 'message_id': messId});
      Map<String, dynamic> json = jsonDecode(transInfo);
      return TransactionModel.fromJson(json);
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return null;
    }
  }

  Future<int?> doSyncTime() async {
    try {
      final int resultCode = await _platform.invokeMethod('doSyncTime');
      return resultCode;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return null;
    }
  }

  Future<int?> synchronizeSoftOtp() async {
    try {
      final int resultCode = await _platform
          .invokeMethod('synchronizeSoftOtp', {'user_id': _userId});
      return resultCode;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return null;
    }
  }

  // customize functions

  // Future<void> setCurrentUserId(String userId) async {
  //   try {
  //     await _platform.invokeMethod('setCurrentUserId', {'user_id', userId});
  //   } on PlatformException catch (error) {
  //     Logger.debug('error: ${error.message}');
  //   }
  // }

  Future<bool> isHadActivatedUserOnDevice() async {
    try {
      final bool result =
          await _platform.invokeMethod('isHadActivatedUserOnDevice');
      return result;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return false;
    }
  }

  Future<bool> checkUserActivatedAnyDevices(String userId) async {
    try {
      final bool result = await _platform
          .invokeMethod('checkUserActivatedAnyDevices', {'user_id', userId});
      return result;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return false;
    }
  }

  Future<bool> checkActivatedUserIsLoggingIn() async {
    try {
      final bool result = await _platform
          .invokeMethod('checkActivatedUserIsLoggingIn', {'user_id', _userId});
      return result;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return false;
    }
  }

  Future<bool> checkTokenIsValid() async {
    try {
      final bool result = await _platform.invokeMethod('checkTokenIsValid');
      return result;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return false;
    }
  }

  Future<String?> getUserNameActivated(bool masked) async {
    try {
      final String userName = await _platform
          .invokeMethod('getUserNameActivated', {'masked': masked});
      return userName;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return null;
    }
  }

  Future<String?> getFullNameActivated(bool masked) async {
    try {
      final String fullName = await _platform
          .invokeMethod('getFullNameActivated', {'masked': masked});
      return fullName;
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
      return null;
    }
  }

  Future<String> decryptQRCode(String qrCodeString) async {
    log('decryptQRCode $qrCodeString');
    try {
      final tmp = qrCodeString.split('|');
      if (tmp.length == 2) {
        log('user ${tmp[0]}');
        final String transInfo = await _platform.invokeMethod(
            'decryptQRCodeDataWithUserId',
            {'user_id': tmp[0], 'qr_code_string': tmp[1]});
        log('transInfo');
        log(transInfo);
        return transInfo;
      }
    } on PlatformException catch (error) {
      Logger.debug('error: ${error.message}');
    }
    return '';
  }
}
