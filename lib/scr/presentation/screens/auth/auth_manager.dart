part of 're_login_screen.dart';

class AuthManager {
  factory AuthManager() => _instance;

  AuthManager._();

  static final _instance = AuthManager._();

  bool isFirst = true;
  int maxRetryAuthBiometric = 1;

  LocalAuthentication localAuth = LocalAuthentication();
  late bool canCheckBiometrics;
  IOSAuthMessages? iosAuthMessages;
  AndroidAuthMessages? androidAuthMessages;
  String localizedReason = '';
  SessionModel? sessionModel;

  bool showPassword = false;
  bool isActiveFaceId = true;
  bool isActiveTouchId = true;
  bool isActivePinCode = true;

  String username = '';
  String password = '';
  String passwordToken = '';
  String pinCode = '';

  AuthenType authenType = AuthenType.PASSWORD;
  StateHandler? _stateHandler;

  Function(BuildContext _context)? _quickAction;
  Function(BuildContext _context)? _notifyAction;

  void quickAction(Function(BuildContext _context)? action) {
    _quickAction = action;
  }

  void notifyAction(Function(BuildContext _context)? action) {
    if (SessionManager().isLoggedIn()) {
      _notifyAction = null;
      if (SessionManager().getContext != null) {
        action?.call(SessionManager().getContext!);
      }
    } else {
      _notifyAction = action;
    }
  }

  bool doActionQueue(BuildContext _context) {
    if (_notifyAction != null) {
      setTimeout(() {
        _notifyAction?.call(_context);
        _notifyAction = null;
        _quickAction = null;
      }, 400);
      return true;
    } else if (_quickAction != null) {
      setTimeout(() {
        _quickAction?.call(_context);
        _quickAction = null;
        _notifyAction = null;
      }, 400);
      return true;
    } else {
      return false;
    }
  }

  void clear() {
    isFirst = true;
    showPassword = false;
    isActiveFaceId = true;
    isActiveTouchId = true;
    isActivePinCode = true;
    username = '';
    password = '';
    passwordToken = '';
    pinCode = '';
    authenType = AuthenType.PASSWORD;
  }

  Future<void> init(BuildContext context, StateHandler stateHandler) async {
    clear();
    SessionManager().setSessionId('');
    _stateHandler = stateHandler;
    await initBiometric();
    await checkLoginType(context);
    _stateHandler?.refresh();
  }

  Future<void> initSession() async {
    sessionModel = await SessionManager().load();
  }

