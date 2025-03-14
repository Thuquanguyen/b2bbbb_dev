import 'dart:io';

import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:b2b/scr/core/extensions/color_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/example_presentation/intro/intro_screen.dart';
import 'package:b2b/scr/example_presentation/second_page.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:b2b/utilities/animation_helper/animationhelper_scene.dart';
import 'package:b2b/utilities/candlestick/candlesstick_scene.dart';
import 'package:b2b/utilities/image_helper/imagehelper_scene.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper_scene.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  static const String routeName = 'first_page';

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  LocalAuthentication localAuth = LocalAuthentication();
  late bool canCheckBiometrics;

  List<Map<String, String>> cellData = <Map<String, String>>[
    {
      'key': '0',
      'title':
          'Change language', // title is defined as a const, so we can not use the localize feature here
    },
    {
      'key': '1',
      'title': 'Try to "Crash" immediately',
    },
    {
      'key': '2',
      'title': 'Try to "Authen" with biometric',
    },
    {
      'key': '3',
      'title': 'Demo "Image helper" widget',
    },
    {
      'key': '4',
      'title': 'Demo "Local storage helper" feature',
    },
    {
      'key': '5',
      'title': 'Try "Animation helper"',
    },
    {
      'key': '6',
      'title': 'Demo Candle Chart',
    },
    {
      'key': '7',
      'title': 'Demo Intro screen',
    },
    {
      'key': '8',
      'title': 'Demo form & validation in screen',
    },
    {
      'key': '9',
      'title': 'Demo OTP screen',
    },
    {
      'key': '10',
      'title': 'Demo infinity list in screen',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig.init(context);
  }

  // ignore: avoid_void_async
  void simulateCrashAction() async {
    // FirebaseCrashlytics.instance.crash();
  }

  // ignore: avoid_void_async
  void activeBiometric() async {
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    try {
      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        late final String localizedReason;
        IOSAuthMessages? iosAuthMessages;
        AndroidAuthMessages? androidAuthMessages;
        if (Platform.isIOS) {
          if (availableBiometrics.contains(BiometricType.face)) {
            iosAuthMessages = const IOSAuthMessages(
              cancelButton: 'Hủy',
              goToSettingsButton: 'Cài đặt',
              goToSettingsDescription: 'Vui lòng cái đặt xác thực FaceID',
              lockOut: 'Bạn đã quá số lần thử',
            );
            localizedReason = 'Vui lòng sử dụng FaceID để xác thực';
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            iosAuthMessages = const IOSAuthMessages(
              cancelButton: 'Hủy',
              goToSettingsButton: 'Cài đặt',
              goToSettingsDescription: 'Vui lòng cái đặt xác thực TouchID',
              lockOut: 'Bạn đã quá số lần thử',
            );
            localizedReason = 'Vui lòng sử dụng TouchID để xác thực';
          }
        } else {
          if (availableBiometrics.contains(BiometricType.fingerprint)) {
            androidAuthMessages = const AndroidAuthMessages(
              cancelButton: 'Hủy',
              goToSettingsButton: 'settings',
              goToSettingsDescription:
                  'Vui lòng cài đặt vân tay để sử dụng xác thực',
            );
            localizedReason = 'Vui lòng sử dụng sinh trắc học để xác thực';
          }
        }
        final bool author = await localAuth.authenticate(
          localizedReason: localizedReason,
          useErrorDialogs: true,
          androidAuthStrings:
              androidAuthMessages ?? const AndroidAuthMessages(),
          iOSAuthStrings: iosAuthMessages ?? const IOSAuthMessages(),
          biometricOnly: true,
        );
        Logger.debug(author);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }

  void _onSecondPage() {
    Navigator.of(context).pushNamed(SecondPage.routeName,
        arguments: {'title': 'page_2'.localized});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page_1'.localized),
      ),
      body: ListView.builder(
          itemCount: cellData.length,
          itemBuilder: (context, index) {
            return DemoCell(
              key: ValueKey(index),
              data: cellData[index],
              onTap: (cellIndex) {
                Logger.debug('current cell index = $cellIndex');
                switch (cellIndex) {
                  case 0:
                    if (AppTranslate().currentLanguage == SupportLanguages.Vi) {
                      AppTranslate().setLanguage(SupportLanguages.En);
                    } else {
                      AppTranslate().setLanguage(SupportLanguages.Vi);
                    }
                    setState(() {});
                    break;
                  case 1:
                    simulateCrashAction();
                    break;
                  case 2:
                    activeBiometric();
                    break;
                  case 3:
                    Navigator.of(context).pushNamed(ImageHelperScene.routeName);
                    break;
                  case 4:
                    Navigator.of(context)
                        .pushNamed(LocalStorageHelperScene.routeName);
                    break;
                  case 5:
                    Navigator.of(context)
                        .pushNamed(AnimationHelperScene.routeName);
                    break;
                  case 6:
                    Navigator.of(context)
                        .pushNamed(CandlesStickScene.ruoteName);
                    break;
                  case 7:
                    Navigator.of(context).pushNamed(IntroScreen.routeName);
                    break;
                  case 8:
                    break;
                  case 9:
                    break;
                  case 10:
                    break;
                  default:
                    break;
                }
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSecondPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

typedef DemoCellCallback = void Function(int);

// ignore: must_be_immutable
class DemoCell extends StatelessWidget {
  const DemoCell({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);
  final Map<String, String> data;
  final DemoCellCallback onTap;

  @override
  Widget build(BuildContext context) {
    Logger.debug(key);
    return Touchable(
      onTap: () {
        onTap(int.parse(data['key']!));
      },
      child: Container(
        decoration: BoxDecoration(
          color: (int.parse(data['key']!) % 2 == 0)
              ? Colors.white
              : HexColor.fromHex('#f1f1f1'),
          border:
              const Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        width: SizeConfig.screenWidth,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(data['title']!),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
