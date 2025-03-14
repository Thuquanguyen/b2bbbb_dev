import 'dart:async';

import 'package:b2b/app_manager.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/config.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/core/api_service/http_client.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/auth/session_model.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionManager {
  factory SessionManager() => _instance;
  AuthenBloc? _authenBloc;
  BuildContext? _context;
  StreamSubscription? sessionTimeout;
  String deviceToken = '';

  SessionManager._();

  bool doingChangePassword = false;

  static final _instance = SessionManager._();

  void start(BuildContext context) {
    Logger.debug('-----------start SessionManager');
    _context = context;
    AppManager().checkRoot(context);
  }

  BuildContext? get getContext => _context;

  void clear() {
    _sessionId = null;
    userData = null;
    HomeActionManager().clearActiveAction();
    RolePermissionManager().clearPermission();
  }

  void stop() {
    clear();
    if (sessionTimeout != null) {
      clearTimeout(sessionTimeout!);
      sessionTimeout = null;
    }
  }

  void setSessionId(String sessionId) {
    Logger.debug('SESSION_ID $sessionId');
    _sessionId = sessionId;
    HttpClient.setSessionId(_sessionId);
  }

  String? getSessionId() {
    HttpClient.setSessionId(_sessionId);
    return _sessionId;
  }

  bool isLoggedIn() {
    return _sessionId.isNotNullAndEmpty;
  }

  void setUserData(SessionModel _userData) {
    userData = _userData;
    RolePermissionManager().getUserRole(_userData);
  }

  void hasAction() {
    if (AppConfig.buildType == BuildType.DEV) return;
    if (sessionTimeout != null) {
      clearTimeout(sessionTimeout!);
      sessionTimeout = null;
    }
    sessionTimeout = setTimeout(() {
      if (!SessionManager().isLoggedIn()) {
        return;
      }
      logout(isSessionTimeOut: true);
    }, EXPIRED_TIME);
  }

  Future<SessionModel?> load() async {
    userData = await SessionModel.getSessionData();
    return userData;
  }

  void logout({bool isSessionTimeOut = false, String? message, bool showAskDialog = false}) {
    if (showAskDialog) {
      if (_context == null) {
        return;
      }
      showDialogCustom(
        _context!,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        AppTranslate.i18n.dialogMessageAskLogoutStr.localized,
        button2: renderDialogTextButton(
          context: _context!,
          title: AppTranslate.i18n.homeButtonLogoutStr.localized,
          onTap: () {
            bool showAskFeedBack = AppManager().remoteConfigModel?.allowFeedback ?? false;
            if (showAskFeedBack) {
              doLogout(
                isSessionTimeOut: false,
                message: AppTranslate.i18n.feedbackMessageStr.localized,
                action: (context) {
                  pushNamed(
                    context,
                    WebViewScreen.routeName,
                    arguments: WebViewArgs(
                      url: AppManager().remoteConfigModel?.surveyUrl ?? 'https://www.surveymonkey.com/r/8HSLSFL',
                      title: AppTranslate.i18n.homeTitleFeedbackStr.localized,
                    ),
                  );
                },
              );
            } else {
              doLogout(isSessionTimeOut: false);
            }
          },
        ),
        button1: renderDialogTextButton(
          context: _context!,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
        ),
      );
    } else {
      doLogout(isSessionTimeOut: isSessionTimeOut, message: message);
    }
  }

  void doLogout({bool isSessionTimeOut = false, String? message, Function? action}) async {
    if (_context == null) {
      return;
    }

    Logger.debug('doLogout');

    SmartOTPManager().logout();

    // to close all snackbar is show on
    ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
    showLoading();
    _authenBloc ??= BlocProvider.of<AuthenBloc>(_context!);
    if (_authenBloc != null) {
      _authenBloc!.add(AuthenEventLogOut());
    }
    setTimeout(() {
      hideLoading();
      if (isSessionTimeOut) {
        popScreen(_context!,
            routeName: ReLoginScreen.routeName,
            arguments: {SESSION_TIMEOUT: true, SESSION_MESSAGE: message},
            animation: false);
      } else if (message != null) {
        popScreen(_context!,
            routeName: ReLoginScreen.routeName,
            arguments: {LOGOUT_EVENT: true, LOGOUT_EVENT_MESSAGE: message, LOGOUT_EVENT_ACTION: action},
            animation: false);
      } else {
        popScreen(_context!, routeName: ReLoginScreen.routeName, animation: false);
      }
      stop();
    }, 500);
  }

  SessionModel? userData;
  String? _sessionId;
}
