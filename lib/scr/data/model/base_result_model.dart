import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/presentation/screens/settings/change_password_screen.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'base_result_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseResultModel {
  BaseResultModel({
    this.code,
    this.messageVi,
    this.messageEn,
    this.appIosVersion,
    this.appAndroidVersion,
    this.apiVersion,
  }) {
    //Check session expried
    if (code == '403') {
      Logger.debug('Your session has been expired');
      if (SessionManager().isLoggedIn()) {
        SessionManager().clear();
        SessionManager().logout(isSessionTimeOut: true, message: getMessage());
      }
    } else if (code == '202') {
      // Force change password

      if (SessionManager().getContext != null &&
          SessionManager().doingChangePassword == false) {
        SessionManager().doingChangePassword = true;
        pushNamed(SessionManager().getContext!, ChangePasswordScreen.routeName,
            arguments: {'needLogout': true});
      }
    }
  }

  factory BaseResultModel.fromJson(Map<String, dynamic> json) =>
      _$BaseResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResultModelToJson(this);

  String? code;
  String? messageVi;
  String? messageEn;
  String? appIosVersion;
  String? appAndroidVersion;
  String? apiVersion;

  String getMessage({String defaultValue = ''}) {
    return (AppTranslate().currentLanguage == SupportLanguages.Vi
            ? messageVi
            : messageEn) ??
        defaultValue;
  }

  bool isSuccess() => code == null
      ? false
      : RegExp(r'^2[0-9]{2}').hasMatch(code!) && code!.length == 3;
}
