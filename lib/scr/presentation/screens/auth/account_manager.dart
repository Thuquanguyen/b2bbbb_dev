// ignore_for_file: constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/auth/biometric_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/pin_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/verify_user_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/widgets.dart';

class AccountManager {
  factory AccountManager() => _instance;

  AccountManager._();

  static final _instance = AccountManager._();
  final List<User> _users = [];
  final Map<String, bool> _usernames = {};
  String currentUsername = '';
  late User currentUser;

  List<User> getUsers() {
    return _users;
  }

  bool hasUser(String username) {
    Logger.debug('--- hasUser $_usernames $username');
    return (_usernames.containsKey(username) && _usernames[username] == true);
  }

  List<User> getUsersForSOTP() {
    List<User> _list = [];
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].enableSmartotp == true) {
        _list.add(_users[i]);
      }
    }
    Logger.debug(_list);
    return _list;
  }

  Future<void> loadUsers() async {
    String jsString = await LocalStorageHelper.getUsers();
    currentUsername = await LocalStorageHelper.getCurrentUser() ?? '';
    List<dynamic> _list = jsonDecode(jsString);
    _users.clear();
    _users.addAll(_list.map((item) => User.fromJson(item)).toList());

    bool check = false;
    if (currentUsername.isNotEmpty && _users.isNotEmpty) {
      for (int i = 0; i < _users.length; i++) {
        if (_users[i].username != null) {
          _usernames[_users[i].username!] = true;
        }
        if (currentUsername == _users[i].username) {
          currentUser = _users[i];
          check = true;
        }
      }
    }

    if ((currentUsername.isEmpty || check == false) && _users.isNotEmpty) {
      currentUsername = _users[_users.length - 1].username ?? '';
      currentUser = _users[_users.length - 1];
      LocalStorageHelper.setCurrentUser(currentUsername);
    }
  }

  void saveUsersToLocal() {
    MessageHandler().notify(RELOAD_SESSION);
    List<Map<String, dynamic>> _list = User.toJsonArray(_users);
    String jsString = jsonEncode(_list);
    LocalStorageHelper.saveUsers(jsString);
  }

  void setCurrentUser(User user) {
    currentUser = user;
    currentUsername = user.username!;

    for (int i = 0; i < _users.length; i++) {
      if (_users[i].isEqual(user)) {
        _users[i] = user;
        saveUsersToLocal();
        return;
      }
    }
    if (user.username != null) {
      _users.add(user);
    }
    saveUsersToLocal();
  }

  void setCurrentUsername(String? username) {
    currentUsername = username ?? '';
    LocalStorageHelper.setCurrentUser(currentUsername);
  }

  void removeUser(User user) {
    if (user.username != null) {
      _usernames[user.username!] = true;
    }
    int item = -1;
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].isEqual(user)) {
        item = i;
        break;
      }
    }
    if (item >= 0) {
      _users.removeAt(item);
      saveUsersToLocal();
    }
    if (user.username == currentUsername) {
      if (_users.isNotEmpty) {
        User _user = _users[0];
        currentUsername = _user.username ?? '';
        LocalStorageHelper.setCurrentUser(currentUsername);
      }
    }
    if (_users.isEmpty) {
      currentUsername = '';
      LocalStorageHelper.setCurrentUser(currentUsername);
    }
  }
}

class User {
  User(
      {required this.username,
      required this.fullName,
      required this.companyName,
      required this.enableSmartotp,
      this.roleCode});

  String? username;
  String? fullName;
  String? companyName;
  bool? enableSmartotp;
  String? roleCode;

