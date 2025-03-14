import 'package:b2b/config.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/remote_config_model.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:flutter/services.dart';
import 'dart:io' show File, FileMode, InternetAddress, Platform, SocketException, exit;

//Remote config
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AppManager {
  static final AppManager _singleton = AppManager._internal();
  final _nativeMethod = const MethodChannel('com.vpbank/native_channel');

  factory AppManager() {
    return _singleton;
  }

  AppManager._internal();

  RemoteConfigModel? remoteConfigModel;

  PackageInfo? currentAppInfo;

  String _deviceId = '';

  void initialize() async {
    _deviceId = await LocalStorageHelper.getDeviceId();
  }

  String get deviceId {
    return _deviceId;
  }

  void checkRoot(BuildContext context) async {
    bool isRooted = await _nativeMethod.invokeMethod('isThisCompromised');
    if (isRooted && AppConfig.buildType == BuildType.PRO_RELEASE) {
      showDialogCustom(
        context,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.stsNotificationStr.localized,
        AppTranslate.i18n.rootNoticeStr.localized,
        barrierDismissible: false,
        showCloseButton: false,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.rootCloseAppBtnStr.localized,
          dismiss: false,
          onTap: () async {
            forceCloseApp();
          },
        ),
      );
    }
  }

  Future<RemoteConfigModel?> getRemoteConfig() async {
    Logger.debug('getRemoteConfig');
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
    Logger.debug('await remoteConfig.fetchAndActivate()');
    var result = await remoteConfig.fetchAndActivate();

    Logger.debug('await remoteConfig.fetchAndActivate DONE');
    try {
      RemoteConfigModel model = RemoteConfigModel(
        forceUpdate: remoteConfig.getBool('force_update'),
        iosVersion: remoteConfig.getInt('ios_version'),
        androidVersion: remoteConfig.getInt('android_version'),
        updateMessageVi: remoteConfig.getString('update_message_vi'),
        updateMessageEn: remoteConfig.getString('update_message_en'),
        maintain: remoteConfig.getBool('maintain'),
        maintainMessageVn: remoteConfig.getString('maintain_message_vi'),
        maintainMessageEn: remoteConfig.getString('maintain_message_en'),
        maintainLink: remoteConfig.getString('maintain_link'),
        linkIos: remoteConfig.getString('link_ios'),
        linkAndroid: remoteConfig.getString('link_android'),
        allowFeedback: remoteConfig.getBool('allow_feedback'),
        surveyUrl: remoteConfig.getString('survey_url'),
      );
      remoteConfigModel = model;

      Logger.debug('allowFeedback   -------- ${remoteConfigModel?.allowFeedback}');
      return remoteConfigModel;
    } catch (e) {
      return null;
    }
    // if (result == true) {
    //   RemoteConfigModel remoteConfigModel = RemoteConfigModel(
    //     forceUpdate: remoteConfig.getBool('force_update'),
    //     iosVersion: remoteConfig.getInt('ios_version'),
    //     androidVersion: remoteConfig.getInt('android_version'),
    //     updateMessageVi: remoteConfig.getString('update_message_vi'),
    //     updateMessageEn: remoteConfig.getString('update_message_en'),
    //     maintain: remoteConfig.getBool('maintain'),
    //     maintainMessageVn: remoteConfig.getString('maintain_message_vi'),
    //     maintainMessageEn: remoteConfig.getString('maintain_message_en'),
    //     maintainLink: remoteConfig.getString('maintain_link'),
    //     linkIos: remoteConfig.getString('link_ios'),
    //     linkAndroid: remoteConfig.getString('link_android'),
    //   );
    //   return remoteConfigModel;
    // } else {
    //   return null;
    // }
  }

  checkVersion() async {
    if (AppConfig.env != AppEnvironment.Pro) {
      Logger.debug('checkVersion => skipped (not production build)');
      return;
    }
    Logger.debug('checkVersion');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    int versionCode = 0;
    AppManager().currentAppInfo = packageInfo;

    RemoteConfigModel? remoteConfigModel = await getRemoteConfig();

    if (remoteConfigModel == null) {
      print('remoteConfigModel == null');
      return;
    }
    try {
      versionCode = int.parse(buildNumber);
    } catch (e) {
      Logger.debug(e.toString());
    }

    int newVersion = Platform.isAndroid ? remoteConfigModel.androidVersion ?? 0 : remoteConfigModel.iosVersion ?? 0;

    print('newVersion $newVersion $versionCode');

    if (remoteConfigModel.forceUpdate == true && newVersion <= versionCode) {
      return;
    }

    if (remoteConfigModel.maintain == true || remoteConfigModel.forceUpdate == true || newVersion > versionCode) {
      String button1 = '';

      if (remoteConfigModel.maintain == true) {
        if ((remoteConfigModel.maintainLink ?? '').startsWith('https://') ||
            (remoteConfigModel.maintainLink ?? '').startsWith('http://')) {
          button1 = AppTranslate.i18n.seeMoreStr.localized.toUpperCase();
        } else {
          button1 = AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase();
        }
      } else {
        button1 = AppTranslate.i18n.dialogButtonSkipStr.localized.toUpperCase();
      }

      String message = '';

      if (remoteConfigModel.maintain == true) {
        message = remoteConfigModel.getMaintainMessage();
      } else {
        message = remoteConfigModel.getUpdateMessage();
      }

      int dem = 0;
      while (true) {
        print('check context');
        if (SessionManager().getContext != null) {
          BuildContext context = SessionManager().getContext!;
          showDialogCustom(
            context,
            AssetHelper.icFly,
            AppTranslate.i18n.stsNotificationStr.localized,
            message,
            barrierDismissible: false,
            showCloseButton: false,
            button1: renderDialogTextButton(
              context: context,
              title: button1,
              dismiss: false,
              onTap: () async {
                if (remoteConfigModel.maintain == true) {
                  if ((remoteConfigModel.maintainLink ?? '').startsWith('https://') ||
                      (remoteConfigModel.maintainLink ?? '').startsWith('http://')) {
                    await _launchURL(remoteConfigModel.maintainLink!);
                  } else {
                    forceCloseApp();
                  }
                } else if (remoteConfigModel.forceUpdate == true) {
                  forceCloseApp();
                } else if (newVersion > versionCode) {
                  popScreen(context);
                  return;
                }
              },
            ),
            button2: remoteConfigModel.maintain == true
                ? null
                : renderDialogTextButton(
                    dismiss: false,
                    context: context,
                    title: AppTranslate.i18n.titleConfirmStr.localized,
                    onTap: () {
                      String url =
                          Platform.isAndroid ? remoteConfigModel.linkAndroid ?? '' : remoteConfigModel.linkIos ?? '';
                      if (url.isNotEmpty) {
                        _launchURL(url);
                      }
                    },
                  ),
          );
          break;
        }
        if (dem >= 30) {
          break;
        }
        dem++;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  forceCloseApp() {
    Logger.debug('forceCloseApp');
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  Future<void> _launchURL(url) async {
    bool canLoadUrl = await canLaunch(url);
    if (canLoadUrl) {
      await launch(url);
    } else {
      Logger.debug('Can not load url $url');
    }
  }
}