  // ignore: avoid_void_async
  Future<AuthenType> initBiometric() async {
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics = (await localAuth.getAvailableBiometrics()).cast<BiometricType>();
    if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          iosAuthMessages = iosAuthMessages = getIOSAuthMessages(BiometricType.face);
          localizedReason = AppTranslate.i18n.biometricMessageUseFaceIDStr.localized;
          return AuthenType.FACEID;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          iosAuthMessages = getIOSAuthMessages(BiometricType.fingerprint);
          localizedReason = AppTranslate.i18n.biometricMessageUseTouchIDStr.localized;
          return AuthenType.TOUCHID;
        }
      } else {
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          androidAuthMessages = getAndroidAuthMessages(BiometricType.fingerprint);
          localizedReason = AppTranslate.i18n.biometricMessageSettingStr.localized;
          return AuthenType.TOUCHID;
        }
      }
    }
    return AuthenType.NONE;
  }

  Future<void> checkLoginType(BuildContext context) async {
    final String? faceIdToken = await LocalStorageHelper.getString(AuthenType.FACEID.name);
    final String? touchIdToken = await LocalStorageHelper.getString(AuthenType.TOUCHID.name);
    final String? pinCodeToken = await LocalStorageHelper.getString(AuthenType.PINCODE.name);
    final String? username = await LocalStorageHelper.getCurrentUser() ?? '';

    await initSession();

    pinCode = await LocalStorageHelper.getAppPinCode();
    if (username != null && username.isNotEmpty) {
      this.username = username;
      if (faceIdToken != null && faceIdToken.isNotEmpty && isActiveFaceId) {
        passwordToken = faceIdToken;
        authenType = AuthenType.FACEID;
      } else if (touchIdToken != null && touchIdToken.isNotEmpty && isActiveTouchId) {
        passwordToken = touchIdToken;
        authenType = AuthenType.TOUCHID;
        isActiveFaceId = false;
      } else if (pinCodeToken != null && pinCodeToken.isNotEmpty && pinCode != '' && isActivePinCode) {
        passwordToken = pinCodeToken;
        authenType = AuthenType.PINCODE;
        isActiveFaceId = false;
        isActiveTouchId = false;
      } else {
        isActiveFaceId = false;
        isActiveTouchId = false;
        isActivePinCode = false;
        authenType = AuthenType.PASSWORD;
      }
      _stateHandler?.refresh();
    } else {
      // await Navigator.of(context).pushReplacementNamed(FirstLoginScreen.routeName);
      pushReplacementNamed(context, FirstLoginScreen.routeName, animation: false);
    }
  }

  Future<void> changeToOtherMethod(BuildContext context) async {
    if (isActiveFaceId && maxRetryAuthBiometric > 0) {
      maxRetryAuthBiometric--;
      if (maxRetryAuthBiometric == 0) {
        maxRetryAuthBiometric = 1;
        isActiveFaceId = false;
      }
    } else if (isActiveTouchId && maxRetryAuthBiometric > 0) {
      maxRetryAuthBiometric--;
      if (maxRetryAuthBiometric == 0) {
        maxRetryAuthBiometric = 1;
        isActiveTouchId = false;
      }
    }
    await checkLoginType(context);
  }

  // ignore: avoid_void_async
  void authenByBiometric(BuildContext context, {Function? handleSuccess, Function? handleError}) async {
    try {
      if (canCheckBiometrics && (androidAuthMessages != null || iosAuthMessages != null)) {
        final bool author = await localAuth.authenticate(
          localizedReason: localizedReason,
          useErrorDialogs: true,
          androidAuthStrings: androidAuthMessages ?? const AndroidAuthMessages(),
          iOSAuthStrings: iosAuthMessages ?? const IOSAuthMessages(),
          biometricOnly: true,
        );
        log(author.toString());
        if (author) {
          handleSuccess?.call();
          return;
        }
      }
    } on PlatformException catch (e) {
      log(e.message ?? '');
      if (e.code == auth_error.notAvailable) {
        showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
            AppTranslate.i18n.authBiometricNotAvailableStr.localized,
            button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
      }
      if (e.code == auth_error.notEnrolled) {
        showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
            AppTranslate.i18n.authNotSetupBiometricsStr.localized,
            button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
      }
    }
    handleError?.call();
  }

  void processLoginResult(BuildContext context, AuthenState state, {bool isFirstLogin = false}) {
    log(state.toString());
    if (state.loginState == DataState.preload) {
      showLoading();
    } else if (state.loginState == DataState.data) {
      final message = state.loginModel?.result?.getMessage() ?? '';
      final otpSession = state.loginModel?.data?.otpSession ?? '';
      if (state.loginStatus == AuthenStatus.OTP) {
        AccountManager().setCurrentUsername(username);
        setTimeout(() {
          hideLoading();
        }, 300);
        setTimeout(() {
          Navigator.of(context).pushReplacementNamed(AuthOTPScreen.routeName,
              arguments: {'otp_session': otpSession, 'title': message, 'username': username});
        }, 400);
      } else if (state.loginStatus == AuthenStatus.SUCCESS) {
        final sessionId = state.loginModel?.data?.sessionId ?? '';
        AccountManager().setCurrentUsername(username);
        SessionManager().setSessionId(sessionId);
        if (isFirstLogin) {
          setTimeout(() {
            hideLoading();
          }, 300);
          setTimeout(() {
            pushReplacementNamed(context, PINScreen.routeName,
                arguments: PINScreenArgs(pinCodeType: PinScreenType.SETUP_PIN_APP));
          }, 400);
        } else {
          setTimeout(() {
            hideLoading();
          }, 300);
          setTimeout(() {
            if (authenType == AuthenType.PINCODE) {
              popScreen(context);
            }
            if (Navigator.of(context).canPop()) {
              pushReplacementNamed(context, MainScreen.routeName, animation: true);
            } else {
              pushNamed(context, MainScreen.routeName);
            }
          }, 500);
        }
      } else if (state.loginStatus == AuthenStatus.MAINTENANCE) {
        if (authenType == AuthenType.PINCODE) {
          popScreen(context);
        }
        hideLoading();
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleSystemIsMaintenanceStr.localized,
          AppTranslate.i18n.dialogMessageSystemIsMaintenanceStr.localized,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized,
          ),
        );
      } else if (state.loginStatus == AuthenStatus.BIOMETRIC_INVALID) {
        hideLoading();
        if (authenType == AuthenType.PINCODE) {
          popScreen(context);
          LocalStorageHelper.setString(AuthenType.PINCODE.name, '');
          LocalStorageHelper.setAppPinCode('');
        } else if (authenType == AuthenType.TOUCHID) {
          LocalStorageHelper.setString(AuthenType.TOUCHID.name, '');
        } else if (authenType == AuthenType.FACEID) {
          LocalStorageHelper.setString(AuthenType.FACEID.name, '');
        }
        if (!isFirstLogin) {
          setTimeout(() {
            checkLoginType(context);
          }, 300);
        }
        showDialogCustom(context, AssetHelper.icoForgotPass, AppTranslate.i18n.dialogTitleNotificationStr.localized,
            message.replaceAll('1900545415', '<b style="color: #00b74f">1900545415</b>'),
            button1: renderDialogTextButton(
                context: context,
                title: message.contains('1900545415')
                    ? 'dialog_button_cancel'.localized
                    : 'dialog_button_close'.localized),
            button2: message.contains('1900545415')
                ? renderDialogButtonIcon(
                    context: context,
                    title: '1900545415',
                    icon: AssetHelper.icoPhoneCall,
                    onTap: () {
                      launch('tel://1900545415');
                    })
                : null);
      } else {
        hideLoading();
        log('**********5');
        if (authenType == AuthenType.PINCODE) {
          popScreen(context);
        }
        showDialogCustom(context, AssetHelper.icoForgotPass, AppTranslate.i18n.dialogTitleNotificationStr.localized,
            message.replaceAll('1900545415', '<b style="color: #00b74f">1900545415</b>'),
            button1: renderDialogTextButton(
                context: context,
                title: message.contains('1900545415')
                    ? 'dialog_button_cancel'.localized
                    : 'dialog_button_close'.localized),
            button2: message.contains('1900545415')
                ? renderDialogButtonIcon(
                    context: context,
                    title: '1900545415',
                    icon: AssetHelper.icoPhoneCall,
                    onTap: () {
                      launch('tel://1900545415');
                    })
                : null);
        if (!isFirstLogin) {
          setTimeout(() {
            checkLoginType(context);
          }, 300);
        }
      }
    } else if (state.loginState == DataState.error) {
      if (authenType == AuthenType.PINCODE) {
        popScreen(context);
      }
      hideLoading();
      showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.dialogMessageLoginFailStr.localized,
          button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
    }
  }

  void processVerifyUserResult(BuildContext context, AuthenState state, {Function? onResult}) {
    log(state.toString());
    if (state.loginState == DataState.preload) {
      showLoading();
    } else if (state.loginState == DataState.data) {
      final message = state.loginModel?.result?.getMessage() ?? '';
      if (state.loginStatus == AuthenStatus.SUCCESS) {
        final sessionId = state.loginModel?.data?.sessionId ?? '';
        SessionManager().setSessionId(sessionId);
        hideLoading();
        setTimeout(() {
          onResult?.call();
        }, 400);
      } else {
        hideLoading();
        showDialogCustom(context, AssetHelper.icoForgotPass, AppTranslate.i18n.dialogTitleNotificationStr.localized,
            message.replaceAll('1900545415', '<b style="color: #00b74f">1900545415</b>'),
            button1: renderDialogTextButton(
                context: context,
                title: message.contains('1900545415')
                    ? 'dialog_button_cancel'.localized
                    : 'dialog_button_close'.localized),
            button2: message.contains('1900545415')
                ? renderDialogButtonIcon(
                    context: context,
                    title: '1900545415',
                    icon: AssetHelper.icoPhoneCall,
                    onTap: () {
                      launch('tel://1900545415');
                    })
                : null);
      }
    } else if (state.loginState == DataState.error) {
      hideLoading();
      showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.authTitleErrorStr.localized,
          button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
    }
  }

  void onLoginCallback(BuildContext context, AccountManageActionType type) {
    isActiveFaceId = true;
    isActiveTouchId = true;
    isActivePinCode = true;
    if (type == AccountManageActionType.ADD_NEW_ACCOUNT) {
      pushReplacementNamed(context, FirstLoginScreen.routeName, arguments: {'type': 'ADD'});
    } else {
      checkLoginType(context);
    }
  }

  void showAlertIfHas(BuildContext context) {
    bool isSessionTimeout = getArgument(context, SESSION_TIMEOUT) ?? false;
    String message =
        getArgument(context, SESSION_MESSAGE) ?? AppTranslate.i18n.dialogMessageLoginSessionExpiredStr.localized;
    bool isHasEvent = getArgument(context, LOGOUT_EVENT) ?? false;
    String? messageEvent = getArgument(context, LOGOUT_EVENT_MESSAGE);
    Function? eventAction = getArgument(context, LOGOUT_EVENT_ACTION);

    if (isSessionTimeout && isFirst) {
      Logger.debug('showAlertIfHas MESSAGE ');
      isFirst = false;
      setTimeout(() {
        showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
            message.isNotEmpty ? message : AppTranslate.i18n.dialogMessageLoginSessionExpiredStr.localized,
            button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
      }, 500);
      return;
    }
    if (isHasEvent && isFirst && messageEvent.isNotNullAndEmpty) {
      isFirst = false;
      setTimeout(() {
        showDialogCustom(
            context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized, messageEvent!,
            button1: renderDialogTextButton(
                context: context, title: AppTranslate.i18n.dialogButtonSkipStr.localized.toUpperCase()),
            button2: renderDialogTextButton(
                context: context,
                onTap: () {
                  eventAction?.call(context);
                },
                title: AppTranslate.i18n.continueStr.localized.toUpperCase()));
      }, 500);
      return;
    }
  }
}
