import 'dart:io';

import 'package:b2b/app_manager.dart';
import 'package:b2b/config.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';

import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';

import 'package:b2b/scr/core/routes/routes.dart';

import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/screens/auth/first_login_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = 'splash_screen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  double? logoTop;
  double? logoWidth;
  double? logoHeight;
  double? logoMarginLeft;
  double? opacity;
  bool hasTimeout = false;

  Future<void> clearLogs() async {
    if (AppConfig.buildType != BuildType.PRO_RELEASE) {
      String? path = await Logger.getFilePath();
      if (path != null) {
        final file = File(path);
        await file.delete(recursive: true);
        await file.writeAsString('', mode: FileMode.append);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setTimeout(() {
      init();
    }, 300);
  }

  String version = '';

  Future<void> initVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = '${AppTranslate.i18n.versionStr.localized}: ${packageInfo.version} ';
    String buildType = '';
    if (AppEnvironmentManager.environment == AppEnvironment.Dev) {
      buildType = '- DEV';
    }

    setState(() {
      version = '$version $buildType';
    });
  }

  init() async {
    clearLogs();
    initVersion();
    await LocalStorageHelper.getTimeInstallApp();
    await checkSession();
    AppManager().checkVersion();
  }

  Future<void> checkSession() async {
    if (hasTimeout == true) {
      return;
    }
    hasTimeout = true;
    await AccountManager().loadUsers();
    if (AccountManager().getUsers().isNotEmpty) {
      setTimeout(() {
        startAnimation2();
      }, 1050);
      setTimeout(() {
        Logger.debug('move to re-login screen');
        // pushReplacementNamed(context, TransactionInquiryScreen.routeName,
        //     animation: true);
        pushReplacementNamed(context, ReLoginScreen.routeName, animation: false);
        // Navigator.of(context).pushReplacementNamed(ReLoginScreen.routeName, arguments: {});
      }, 1600);
      return;
    }
    setTimeout(() {
      startAnimation1();
    }, 1050);
    setTimeout(() {
      Logger.debug('move to first-login screen');
      // pushReplacementNamed(context, FirstLoginScreen.routeName,
      //     animation: true);
      pushReplacementNamed(context, FirstLoginScreen.routeName, animation: false);
    }, 1600);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig.init(context);
    setTimeout(() {
      startAnimation0();
    }, 300);
  }

  void startAnimation0() {
    setState(() {
      opacity = 1;
    });
  }

  void startAnimation1() {
    setState(() {
      logoTop = SizeConfig.screenPaddingTop + 60 + 28;
      logoWidth = getInScreenSize(260);
      logoHeight = getInScreenSize(66);
      logoMarginLeft = (SizeConfig.screenWidth - getInScreenSize(260)) / 2;
    });
  }

  void startAnimation2() {
    setState(() {
      logoTop = SizeConfig.screenPaddingTop;
      logoWidth = getInScreenSize(162);
      logoHeight = getInScreenSize(40);
      logoMarginLeft = 16;
    });
  }

  @override
  Widget build(BuildContext context) {
    logoTop ??= 4 * SizeConfig.screenWidth / 5;
    logoWidth ??= getInScreenSize(260 * 1.15);
    logoHeight ??= getInScreenSize(66 * 1.15);
    logoMarginLeft ??= (SizeConfig.screenWidth - logoWidth!) / 2;
    opacity ??= 0;
    return AppBarContainer(
      appBarType: AppBarType.FULL,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: opacity!,
              child: Container(
                alignment: Alignment.topLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: logoMarginLeft!, top: logoTop!),
                  width: logoWidth!,
                  height: logoHeight!,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: logoMarginLeft == 16 ? 1 : 0,
                        child: Image.asset(AssetHelper.icoVpbankSplashNoTagline),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        opacity: logoMarginLeft == 16 ? 0 : 1,
                        child: Image.asset(AssetHelper.icoVpbankSplash),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Container(
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Text(
                version.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyles.smallText.copyWith(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
