import 'package:b2b/app_manager.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/config.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/navigator_observer.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/setting/list_account_setting_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/change_password_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/setting_manager.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

enum SettingScreenSection {
  GENERAL,
  SMART_OTP,
  NOTIFICATION,
}

class SettingScreenArgument {
  final List<SettingScreenSection> sections;

  SettingScreenArgument({required this.sections});
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String routeName = 'settings-screen';
  static const String SETTING_UPDATED_EVENT = 'SETTING_UPDATED_EVENT';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StateHandler _stateHandler = StateHandler(SettingsScreen.routeName);
  AuthenType authenType = AuthenType.NONE;
  bool isFaceIdActivated = false;
  bool isTouchIdActivated = false;
  bool isPinActivated = false;
  bool isSOTPAvailable = false;
  bool isSOTPActivated = false;

  // bool isNotiBalance = false;
  bool isNotiPending = false;
  bool isNotiStep1 = false;
  bool isNotiConfirm = false;
  bool isNotiWait = false;
  bool isNotiOther = false;

  bool needUpdate = false;

  @override
  void initState() {
    super.initState();
    MessageHandler()
        .addListener(SettingsScreen.SETTING_UPDATED_EVENT, reloadData);
    setTimeout(() {
      reloadData(force: true);
    }, 500);
    MessageHandler().addListener(ON_CHANGE_SCREEN, onChangeScreen);
  }

