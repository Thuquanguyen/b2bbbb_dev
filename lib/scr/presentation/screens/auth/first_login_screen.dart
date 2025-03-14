import 'dart:io';

import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/exchange_rate_screen.dart';
import 'package:b2b/scr/presentation/screens/saving/saving_screen.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/prelogin_action_tile.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import '../find_atm_screen.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

//// Navigator.of(context).pushNamed(PINScreen.routeName, arguments: {});

class FirstLoginScreen extends StatefulWidget {
  const FirstLoginScreen({Key? key}) : super(key: key);
  static const String routeName = 'first_login_screen';

  @override
  _FirstLoginScreenState createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _visible = false;
  final _controller = TextEditingController(text: '');
  bool showPassword = false;
  String username = '';
  String password = '';
  int number = 1;
  late String? type;

  @override
  void initState() {
    super.initState();
    SessionManager().clear();
    SessionManager().start(context);
    setTimeout(() {
      setState(() {
        _visible = true;
      });
    }, 200);
    initLanguage();
  }

  void initLanguage() {
    AppTranslate().loadLanguage(onSynced: () {
      setState(() {});
    });
  }

  bool isAddNewAccount() {
    return type == 'ADD';
  }

  @override
  Widget build(BuildContext context) {
    type = getArgument(context, 'type') as String?;
    if (isAddNewAccount()) {
      _visible = true;
    }
    return BlocConsumer<AuthenBloc, AuthenState>(
      listenWhen: (previous, current) => previous.loginState != current.loginState,
      listener: (context, state) {
        AuthManager().authenType = AuthenType.PASSWORD;
        AuthManager().username = username;
        AuthManager().password = password;
        AuthManager().processLoginResult(context, state, isFirstLogin: true);
      },
      builder: (context, state) {
        return AppBarContainer(
            title: isAddNewAccount() ? AppTranslate.i18n.firstLoginTitleAddAccountStr.localized : null,
            appBarType: isAddNewAccount() ? AppBarType.MEDIUM : AppBarType.FULL,
            onBack: () {
              if (isAddNewAccount()) {
                pushReplacementNamed(context, ReLoginScreen.routeName, animation: false);
              }
            },
            onTap: () {
              FocusScope.of(context).unfocus();
              // number++;
              // number = 2;
              // _stateHandler.refresh(holder: 'number');
            },
            child: buildLoginForm(context));
      },
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: !isAddNewAccount() ? SizeConfig.screenPaddingTop : 20,
        ),
        !isAddNewAccount()
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: _visible ? 1 : 0,
                  child: SizedBox(
                    height: 28,
                    width: SizeConfig.screenWidth,
                    child: Row(
                      children: [
                        const Spacer(),
                        Touchable(
                          child: Container(
                            width: 64,
                            height: 28,
                            padding: const EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 4),
                            decoration: const BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(14))),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(14))),
                                  child:
                                      ImageHelper.loadFromAsset(AppTranslate().getIcoLanguage(), width: 24, height: 24),
                                ),
                                Expanded(
                                    child: StateBuilder(
                                  routeName: FirstLoginScreen.routeName,
                                  builder: () => Text(
                                    AppTranslate().getTitleLanguage(),
                                    style: const TextStyle(color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          onTap: () {
                            AppTranslate().toggleLanguage(context, () {
                              setState(() {});
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        SizedBox(height: !isAddNewAccount() ? 60 : 0),
        !isAddNewAccount()
            ? Center(
                child: SizedBox(
                  width: getInScreenSize(260),
                  height: getInScreenSize(66),
                  child: Image.asset(
                    AssetHelper.icoVpbankSplash,
                  ),
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        SizedBox(height: !isAddNewAccount() ? 60 : 0),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _visible ? 1 : 0,
          child: Container(
            height: getInScreenSize(!isAddNewAccount() ? 130 : 160),
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.toScreenSize)),
              boxShadow: const [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 44,
                    child: TextFormField(
                      keyboardAppearance: Brightness.light,
                      enableSuggestions: false,
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 14,
                        height: Platform.isIOS ? 1.2 : 1.5,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(52, 52, 52, 1.0),
                      ),
                      decoration: InputDecoration(
                        labelText: AppTranslate.i18n.firstLoginTitleUsernameStr.localized,
                        hintText: '',
                        labelStyle: const TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(0, 183, 79, 1.0))),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color.fromRGBO(186, 205, 223, 0.8))),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color.fromRGBO(186, 205, 223, 0.8))),
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: IconButton(
                          alignment: Alignment.bottomRight,
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              username = '';
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                            color: username.isNotEmpty ? const Color.fromRGBO(186, 205, 223, 1.0) : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: TextFormField(
                      keyboardAppearance: Brightness.light,
                      initialValue: '',
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      style: TextStyle(
                        fontSize: 14,
                        height: Platform.isIOS ? 1.2 : 1.5,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(52, 52, 52, 1.0),
                        fontFamily: 'SVN-GilroyCustom',
                      ),
                      decoration: InputDecoration(
                        labelText: AppTranslate.i18n.firstLoginTitlePasswordStr.localized,
                        hintText: '',
                        labelStyle: const TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(0, 183, 79, 1.0))),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color.fromRGBO(186, 205, 223, 0.8))),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color.fromRGBO(186, 205, 223, 0.8))),
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: IconButton(
                          alignment: Alignment.bottomRight,
                          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility,
                              size: 20,
                              color:
                                  password.isNotEmpty ? const Color.fromRGBO(186, 205, 223, 1.0) : Colors.transparent),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: showPassword == false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // const SizedBox(height: 22),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible ? 1 : 0,
            child: RoundedButtonWidget(
              title: AppTranslate.i18n.accountManageTitleLoginStr.localized,
              requestHideKeyboard: true,
              delay: 300,
              onPress: () {
                if (username.isEmpty) {
                  showDialogCustom(
                      context,
                      AssetHelper.icoAuthError,
                      AppTranslate.i18n.dialogTitleNotificationStr.localized,
                      AppTranslate.i18n.dialogMessageInputUsernameStr.localized,
                      button1: renderDialogTextButton(
                          context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
                  return;
                }
                if (password.isEmpty) {
                  showDialogCustom(
                      context,
                      AssetHelper.icoAuthError,
                      AppTranslate.i18n.dialogTitleNotificationStr.localized,
                      AppTranslate.i18n.dialogMessageInputPasswordStr.localized,
                      button1: renderDialogTextButton(
                          context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
                  return;
                }
                context.read<AuthenBloc>().add(AuthenEventLogin(username: username, password: password));
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        Touchable(
          onTap: () {
            Logger.debug('tap on forgot password button');
            showDialogCustom(
                context,
                AssetHelper.icoForgotPass,
                AppTranslate.i18n.dialogTitleForgotPasswordStr.localized,
                AppTranslate.i18n.dialogMessageForgotPasswordStr.localized,
                button1:
                    renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
                button2: renderDialogButtonIcon(
                    context: context,
                    title: '1900545415',
                    icon: AssetHelper.icoPhoneCall,
                    onTap: () {
                      launch('tel://1900545415');
                    }));
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: StateBuilder(
              routeName: FirstLoginScreen.routeName,
              builder: () => Text(
                AppTranslate.i18n.dialogTitleForgotPasswordStr.localized,
                style: TextStyle(color: !isAddNewAccount() ? Colors.white : Colors.black87, fontSize: 13),
              ),
            ),
          ),
        ),
        const Spacer(),
        !isAddNewAccount()
            ? AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _visible ? 1 : 0,
                child: Wrap(
                  verticalDirection: VerticalDirection.up,
                  alignment: WrapAlignment.end,
                  children: [
                    PreLoginActionTile(
                        onPressed: () {
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
                        },
                        icon: AssetHelper.icoDownload,
                        title: 'ATM/CDM',
                        badgeNumber: 0),
                    PreLoginActionTile(
                        onPressed: () {
                          // Navigator.of(context).pushNamed(
                          //   WebViewScreen.routeName,
                          //   arguments: WebViewArgs(
                          //     url: '${AppEvnRepository.baseUrl}/b2bMobileSIT/Home/UtilitiesRate',
                          //     title: AppTranslate.i18n.firstLoginTitleExchangeRateStr.localized,
                          //   ),
                          // );
                          // pushNamed(context, ExchangeRateScreen.routeName);
                          launch(AppEnvironmentManager.onboardUrl);
                        },
                        icon: AssetHelper.icoOnboardOnline,
                        title: AppTranslate.i18n.firstLoginTitleOnboardOnlineStr.localized,
                        badgeNumber: 0),
                    PreLoginActionTile(
                        onPressed: () {
                          pushNamed(context, RolloverTermSavingScreen.routeName);
                        },
                        icon: AssetHelper.icoLineChart,
                        title: AppTranslate.i18n.firstLoginTitleInterestRateStr.localized,
                        badgeNumber: 0),
                  ],
                ),
              )
            : const SizedBox(
                height: 200,
              ),
        SizedBox(
          height: SizeConfig.isIphoneX() ? 8 : 0,
        )
      ],
    );
  }
}