  bool isEqual(User user) {
    return user.username == username;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String?,
      fullName: json['fullName'] as String?,
      roleCode: json['roleCode'] as String?,
      companyName: json['companyName'] as String?,
      enableSmartotp: json['enableSmartotp'] as bool?,
    );
  }

  static Map<String, dynamic> toJsonObject(User instance) => <String, dynamic>{
        'username': instance.username,
        'fullName': instance.fullName,
        'companyName': instance.companyName,
        'enableSmartotp': instance.enableSmartotp,
        'roleCode': instance.roleCode,
      };

  static List<Map<String, dynamic>> toJsonArray(List<User> list) =>
      list.map((instance) => User.toJsonObject(instance)).toList();

  static Future<AuthenType> getAuthenTypeAvailable() async {
    return await AuthManager().initBiometric();
  }

  static Future<bool> isActivatedFaceId() async {
    final String? faceIdToken =
        await LocalStorageHelper.getString(AuthenType.FACEID.name);
    return faceIdToken != null && faceIdToken.isNotEmpty;
  }

  static Future<bool> isActivatedPinCode() async {
    final String? pinCodeToken =
        await LocalStorageHelper.getString(AuthenType.PINCODE.name);
    return pinCodeToken != null && pinCodeToken.isNotEmpty;
  }

  static Future<bool> isActivatedTouchId() async {
    final String? touchIdToken =
        await LocalStorageHelper.getString(AuthenType.TOUCHID.name);
    return touchIdToken != null && touchIdToken.isNotEmpty;
  }

  static void activatedFaceId(BuildContext context) {
    verifyUser(context, () {
      pushReplacementNamed(context, BiometricScreen.routeName,
          arguments: {'screen_type': BiometricScreenType.SETUP});
    });
  }

  static Future<void> activatedPinCode(BuildContext context) async {
    verifyUser(context, () async {
      bool _isActivatedPinCode = await isActivatedPinCode();
      if (!_isActivatedPinCode) {
        pushReplacementNamed(context, PINScreen.routeName,
            arguments: PINScreenArgs(
                pinCodeType: PinScreenType.SETTING_SETUP_PIN_APP));
      } else {
        String pinCode = await LocalStorageHelper.getAppPinCode();
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.accountMangeTitleActiveLoginWithPinStr.localized,
          button1: renderDialogTextButton(
              context: context,
              title: AppTranslate.i18n.dialogButtonCancelStr.localized),
          button2: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.containerItemContinueStr.localized,
            onTap: () {
              pushNamed(
                context,
                PINScreen.routeName,
                arguments: PINScreenArgs(
                  pinCode: pinCode,
                  pinCodeType: PinScreenType.VERIFY_APP_FOR_CHANGE,
                  callback: () {
                    popScreen(context);
                    deactivatedPinCode();
                  },
                ),
              );
            },
          ),
        );
      }
    });
  }

  static void activatedTouchId(BuildContext context) {
    verifyUser(context, () {
      pushReplacementNamed(context, BiometricScreen.routeName,
          arguments: {'screen_type': BiometricScreenType.SETUP});
    });
  }

  static void deactivatedFaceId() {
    LocalStorageHelper.setString(AuthenType.FACEID.name, '');
    MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
  }

  static void verifyUser(BuildContext context, Function callback,
      {String? title}) {
    pushNamed(context, ReLoginUserScreen.routeName,
        arguments: VerifyUserArgs(
            title: title ?? AppTranslate.i18n.confirmPassTitleStr.localized,
            onResult: () {
              callback.call();
            }));
  }

  static void deactivatedPinCode() {
    LocalStorageHelper.setString(AuthenType.PINCODE.name, '');
    MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
  }

  static void deactivatedTouchId() {
    LocalStorageHelper.setString(AuthenType.TOUCHID.name, '');
    MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
  }

  static Future<void> showChangePinScreen(BuildContext context) async {
    String? pin = await LocalStorageHelper.getAppPinCode();
    if (pin == null) {
      showToast(AppTranslate.i18n.accountMangeTitleNotActivePinStr.localized);
      return;
    }
    pushNamed(
      context,
      PINScreen.routeName,
      arguments: PINScreenArgs(
        pinCode: pin,
        pinCodeType: PinScreenType.VERIFY_APP_FOR_CHANGE,
        callback: () {
          pushReplacementNamed(
            context,
            PINScreen.routeName,
            arguments: PINScreenArgs(
              pinCodeType: PinScreenType.SETTING_SETUP_PIN_APP,
            ),
          );
        },
      ),
    );
  }
}