  void onChangeScreen(dynamic data) {
    if (data is String) {
      if (data == MainScreen.routeName && needUpdate) {
        needUpdate = false;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    MessageHandler()
        .removeListener(SettingsScreen.SETTING_UPDATED_EVENT, reloadData);
    MessageHandler().removeListener(ON_CHANGE_SCREEN, onChangeScreen);
    super.dispose();
  }

  Future<void> reloadData({bool force = false}) async {
    authenType = await User.getAuthenTypeAvailable();
    isFaceIdActivated = await User.isActivatedFaceId();
    isTouchIdActivated = await User.isActivatedTouchId();
    isPinActivated = await User.isActivatedPinCode();
    try{
      isSOTPAvailable =
          SmartOTPManager().canActiveSOTP(AccountManager().currentUser);
      isSOTPActivated =
      await SmartOTPManager().isActivatedSOTP(AccountManager().currentUser);
    }catch(e){}

    SettingManager().isNotificationActivated =
        await LocalStorageHelper.getBool(CHANGE_VIEW_BALANCE) ?? false;

    Logger.debug('reloadData isSOTPActivated $isSOTPActivated');
    // lắng nghe có thay đổi nhưn phải display
    if (force || getCurrentScreen() == MainScreen.routeName) {
      setState(() {});
    } else {
      needUpdate = true;
    }
  }

  Widget _buildSwitch({
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return Transform.scale(
      scale: 0.7,
      child: CupertinoSwitch(
        value: value,
        onChanged: (value) {
          onChanged?.call(!value);
        },
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildMenuItem({
    String? svgIcon,
    required String title,
    String? description,
    bool isSwitch = false,
    bool value = false,
    bool isActive = true,
    Function(bool)? onChanged,
    Function? onTap,
    double? overridePadding,
  }) {
    return Touchable(
      onTap: () {
        if (onTap != null && !isSwitch && isActive) onTap();
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: overridePadding ?? 25),
        child: Opacity(
          opacity: isActive ? 1 : 0.4,
          child: Row(
            children: [
              svgIcon != null ? SvgPicture.asset(svgIcon) : Container(),
              const SizedBox(
                width: 22,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: kStyleTextUnit,
                    ),
                    description != null
                        ? const SizedBox(
                            height: 5,
                          )
                        : Container(),
                    description != null
                        ? Text(
                            description,
                            style: kStyleTextSubtitle,
                          )
                        : Container(),
                  ],
                ),
              ),
              isSwitch
                  ? _buildSwitch(value: value, onChanged: onChanged)
                  : SvgPicture.asset(AssetHelper.icoForward1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: const Color.fromRGBO(237, 241, 246, 1.0),
    );
  }

  Widget _buildRateSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [kBoxShadowContainer],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            _buildMenuItem(
              svgIcon: AssetHelper.icoAlert,
              title: AppTranslate.i18n.stsFeedbackTitleStr.localized,
              onTap: () {
                pushNamed(
                  context,
                  WebViewScreen.routeName,
                  arguments: WebViewArgs(
                    url: 'https://bit.ly/vpb_ebiz_rate',
                    title: AppTranslate.i18n.stsFeedbackTitleStr.localized,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [kBoxShadowContainer],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            authenType == AuthenType.FACEID
                ? _buildMenuItem(
                    svgIcon: AssetHelper.icoFaceidSetting,
                    title: AppTranslate.i18n.stsLoginFaceidStr.localized,
                    isSwitch: true,
                    value: isFaceIdActivated,
                    onTap: () {
                      if (isFaceIdActivated) {
                        User.deactivatedFaceId();
                      } else {
                        User.activatedFaceId(context);
                      }
                    },
                    onChanged: (val) {
                      if (isFaceIdActivated) {
                        User.deactivatedFaceId();
                      } else {
                        User.activatedFaceId(context);
                      }
                    },
                  )
                : Container(),
            authenType == AuthenType.FACEID ? _buildSeparator() : Container(),
            authenType == AuthenType.TOUCHID
                ? _buildMenuItem(
                    svgIcon: AssetHelper.icoFingerSetting,
                    title: AppTranslate.i18n.stsLoginFingerStr.localized,
                    isSwitch: true,
                    value: isTouchIdActivated,
                    onTap: () {
                      if (isTouchIdActivated) {
                        User.deactivatedTouchId();
                      } else {
                        User.activatedTouchId(context);
                      }
                    },
                    onChanged: (val) {
                      if (isTouchIdActivated) {
                        User.deactivatedTouchId();
                      } else {
                        User.activatedTouchId(context);
                      }
                    },
                  )
                : Container(),
            authenType == AuthenType.TOUCHID ? _buildSeparator() : Container(),
            _buildMenuItem(
              svgIcon: AssetHelper.icoPinSetting,
              title: AppTranslate.i18n.stsLoginPinStr.localized,
              isSwitch: true,
              value: isPinActivated,
              onTap: () {
                if (isPinActivated) {
                  User.deactivatedPinCode();
                } else {
                  User.activatedPinCode(context);
                }
              },
              onChanged: (val) {
                if (isPinActivated) {
                  User.deactivatedPinCode();
                } else {
                  User.activatedPinCode(context);
                }
              },
            ),
            _buildSeparator(),
            isPinActivated
                ? Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: _buildMenuItem(
                        svgIcon: AssetHelper.icoRepeat,
                        title: AppTranslate.i18n.stsLoginPinChangeStr.localized,
                        onTap: () {
                          User.showChangePinScreen(context);
                        }),
                  )
                : Container(),
            isPinActivated ? _buildSeparator() : Container(),
            _buildMenuItem(
              svgIcon: AssetHelper.icoPassword,
              title: AppTranslate.i18n.stsPasswordChangeStr.localized,
              onTap: () {
                pushNamed(context, ChangePasswordScreen.routeName);
              },
            ),
            _buildSeparator(),
            // _buildMenuItem(
            //   svgIcon: AssetHelper.icoSmartotp,
            //   title: AppTranslate.i18n.stsOtpMethodStr.localized,
            //   onTap: () {
            //     pushNamed(context, ChangeOTPMethodScreen.routeName);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartOtpSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [kBoxShadowContainer],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            _buildMenuItem(
                isActive: isSOTPActivated,
                svgIcon: AssetHelper.icoRepeat,
                title: AppTranslate.i18n.stsSotpChangePinStr.localized,
                onTap: () {
                  SmartOTPManager().showChangePinScreen(context);
                }),
            _buildSeparator(),
            // _buildMenuItem(
            //     isActive: isSOTPActivated,
            //     svgIcon: AssetHelper.icoReload,
            //     title: AppTranslate.i18n.stsSotpResetStr.localized,
            //     onTap: () {
            //       SmartOTPManager().checkNeedActivationSOTP(
            //           context, AccountManager().currentUser,
            //           force: true);
            //     }),
            // _buildSeparator(),
            _buildMenuItem(
              isActive: isSOTPActivated,
              svgIcon: AssetHelper.icoShuffle,
              title: AppTranslate.i18n.stsSotpResyncStr.localized,
              onTap: () {
                Logger.debug('.......zzzzzzz');
                showLoading();
                SmartOTPManager().doSyncTime();
                setTimeout(() {
                  hideLoading();
                  showToast(AppTranslate.i18n.stsSotpResyncedStr.localized);
                }, 1500);
              },
            ),
            _buildSeparator(),
            Touchable(
              onTap: () {
                SmartOTPManager().showTermAndCondition(context);
              },
              child: SizedBox(
                height: 64,
                child: Center(
                  child: Text(
                    AppTranslate.i18n.stsSotpTocStr.localized,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(6, 158, 78, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [kBoxShadowContainer],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            _buildMenuItem(
              svgIcon: AssetHelper.icoBell,
              title:
                  AppTranslate.i18n.stsNotificationBalancePreviewStr.localized,
              isSwitch: true,
              overridePadding: 17,
              value: SettingManager().isNotificationActivated,
              onChanged: (isActive) async {
                SettingManager().isNotificationActivated = !isActive;
                await LocalStorageHelper.setBool(CHANGE_VIEW_BALANCE,
                    SettingManager().isNotificationActivated);
                setState(() {});
              },
            ),
            Html(
              style: {
                'body':
                    Style(margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                'p': Style(margin: EdgeInsets.zero),
              },
              data: AppTranslate
                  .i18n.stsNotificationBalancePreviewDescStr.localized,
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            _buildSeparator(),
            _buildMenuItem(
                svgIcon: AssetHelper.icoChart,
                title:
                    AppTranslate.i18n.stsNotificationTransactionStr.localized,
                onTap: () {
                  pushNamed(context, ListAccountSettingScreen.routeName);
                  // if(AppEnvironmentManager.environment == AppEnvironment.Dev) {
                  //   pushNamed(context, ListAccountSettingScreen.routeName);
                  // } else {
                  //   showDialogCustom(
                  //     context,
                  //     AssetHelper.icoAuthError,
                  //     AppTranslate.i18n.dialogTitleNotificationStr.localized,
                  //     AppTranslate.i18n.titleFutureDevelopStr.localized,
                  //     button1:  renderDialogTextButton(
                  //       context: context,
                  //       title: AppTranslate.i18n.dialogButtonCloseStr.localized,
                  //     ),
                  //   );
                  // }
                }),
            // _buildMenuItem(
            //   title: AppTranslate
            //       .i18n.stsNotificationTransactionPendingStr.localized,
            //   isSwitch: true,
            // ),
            // _buildSeparator(),
            // _buildMenuItem(
            //   title: AppTranslate
            //       .i18n.stsNotificationTransactionStep1Str.localized,
            //   isSwitch: true,
            // ),
            // _buildSeparator(),
            // _buildMenuItem(
            //   title: AppTranslate
            //       .i18n.stsNotificationTransactionWaitingStr.localized,
            //   isSwitch: true,
            // ),
            // _buildSeparator(),
            // _buildMenuItem(
            //   title: AppTranslate
            //       .i18n.stsNotificationTransactionErrorStr.localized,
            //   isSwitch: true,
            // ),
            // _buildSeparator(),
            // _buildMenuItem(
            //   svgIcon: AssetHelper.icoGift,
            //   title: AppTranslate.i18n.stsNotificationOtherStr.localized,
            //   description:
            //       AppTranslate.i18n.stsNotificationOtherDescStr.localized,
            //   isSwitch: true,
            // ),
            _buildSeparator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SettingScreenSection>? visibleSections =
        getArguments<SettingScreenArgument>(context)?.sections;

    return AppBarContainer(
      appBarType: AppBarType.HOME,
      showBackButton: visibleSections != null,
      title: AppTranslate.i18n.stsScreenTitleStr.localized,
      child: _contentBuilder(context, visibleSections),
    );
  }

  Widget _contentBuilder(
      BuildContext context, List<SettingScreenSection>? visibleSections) {
    List<Widget> renderSections = [];

    // renderSections.add(_buildRateSettings(context));
    renderSections.add(
      const SizedBox(
        height: kDefaultPadding,
      ),
    );

    if (visibleSections == null ||
        visibleSections.contains(SettingScreenSection.GENERAL)) {
      renderSections.add(_buildGeneralSettings(context));
      renderSections.add(
        const SizedBox(
          height: kDefaultPadding,
        ),
      );
    }

    if (visibleSections == null ||
        visibleSections.contains(SettingScreenSection.SMART_OTP)) {
      renderSections.add(
        isSOTPAvailable
            ? Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Row(
                  children: [
                    SvgPicture.asset(AssetHelper.icoSmartotp),
                    const SizedBox(
                      width: 22,
                    ),
                    Expanded(
                      child: Text(
                        AppTranslate.i18n.stsSmartOtpStr.localized,
                        style: kStyleTextHeaderSemiBold.copyWith(
                          color: const Color.fromRGBO(52, 52, 52, 1),
                        ),
                      ),
                    ),
                    _buildSwitch(
                      value: isSOTPActivated,
                      onChanged: (val) {
                        Logger.debug('-------xxxxx $isSOTPActivated');
                        if (isSOTPActivated) {
                          SmartOTPManager().deactivateSOTP();
                        } else {
                          SmartOTPManager().checkNeedActivationSOTP(
                              context, AccountManager().currentUser,
                              isFirstTime: false);
                        }
                      },
                    ),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                  ],
                ),
              )
            : Container(),
      );
      if (isSOTPAvailable) {
        renderSections.add(
          _buildSmartOtpSettings(context),
        );
      }
      renderSections.add(
        const SizedBox(
          height: kDefaultPadding * 2,
        ),
      );
    }

    if (visibleSections == null ||
        visibleSections.contains(SettingScreenSection.NOTIFICATION)) {
      if (!(visibleSections?.contains(SettingScreenSection.NOTIFICATION) ??
          false)) {
        renderSections.add(
          Container(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            child: Row(
              children: [
                SvgPicture.asset(AssetHelper.icoNotification1),
                const SizedBox(
                  width: 22,
                ),
                Expanded(
                  child: Text(
                    AppTranslate.i18n.stsNotificationStr.localized,
                    style: kStyleTextHeaderSemiBold.copyWith(
                      color: const Color.fromRGBO(52, 52, 52, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      renderSections.add(_buildNotificationSettings());
    }
    if (!(visibleSections?.contains(SettingScreenSection.NOTIFICATION) ??
        false)) {
      renderSections.add(_appVersion());
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          stops: [0, 1],
          colors: <Color>[
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 0),
          ],
        ).createShader(
            Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 20));
      },
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          ...renderSections,
          const SizedBox(
            height: kDefaultPadding,
          ),
        ],
      ),
    );
  }

  Widget _appVersion() {
    String appInfo = '';
    if (AppManager().currentAppInfo != null) {
      appInfo =
          '${AppTranslate.i18n.versionStr.localized}: ${AppManager().currentAppInfo?.version} (${AppManager().currentAppInfo?.buildNumber})';

      String buildType = '';
      if (AppEnvironmentManager.environment == AppEnvironment.Dev) {
        buildType = '- DEV\n${AppManager().deviceId}';
      }
      appInfo = '$appInfo $buildType';
    }

    if (appInfo.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Text(
        appInfo.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyles.smallText.copyWith(
          color: AppColors.gTextInputColor.withOpacity(0.4),
        ),
      ),
    );
  }
}
