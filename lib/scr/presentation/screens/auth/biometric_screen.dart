import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/first_login_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BiometricScreenType { AUTH, SETUP }

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({Key? key}) : super(key: key);
  static const String routeName = 'biometric_screen';

  @override
  _BiometricScreenState createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  bool isSetupError = false;
  String? title;
  String? iconBiometric;
  String? buttonUseTitle;
  String? buttonRetryTitle = 'biometric_button_try_again'.localized;
  String? titleNoUse;
  String? titleAsk;
  String? titleAskError;
  BiometricScreenType biometricScreenType = BiometricScreenType.AUTH;
  AuthenType authenType = AuthenType.TOUCHID;

  @override
  void initState() {
    super.initState();
    initBiometric();
  }

  @override
  Widget build(BuildContext context) {
    biometricScreenType = getArgument(context, 'screen_type') ?? BiometricScreenType.AUTH;

    return BlocConsumer<AuthenBloc, AuthenState>(
      listenWhen: (previous, current) => previous.registerState != current.registerState,
      listener: (context, state) {
        if (state.registerState == DataState.preload) {
          showLoading();
        } else if (state.registerState == DataState.data) {
          setTimeout(() {
            hideLoading();
          }, 300);
          if (state.registerStatus == AuthenStatus.SUCCESS) {
            LocalStorageHelper.setString(authenType.name, state.registerModel?.data?.authenPasswd ?? '');
            setTimeout(() {
              if (biometricScreenType == BiometricScreenType.AUTH) {
                pushReplacementNamed(context, MainScreen.routeName, animation: true);
              } else {
                popScreen(context);
                showToast(AppTranslate.i18n.authBiometricLoginSetupSuccessStr.localized);
              }
            }, 500);
          } else {
            setState(() {
              titleAskError = state.registerModel?.result?.getMessage() ?? '';
            });
          }
        } else if (state.registerState == DataState.error) {}
      },
      builder: (context, state) {
        return AppBarContainer(
          title: title ?? AppTranslate.i18n.biometricTitleSinhTracHocStr.localized,
          appBarType: AppBarType.FULL,
          onBack: () async {
            if (biometricScreenType == BiometricScreenType.AUTH) {
              await AccountManager().loadUsers();
              if (AccountManager().getUsers().isNotEmpty) {
                pushReplacementNamed(context, ReLoginScreen.routeName, animation: false);
              } else {
                pushReplacementNamed(context, FirstLoginScreen.routeName, animation: false);
              }
            } else {
              popScreen(context);
            }
          },
          child: buildScreen(),
        );
      },
    );
  }

  Padding buildScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Spacer(flex: 4),
            ImageHelper.loadFromAsset(iconBiometric ?? AssetHelper.imgBgLogin,
                width: 172.toScreenSize, height: 118.toScreenSize),
            Container(
                height: 70.toScreenSize,
                alignment: Alignment.center,
                child: Text(
                    (isSetupError ? titleAskError : titleAsk) ??
                        AppTranslate.i18n.biometricTitleSettingSinhTracHocStr.localized,
                    style: const TextStyle(color: Colors.white))),
            const Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: RoundedButtonWidget(
                title: (isSetupError ? buttonRetryTitle : buttonUseTitle) ??
                    AppTranslate.i18n.biometricTitleUseSinhTracHocStr.localized,
                onPress: () {
                  AuthManager().authenByBiometric(
                    context,
                    handleSuccess: () {
                      handleSetUpSuccess();
                    },
                    handleError: () {
                      handleSetUpError();
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            Touchable(
              onTap: () async {
                LocalStorageHelper.setString(authenType.name, '');
                Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Text(
                  titleNoUse ?? AppTranslate.i18n.biometricTitleNotUseSinhTracHocStr.localized,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // // ignore: avoid_void_async
  Future<void> initBiometric() async {
    authenType = await AuthManager().initBiometric();
    if (Platform.isIOS) {
      if (authenType == AuthenType.FACEID) {
        setState(() {
          title = AppTranslate.i18n.biometricTitleSetupFaceIDStr.localized;
          buttonUseTitle = AppTranslate.i18n.biometricTitleUseFaceIDStr.localized;
          titleNoUse = AppTranslate.i18n.biometricTitleNotUseFaceIDStr.localized;
          titleAsk = AppTranslate.i18n.biometricTitleQuestionSetupFaceIDStr.localized;
          titleAskError = AppTranslate.i18n.biometricTitleNotConfirmFaceIDStr.localized;
          iconBiometric = AssetHelper.icoFaceid;
        });
      } else if (authenType == AuthenType.TOUCHID) {
        setState(() {
          title = AppTranslate.i18n.biometricTitleSetupTouchIDStr.localized;
          buttonUseTitle = AppTranslate.i18n.biometricTitleUseTouchIDStr.localized;
          titleNoUse = AppTranslate.i18n.biometricTitleNotUseTouchIDStr.localized;
          titleAsk = AppTranslate.i18n.biometricTitleQuestionSetupTouchIDStr.localized;
          titleAskError = AppTranslate.i18n.biometricTitleNotConfirmTouchIDStr.localized;
          iconBiometric = AssetHelper.icoTouchid;
        });
      }
    } else {
      if (authenType == AuthenType.TOUCHID) {
        setState(() {
          title = AppTranslate.i18n.biometricTitleSetupFingerprintStr.localized;
          buttonUseTitle = AppTranslate.i18n.biometricTitleUseFingerprintStr.localized;
          titleNoUse = AppTranslate.i18n.biometricTitleNotUseFingerprintStr.localized;
          titleAsk = AppTranslate.i18n.biometricTitleSinhTracHocStr.localized;
          titleAskError = AppTranslate.i18n.biometricNotConfirmFingerprintStr.localized;
          iconBiometric = AssetHelper.icoTouchid;
        });
      }
    }
  }

  void handleSetUpError() {
    setState(() {
      isSetupError = true;
      if (iconBiometric == AssetHelper.icoFaceid) {
        iconBiometric = AssetHelper.icoFaceidError;
      }
      if (iconBiometric == AssetHelper.icoTouchid) {
        iconBiometric = AssetHelper.icoTouchidError;
      }
    });
  }

  void handleSetUpSuccess() {
    setState(() {
      isSetupError = false;
      if (iconBiometric == AssetHelper.icoFaceidError) {
        iconBiometric = AssetHelper.icoFaceid;
      }
      if (iconBiometric == AssetHelper.icoTouchidError) {
        iconBiometric = AssetHelper.icoTouchid;
      }
    });
    context.read<AuthenBloc>().add(AuthenEventRegisterLoginType(authenType: authenType));
  }
}
