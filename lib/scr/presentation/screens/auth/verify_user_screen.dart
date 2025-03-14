import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class VerifyUserArgs {
  final String? title;
  final Function? onResult;

  VerifyUserArgs({this.title, this.onResult});
}

class ReLoginUserScreen extends StatefulWidget {
  const ReLoginUserScreen({Key? key}) : super(key: key);
  static const String routeName = 'verify_user_screen';

  @override
  _ReLoginUserScreenState createState() => _ReLoginUserScreenState();
}

class _ReLoginUserScreenState extends State<ReLoginUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StateHandler _stateHandler = StateHandler(ReLoginUserScreen.routeName);
  TextEditingController passWordController = TextEditingController();
  bool isShowPass = false;

  @override
  Widget build(BuildContext context) {
    final args = getArguments(context) as VerifyUserArgs;

    return BlocConsumer<AuthenBloc, AuthenState>(
      listenWhen: (previous, current) => previous.loginState != current.loginState,
      listener: (context, state) {
        AuthManager().processVerifyUserResult(context, state, onResult: args.onResult);
      },
      builder: (context, state) {
        return AppBarContainer(
          onTap: () {
            hideKeyboard(context);
          },
          title: args.title,
          appBarType: AppBarType.NORMAL,
          child: buildScreen(context),
        );
      },
    );
  }

  Widget buildScreen(BuildContext context) {
    return StateBuilder(
        builder: () => AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: 1.0,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: getInScreenSize(150),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [kBoxShadowCommon],
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            AppTranslate.i18n.confirmInputPasswordStr.localized,
                            style: TextStyles.headerItemText.blackColor,
                          ),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            height: 70.toScreenSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(16.toScreenSize)),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                height: 44,
                                child: TextFormField(
                                  keyboardAppearance: Brightness.light,
                                  controller: passWordController,
                                  onChanged: (value) {
                                    isShowPass = value.isNotEmpty;
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
                                    labelText: AppTranslate.i18n.firstLoginTitlePasswordStr.localized,
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
                                    contentPadding: EdgeInsets.zero,
                                    suffixIcon: IconButton(
                                      alignment: Alignment.bottomRight,
                                      icon: Icon(!isShowPass ? Icons.visibility_off : Icons.visibility,
                                          size: 20,
                                          color: passWordController.text.isNotEmpty
                                              ? const Color.fromRGBO(186, 205, 223, 1.0)
                                              : Colors.transparent),
                                      onPressed: () {
                                        isShowPass = !isShowPass;
                                        _stateHandler.refresh();
                                      },
                                    ),
                                  ),
                                  obscureText: isShowPass == true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        child: Html(
                          data: AppTranslate.i18n.confirmPassNoteStr.localized,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.bottomSafeAreaPadding + kDefaultPadding,
                          ),
                          child: RoundedButtonWidget(
                            title: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                            requestHideKeyboard: true,
                            delay: 300,
                            onPress: () {
                              pressLogin();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              ),
            ),
        routeName: ReLoginUserScreen.routeName);
  }

  void pressLogin() {
    if (passWordController.text.isEmpty) {
      showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.dialogMessageInputPasswordStr.localized,
          button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
      return;
    }
    context.read<AuthenBloc>().add(AuthenEventReLogin(
        username: SessionManager().userData?.user?.username ?? '',
        password: passWordController.text,
        authenType: AuthenType.PASSWORD));
  }
}
