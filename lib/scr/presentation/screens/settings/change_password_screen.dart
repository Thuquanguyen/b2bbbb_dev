import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/change_password/change_password_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/core/validator/validator.dart';
import 'package:b2b/scr/data/model/change_password_request_model.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreenArguments {
  final String? oldPassword;

  ChangePasswordScreenArguments({this.oldPassword});
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  static const String routeName = 'change-password-screen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool? needLogout;

  FocusNode oldPWFC = FocusNode();
  FocusNode newPWFC = FocusNode();
  FocusNode repPWFC = FocusNode();

  bool isOldPwVisible = false;
  bool isNewPwVisible = false;
  bool isRepPwVisible = false;

  bool shouldOldPwHelperShow = false;
  bool shouldNewPwHelperShow = false;
  bool shouldRepPwHelperShow = false;

  String oldPwVal = '';
  String newPwVal = '';
  String? newPwError;
  String repPwVal = '';
  String? repPwError;

  late ChangePasswordBloc changePasswordBloc;

  @override
  void initState() {
    super.initState();
    oldPWFC.addListener(() {
      if (oldPwVal.isEmpty) {
        shouldOldPwHelperShow = oldPWFC.hasFocus;
        setState(() {});
      }
    });

    newPWFC.addListener(() {
      if (newPwVal.isEmpty) {
        shouldNewPwHelperShow = newPWFC.hasFocus;
        setState(() {});
      }
    });

    repPWFC.addListener(() {
      if (repPwVal.isEmpty) {
        shouldRepPwHelperShow = repPWFC.hasFocus;
        setState(() {});
      }
    });

    changePasswordBloc = context.read<ChangePasswordBloc>();
  }

  Widget _buildTextField({
    required String name,
    required bool isVisible,
    required bool shouldHelperShow,
    required FocusNode focusNode,
    required Function onVisibilityTap,
    required Function(String?) onChanged,
    String? errorText,
  }) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        TextFormField(
          keyboardAppearance: Brightness.light,
          focusNode: focusNode,
          enableInteractiveSelection: false,
          enableSuggestions: false,
          style: kStyleTitleText.copyWith(
            fontFamily: 'SVN-GilroyCustom',
            color: const Color.fromRGBO(102, 102, 103, 1),
          ),
          obscureText: !isVisible,
          decoration: InputDecoration(
            prefixText: '     ',
            isDense: true,
            labelText: name,
            contentPadding: const EdgeInsets.only(
              bottom: 5,
            ),
            errorText: errorText,
          ),
          onChanged: onChanged,
        ),
        shouldHelperShow
            ? Row(
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.only(top: 12),
                    child: SvgPicture.asset(AssetHelper.icoLock),
                  ),
                  Expanded(child: Container()),
                  Touchable(
                    onTap: () {
                      onVisibilityTap();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SvgPicture.asset(
                        isVisible ? AssetHelper.icoEyeVisible : AssetHelper.icoEyeInvicible,
                      ),
                    ),
                  )
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _contentBuilder(BuildContext context, ChangePasswordState state) {
    return Column(
      children: [
        Form(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kBoxShadowContainer],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    name: AppTranslate.i18n.cpwsOldPasswordStr.localized,
                    focusNode: oldPWFC,
                    shouldHelperShow: shouldOldPwHelperShow,
                    isVisible: isOldPwVisible,
                    onVisibilityTap: () {
                      setState(() {
                        isOldPwVisible = !isOldPwVisible;
                      });
                    },
                    onChanged: (val) {
                      oldPwVal = val ?? '';
                      if (val.isNotNullAndEmpty) {
                        shouldOldPwHelperShow = true;
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(
                    name: AppTranslate.i18n.cpwsNewPasswordStr.localized,
                    focusNode: newPWFC,
                    shouldHelperShow: shouldNewPwHelperShow,
                    isVisible: isNewPwVisible,
                    onVisibilityTap: () {
                      setState(() {
                        isNewPwVisible = !isNewPwVisible;
                      });
                    },
                    onChanged: (val) {
                      newPwVal = val ?? '';
                      if (val.isNotNullAndEmpty) {
                        shouldNewPwHelperShow = true;
                        newPwError = PasswordInputValidator(
                          minLength: 8,
                          regexInvalidMessage: AppTranslate.i18n.errorTitlePasswordCorrectFormatStr.localized,
                        ).validate(val!);
                        if (repPwVal.isNotNullAndEmpty) {
                          shouldRepPwHelperShow = true;
                          repPwError =
                              val != repPwVal ? AppTranslate.i18n.errorTitlePasswordIncorrectStr.localized : null;
                        }
                      } else {
                        newPwError = null;
                      }
                      setState(() {});
                    },
                    errorText: newPwError,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(
                    name: AppTranslate.i18n.cpwsNewPasswordRepeatStr.localized,
                    focusNode: repPWFC,
                    shouldHelperShow: shouldRepPwHelperShow,
                    isVisible: isRepPwVisible,
                    onVisibilityTap: () {
                      setState(() {
                        isRepPwVisible = !isRepPwVisible;
                      });
                    },
                    onChanged: (val) {
                      repPwVal = val ?? '';
                      if (val.isNotNullAndEmpty) {
                        shouldRepPwHelperShow = true;
                        repPwError =
                            val != newPwVal ? AppTranslate.i18n.errorTitlePasswordIncorrectStr.localized : null;
                      } else {
                        repPwError = null;
                      }
                      setState(() {});
                    },
                    errorText: repPwError,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppTranslate.i18n.errorTitlePasswordStr.localized,
                    style: kStyleTitleText.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 30,
            bottom: SizeConfig.bottomSafeAreaPadding + kDefaultPadding,
          ),
          child: RoundedButtonWidget(
            title: AppTranslate.i18n.cpwsConfirmStr.localized.toUpperCase(),
            onPress: () {
              changePassword();
            },
            height: kButtonHeight,
          ),
        )
      ],
    );
  }

  bool validate() {
    bool isValid = true;

    if (oldPwVal.isEmpty || newPwVal.isEmpty || repPwVal.isEmpty) {
      showToast(AppTranslate.i18n.errorTitleEnterFullInfoStr.localized);
      isValid = false;
    }

    return isValid;
  }

  void changePassword() {
    if (validate() == false) {
      return;
    }

    changePasswordBloc.add(
      ChangePasswordExecuteEvent(
        request: ChangePasswordRequestModel(
          oldPasswd: oldPwVal,
          newPasswd: newPwVal,
          confirmNewPasswd: repPwVal,
        ),
      ),
    );
  }

  void _stateListener(BuildContext context, ChangePasswordState state) {
    if (state.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.dataState == DataState.data) {
      if (state.status == ChangePasswordStatus.SUCCESS) {
        showToast(AppTranslate.i18n.errorTitleChangePasswordSuccessStr.localized);
        if (needLogout == true) {
          SessionManager().logout();
        } else {
          popScreen(context);
        }
      } else {
        showToast(state.message ?? AppTranslate.i18n.errorTitleAnUnknownStr.localized);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    needLogout = getArgument(context, 'needLogout') ?? false;
    return AppBarContainer(
      onTap: () {
        hideKeyboard(context);
      },
      onBack: () {
        if (needLogout == true) {
          SessionManager().logout();
          SessionManager().doingChangePassword = false;
        } else {
          Navigator.of(context).pop();
        }
      },
      appBarType: AppBarType.NORMAL,
      title: AppTranslate.i18n.cpwsScreenTitleStr.localized,
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listenWhen: (previous, current) => previous.dataState != current.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }
}
