import 'dart:developer';
import 'dart:io' show Directory, File, Platform;
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/auth/session_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_list_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manage_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/cards/card_detail/card_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_info_screen.dart';
import 'package:b2b/scr/presentation/screens/exchange_rate_screen.dart';
import 'package:b2b/scr/presentation/screens/find_atm_screen.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_history/loan_history_screen.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/saving/saving_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/result_register_tax_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/circle_avatar_letter.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart' as MyMessageHandler;
import 'package:b2b/utilities/vp_file_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:b2b/commons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/presentation/screens/auth/first_login_screen.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/auth_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/pin_screen.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/prelogin_action_tile.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:share_plus/share_plus.dart';

part 'auth_manager.dart';

class ReLoginScreen extends StatefulWidget {
  const ReLoginScreen({Key? key}) : super(key: key);
  static const String routeName = 're_login_screen';

  @override
  _ReLoginScreenState createState() => _ReLoginScreenState();
}

class _ReLoginScreenState extends State<ReLoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StateHandler _stateHandler = StateHandler(ReLoginScreen.routeName);
  final TextEditingController _controller = TextEditingController();
  bool _visible = false;

  final List<Interval> _itemSlideIntervals = [];

  late AnimationController itemRowAnimCtl;
  late Animation<double> itemRowPositionAnim;
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  final _animationDuration =
      _initialDelayTime + _itemSlideTime + (_staggerTime * 7);

  void handleNotificationChangeUser(dynamic username) {
    print('handleNotificationChangeUser $username');
    AccountManager().setCurrentUsername(username as String);
    AuthManager().checkLoginType(context);
  }

  @override
  void initState() {
    super.initState();
    SessionManager().clear();
    SessionManager().start(context);
    AuthManager().init(context, _stateHandler);
    MyMessageHandler.MessageHandler()
        .register('NOTIFICATION_CHANGE_USER', handleNotificationChangeUser);
    _createAnimationIntervals();
    itemRowAnimCtl =
        AnimationController(vsync: this, duration: _animationDuration);
    itemRowPositionAnim =
        CurvedAnimation(parent: itemRowAnimCtl, curve: Curves.ease);
    setTimeout(() {
      setState(() {
        _visible = true;
      });
      setTimeout(() {
        itemRowAnimCtl.forward();
      }, 200);
    }, 200);
    initLanguage();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i <= 7; ++i) {
      final startTime = _staggerTime * i;
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  @override
  void dispose() {
    MyMessageHandler.MessageHandler().removeListener(
        'NOTIFICATION_CHANGE_USER', handleNotificationChangeUser);
    AuthManager().clear();
    super.dispose();
  }

  void initLanguage() {
    AppTranslate().loadLanguage(onSynced: () {
      setState(() {});
    });
    LocalStorageHelper.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    AuthManager().showAlertIfHas(context);

    return BlocConsumer<AuthenBloc, AuthenState>(
      listenWhen: (previous, current) =>
          previous.loginState != current.loginState,
      listener: (context, state) {
        AuthManager().processLoginResult(context, state);
      },
      builder: (context, state) {
        return AppBarContainer(
          onTap: () {
            hideKeyboard(context);
          },
          appBarType: AppBarType.FULL,
          child: buildScreen(context),
        );
      },
    );
  }

  Widget buildScreen(BuildContext context) {
    List<Widget> actionItems = [
      PreLoginActionTile(
          onPressed: () {
            Logger.debug('tap on tile button');
            quickAction((_context) {
              if (RolePermissionManager().checkVisible(HomeAction.ACCOUNT.id)) {
                pushNamed(_context, AccountListScreen.routeName);
              } else {
                showToast(
                    AppTranslate.i18n.noPermissionForFeatureStr.localized);
              }
            });
            // Logger.debug(
            //     "============> ${TransactionManage().formatCurrency(100043424.3, 'VND')}");
          },
          icon: AssetHelper.icoAccountService,
          title: AppTranslate.i18n.reLoginServiceAccountStr.localized,
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () {
            Logger.debug('tap on tile button');
            quickAction((_context) {
              Navigator.of(context).pushNamed(
                TransactionManageScreen.routeName,
              );
              // pushNamed(
              //   context,
              //   TransactionManageScreen.routeName,
              // );
            });
          },
          icon: AssetHelper.icoManageTransfer,
          title: AppTranslate.i18n.reLoginTransactionManagementStr.localized,
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () {
            LocalStorageHelper.getBool(CHANGE_VIEW_BALANCE).then((value) {
              final isNotiBalance = value ?? false;
              if (isNotiBalance) {
                pushNamed(context, NotificationScreen.routeName,
                    arguments: NotificationArgs(isMain: false));
              } else {
                showDialogCustom(
                  context,
                  AssetHelper.icoAuthError,
                  AppTranslate.i18n.dialogTitleNotificationStr.localized,
                  AppTranslate
                      .i18n.titleNotPermissionSettingBalanceStr.localized,
                  button1: renderDialogTextButton(
                      context: context,
                      title: AppTranslate.i18n.dialogButtonCloseStr.localized),
                );
              }
            });
          },
          icon: AssetHelper.icoNotification,
          title: AppTranslate.i18n.dialogTitleNotificationStr.localized,
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () {
            Logger.debug('tap on tile button');
            Navigator.of(context).pushNamed(WebViewScreen.routeName,
                arguments: WebViewArgs(
                    url: 'https://cskh.vpbank.com.vn/',
                    title: AppTranslate.i18n.firstLoginTitleHelpStr.localized));
          },
          icon: AssetHelper.icoPhone,
          title: AppTranslate.i18n.firstLoginTitleHelpStr.localized,
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () {
            Logger.debug('tap on tile button');
            pushNamed(context, FindATMScreen.routeName, async: true);
            // pushNamed(context, ResultRegisterTaxScreen.routeName, async: true);
          },
          icon: AssetHelper.icoAtm,
          title: 'ATM/CDM',
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () {
            Logger.debug('tap on tile button');
            // Navigator.of(context).pushNamed(WebViewScreen.routeName,
            //     arguments: WebViewArgs(
            //         url:
            //             '${AppEvnRepository.baseUrl}/b2bMobileSIT/Home/UtilitiesRate',
            //         title:
            //             'first_login_title_exchange_rate'.localized));
            pushNamed(context, ExchangeRateScreen.routeName);
          },
          icon: AssetHelper.icoBarChart,
          title: AppTranslate.i18n.firstLoginTitleExchangeRateStr.localized,
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () {
            Logger.debug('tap on tile button');
            // testHtmlToPdf();
            pushNamed(context, RolloverTermSavingScreen.routeName);
          },
          icon: AssetHelper.icoLineChart,
          title: AppTranslate.i18n.firstLoginTitleInterestRateStr.localized,
          badgeNumber: 0),
      PreLoginActionTile(
          onPressed: () async {
            SmartOTPManager().startMain(
              context,
              (type) {
                AuthManager().onLoginCallback(context, type);
              },
            );
          },
          icon: AssetHelper.icoSmartOtp,
          title: 'Smart OTP',
          badgeNumber: 0),
    ];

    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenPaddingTop,
        ),
        Container(
          height: getInScreenSize(40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                AssetHelper.icoVpbankSplashNoTagline,
                width: getInScreenSize(162),
                height: getInScreenSize(40),
              ),
              const Spacer(),
              Touchable(
                child: Container(
                  width: 64,
                  height: 28,
                  padding: const EdgeInsets.only(
                      top: 2, bottom: 2, left: 2, right: 4),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: ImageHelper.loadFromAsset(
                            AppTranslate().getIcoLanguage(),
                            width: 24,
                            height: 24),
                      ),
                      Expanded(
                        child: Text(
                          AppTranslate().getTitleLanguage(),
                          style: const TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  AppTranslate().toggleLanguage(
                    context,
                    () {
                      setState(() {});
                    },
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            '',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          opacity: _visible ? 1.0 : 0,
          child: StateBuilder(
              routeName: ReLoginScreen.routeName,
              builder: () {
                return CircleAvatarLetter(
                    size: 72.toScreenSize,
                    backgroundColor: Colors.white,
                    name: AuthManager().sessionModel?.user?.fullName ??
                        AuthManager().username);
              }),
        ),
        const SizedBox(height: 16),
        StateBuilder(
          builder: () {
            return Text(
              (AuthManager().sessionModel?.user?.fullName ??
                      AuthManager().username)
                  .toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            );
          },
          routeName: ReLoginScreen.routeName,
        ),
        const Spacer(),
        Touchable(
          onTap: () {
            AuthManager().quickAction(null);
            showModalBottomSheet(
                isScrollControlled: true,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                context: context,
                clipBehavior: Clip.hardEdge,
                routeSettings: RouteSettings(
                  arguments: AccountManageArgument((type) {
                    AuthManager().password = "";
                    _controller.clear();
                    AuthManager().onLoginCallback(context, type);
                  }),
                ),
                builder: (BuildContext context) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: kGradientBackgroundH,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    // height: SizeConfig.screenHeight,
                    child: const AccountManageScreen(),
                    padding:
                        EdgeInsets.only(top: SizeConfig.topSafeAreaPadding),
                  );
                });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageHelper.loadFromAsset(AssetHelper.icoSwitchUser,
                    width: 24.toScreenSize, height: 24.toScreenSize),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  AppTranslate.i18n.reLoginLoginWithAccountOtherStr.localized,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _visible ? 1.0 : 0,
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: 70.toScreenSize,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.toScreenSize)),
            ),
            child: StateBuilder(
              builder: () {
                return Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 44,
                      child: TextFormField(
                        keyboardAppearance: Brightness.light,
                        // initialValue: AuthManager().password,
                        controller: _controller,
                        onChanged: (value) {
                          AuthManager().password = value;
                          _stateHandler.refresh();
                        },
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: Platform.isIOS ? 1.2 : 1.5,
                          color: const Color.fromRGBO(52, 52, 52, 1.0),
                          fontFamily: 'SVN-GilroyCustom',
                        ),
                        decoration: InputDecoration(
                          labelText: AppTranslate
                              .i18n.firstLoginTitlePasswordStr.localized,
                          // hintText: '••••',
                          // filled: true,
                          // fillColor: Colors.white12,
                          labelStyle: const TextStyle(
                            color: Color.fromRGBO(102, 102, 103, 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromRGBO(0, 183, 79, 1.0),
                            ),
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(186, 205, 223, 0.8),
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(186, 205, 223, 0.8),
                            ),
                          ),
                          // hintStyle: TextStyle(color: Colors.grey.shade400),
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.zero,
                          //EdgeInsets.only(left: 10),
                          suffixIcon: IconButton(
                            alignment: Alignment.bottomRight,
                            icon: Icon(
                                AuthManager().showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                                color: AuthManager().password.isNotEmpty
                                    ? const Color.fromRGBO(186, 205, 223, 1.0)
                                    : Colors.transparent),
                            onPressed: () {
                              AuthManager().showPassword =
                                  !AuthManager().showPassword;
                              _stateHandler.refresh();
                            },
                          ),
                        ),
                        obscureText: AuthManager().showPassword == false,
                      ),
                    ));
              },
              routeName: ReLoginScreen.routeName,
            ),
          ),
        ),
        const Spacer(flex: 3),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: _visible ? 1.0 : 0,
          child: StateBuilder(
            builder: () {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: RoundedButtonWidget(
                        title: AppTranslate
                            .i18n.accountManageTitleLoginStr.localized,
                        requestHideKeyboard: true,
                        delay: 300,
                        onPress: () {
                          AuthManager().quickAction(null);
                          pressLogin();
                        },
                      ),
                    ),
                    SizedBox(
                      width: (!AuthManager().isActiveFaceId &&
                              !AuthManager().isActiveTouchId &&
                              !AuthManager().isActivePinCode)
                          ? 0
                          : 10.toScreenSize,
                    ),
                    (!AuthManager().isActiveFaceId &&
                            !AuthManager().isActiveTouchId &&
                            !AuthManager().isActivePinCode)
                        ? const SizedBox(
                            width: 0,
                          )
                        : Touchable(
                            onTap: () {
                              AuthManager().quickAction(null);
                              pressQuickLogin();
                            },
                            child: Container(
                              height: 48.toScreenSize,
                              width: 48.toScreenSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 183, 79, 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(24.toScreenSize)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                        offset: Offset(0, 0.2),
                                        blurRadius: 2,
                                        spreadRadius: 2),
                                  ]),
                              child: ImageHelper.loadFromAsset(
                                  AuthManager().authenType.icon,
                                  width: 28,
                                  height: 28),
                            ))
                  ],
                ),
              );
            },
            routeName: ReLoginScreen.routeName,
          ),
        ),
        const Spacer(),
        Touchable(
          onTap: () {
            Logger.debug('tap on forgot password button');
            showDialogCustom(
              context,
              AssetHelper.icoForgotPass,
              AppTranslate.i18n.dialogTitleForgotPasswordStr.localized,
              AppTranslate.i18n.dialogMessageForgotPasswordStr.localized,
              button1: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.dialogButtonCancelStr.localized),
              button2: renderDialogButtonIcon(
                context: context,
                title: '1900545415',
                icon: AssetHelper.icoPhoneCall,
                onTap: () {
                  launch('tel://1900545415');
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text(
              AppTranslate.i18n.dialogTitleForgotPasswordStr.localized,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const Spacer(flex: 2),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            // crossAxisSpacing: 4,
            // mainAxisSpacing: 8,
            // childAspectRatio: (2 / 1),
          ),
          itemBuilder: (BuildContext context, int index) {
            return AnimatedBuilder(
              animation: itemRowAnimCtl,
              builder: (context, child) {
                final animationPercent = Curves.easeInOutCirc.transform(
                  _itemSlideIntervals[index].transform(itemRowAnimCtl.value),
                );
                final opacity = animationPercent;
                final slideDistance = (1.0 - animationPercent) * 10;

                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, slideDistance),
                    child: child,
                  ),
                );
              },
              child: actionItems[index],
            );
          },
          itemCount: actionItems.length,
        ),
        SizedBox(
          height: SizeConfig.isIphoneX() ? 8 : 0,
        )
      ],
    );
  }

  void quickAction(Function(BuildContext _context)? action) {
    AuthManager().quickAction(action);
    if (!(!AuthManager().isActiveFaceId &&
        !AuthManager().isActiveTouchId &&
        !AuthManager().isActivePinCode)) {
      pressQuickLogin();
    } else {
      pressLogin();
    }
  }

  void pressLogin() {
    if (AuthManager().password.isEmpty) {
      showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.dialogMessageInputPasswordStr.localized,
          button1: renderDialogTextButton(
              context: context,
              title: AppTranslate.i18n.dialogButtonCloseStr.localized));
      return;
    }
    AuthManager().authenType = AuthenType.PASSWORD;
    context.read<AuthenBloc>().add(
          AuthenEventLogin(
              username: AuthManager().username,
              password: AuthManager().password,
              authenType: AuthenType.PASSWORD),
        );
  }

  void pressQuickLogin() {
    if (AuthManager().authenType == AuthenType.FACEID ||
        AuthManager().authenType == AuthenType.TOUCHID) {
      AuthManager().authenByBiometric(
        context,
        handleSuccess: () {
          context.read<AuthenBloc>().add(AuthenEventLogin(
                username: AuthManager().username,
                password: AuthManager().passwordToken,
                authenType: AuthManager().authenType,
              ));
        },
        handleError: () {
          AuthManager().changeToOtherMethod(context);
        },
      );
    } else {
      pushNamed(
        context,
        PINScreen.routeName,
        arguments: PINScreenArgs(
          pinCode: AuthManager().pinCode,
          pinCodeType: PinScreenType.VERIFY_APP,
          callback: () {
            log("call back pin code");
            showLoading();
            setTimeout(() {
              context.read<AuthenBloc>().add(
                    AuthenEventLogin(
                      username: AuthManager().username,
                      password: AuthManager().passwordToken,
                      authenType: AuthManager().authenType,
                    ),
                  );
            }, 300);
          },
        ),
        animation: true,
      );
    }
  }
}
