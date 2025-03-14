import 'dart:async';

import 'package:b2b/app_manager.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/config.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/presentation/screens/log_screen.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_visibility_view.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';

enum AppBarType {
  POPUP,
  SMALL,
  NORMAL,
  SEMI_MEDIUM,
  MEDIUM,
  LARGE,
  FULL,
  HOME,
}

int countClick = 0;
StreamSubscription? clickTimeout;

class AppBarContainer extends StatelessWidget {
  const AppBarContainer({
    Key? key,
    this.title,
    required this.child,
    this.appBarType = AppBarType.NORMAL,
    this.onTap,
    this.onTapDown,
    this.onBack,
    this.hideBackButton = false,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.isHomePage = false,
    this.isShowKeyboardDoneButton = false,
    this.resizeToAvoidBottomInset = false,
    this.centerTitle = true,
    this.isTight = false,
    this.scaffoldkey,
  }) : super(key: key);

  final String? title;
  final Widget child;
  final AppBarType appBarType;
  final Function? onTap;
  final Function? onTapDown;
  final Function? onBack;
  final bool hideBackButton;
  final bool showBackButton;
  final bool resizeToAvoidBottomInset;
  final bool isHomePage;
  final bool isShowKeyboardDoneButton;
  final bool centerTitle;
  final bool isTight;
  final Color backgroundColor;
  final List<Widget>? actions;
  final GlobalKey? scaffoldkey;

  double heightOfAppBar(BuildContext context) {
    switch (appBarType) {
      case AppBarType.SMALL:
        return heightOfNativeAppBar(context);
      case AppBarType.POPUP:
        return 118;
      case AppBarType.NORMAL:
        return 138;
      case AppBarType.SEMI_MEDIUM:
        return 166;
      case AppBarType.MEDIUM:
        return 197;
      case AppBarType.LARGE:
        return 297;
      case AppBarType.HOME:
        return 0;
      case AppBarType.FULL:
        return SizeConfig.screenHeight;
      default:
        return 138;
    }
  }

  double heightOfAppBarSubContent(BuildContext context) {
    return heightOfAppBar(context) - 34 - heightOfNativeAppBar(context);
  }

  double heightOfContent(BuildContext context) {
    return SizeConfig.screenHeight - heightOfNativeAppBar(context);
  }

  double heightOfNativeAppBar(BuildContext context) {
    if (appBarType == AppBarType.FULL && title == null) {
      return 0;
    }
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = SizeConfig.isIphoneX() ? 14 : 0;

    return Stack(children: [
      Container(
        height: SizeConfig.screenHeight,
        color: const Color.fromRGBO(237, 241, 246, 1.0),
      ),
      if (appBarType == AppBarType.HOME && !isHomePage)
        Padding(
          padding: EdgeInsets.only(top: getInScreenSize(30 + paddingTop)),
          child: ImageHelper.loadFromAsset(
            AssetHelper.imgHomeTop2,
            width: SizeConfig.screenWidth,
          ),
        ),
      if (appBarType == AppBarType.HOME && isHomePage)
        Padding(
          padding: EdgeInsets.only(top: getInScreenSize(paddingTop)),
          child: ImageHelper.loadFromAsset(
            AssetHelper.imgHomeTop,
            width: SizeConfig.screenWidth,
          ),
        ),
      if (appBarType != AppBarType.HOME)
        Container(
          height: appBarType == AppBarType.FULL
              ? heightOfAppBar(context)
              : appBarType == AppBarType.SMALL
                  ? heightOfNativeAppBar(context)
                  : getInScreenSize(heightOfAppBar(context)),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(appBarType == AppBarType.FULL ? 0 : 20),
                  bottomRight:
                      Radius.circular(appBarType == AppBarType.FULL ? 0 : 20))),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0),
                height: appBarType == AppBarType.FULL
                    ? SizeConfig.screenHeight
                    : SizeConfig.screenWidth,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: appBarType == AppBarType.FULL
                      ? kGradientBackgroundAppBar
                      : kGradientBackgroundH,
                ),
              ),
              appBarType == AppBarType.FULL
                  ? Image.asset(
                      AssetHelper.imgBgLogin,
                      height: getInScreenSize(heightOfAppBar(context)),
                      width: SizeConfig.screenWidth,
                      fit: BoxFit.fitWidth,
                      alignment: appBarType == AppBarType.FULL
                          ? Alignment.bottomCenter
                          : Alignment.center,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ),
      Touchable(
        onTapDown: (onTapDetails) {
          if (AppConfig.buildType != BuildType.PRO_RELEASE) {
            countClick++;
            if (clickTimeout != null) {
              clearTimeout(clickTimeout!);
              clickTimeout = null;
            }
            if (countClick >= 10) {
              countClick = 0;
              pushNamed(context, LogScreen.routeName);
            } else {
              clickTimeout = setTimeout(() {
                countClick = 0;
              }, 1000);
            }
          }
          SessionManager().hasAction();
          onTapDown?.call();
        },
        onTap: () {
          // Logger.debug("TAPPPP Outside");
          // FocusManager.instance.primaryFocus?.unfocus();
          if (onTap != null) {
            onTap?.call();
          }
        },
        child: Scaffold(
          key: scaffoldkey,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: Column(
            children: [
              if (title != null && appBarType != AppBarType.HOME)
                AppBar(
                  actions: actions,
                  leadingWidth: isTight ? 42 : null,
                  // systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                  leading: hideBackButton
                      ? const SizedBox(height: 0)
                      : IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 24),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => {
                            setTimeout(() {
                              if (onBack == null) {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                onBack?.call();
                              }
                            }, 50)
                          },
                        ),
                  backgroundColor: Colors.transparent,
                  title: Text(
                    (title ?? '').toUpperCase(),
                    style: TextStyles.gHeader.whiteColor,
                  ),
                  titleSpacing: isTight ? 0 : null,
                  centerTitle: centerTitle,
                ),
              if (title != null && appBarType == AppBarType.HOME)
                AppBar(
                  actions: actions,
                  leadingWidth: hideBackButton || !showBackButton ? 5 : 35,
                  // systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                  leading: hideBackButton || !showBackButton
                      ? const SizedBox()
                      : IconButton(
                          padding: const EdgeInsets.only(left: 15),
                          icon: Icon(Icons.arrow_back,
                              color: AppColors.gTextColor, size: 24),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => {
                            setTimeout(() {
                              if (onBack == null) {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                onBack?.call();
                              }
                            }, 50)
                          },
                        ),
                  backgroundColor: Colors.transparent,
                  title: Touchable(
                      onTap: () {
                        if (hideBackButton) return;
                        setTimeout(() {
                          if (onBack == null) {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          } else {
                            onBack?.call();
                          }
                        }, 50);
                      },
                      child: Text(
                        (title ?? '').toUpperCase(),
                        style: TextStyles.gHeader.normalColor,
                      )),
                  centerTitle: false,
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
      if (isShowKeyboardDoneButton) const KeyboardVisibilityView(),
    ]);
  }
}
