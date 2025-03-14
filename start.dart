import 'dart:io';
import 'dart:isolate';

import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:yaml/yaml.dart';

class BuildConfig {
  final String? buildType;
  final String? env;
  final String? versionName;
  final String? buildNumber;
  final String? firebaseAndroidId;
  final String? firebaseiOSId;

  BuildConfig({
    this.buildType,
    this.env,
    this.versionName,
    this.buildNumber,
    this.firebaseAndroidId,
    this.firebaseiOSId,
  });
}

Isolate? timerIsolate;

void main() async {
  applyConfig();
}

Future<BuildConfig?> applyConfig() async {
  stdout.write('🚚 Getting dependencies... ');
  startTimer();
  ProcessResult pubgetRes = await Process.run('flutter', ['pub', 'get']);
  stopTimer();
  if (pubgetRes.exitCode != 0) {
    stdout.write('❌ Error!\n');
    return Future.value(null);
  } else {
    stdout.write('👍🏻 Done!\n');
  }
  var doc = loadYaml(File('pubspec.yaml').readAsStringSync());
  List<String> vers = doc['version'].toString().split('+');
  String? buildType = doc['build_type'];
  String? env = doc['env'];
  String? fbai = doc['firebase_android_id'];
  String? fbii = doc['firebase_ios_id'];
  if (!{'DEV', 'PRO_DEBUG', 'PRO_RELEASE'}.contains(buildType)) {
    stdout.write('\n❌ Build type $buildType is invalid! Aborted.');
    return Future.value(null);
  }
  if (!{'Dev', 'Pro'}.contains(env)) {
    stdout.write('\n❌ Environment $env is invalid! Aborted.');
    return Future.value(null);
  }
  stdout.write(
    '\nℹ️  VPBank NeoBiz version ${vers[0]} build ${vers[1]} $buildType ($env)',
  );

  Directory current = Directory.current;
  File configFile = File('${current.path}/lib/config.dart');
  await configFile.writeAsString('''
// Generated file. Do not edit!
enum BuildType { DEV, PRO_DEBUG, PRO_RELEASE }

enum AppEnvironment {
  Dev,
  Pro,
}

class AppConfig {
  static BuildType buildType = BuildType.$buildType;
  static AppEnvironment env = AppEnvironment.$env;
  static String versionName = '${vers[0]}';
  static String buildNumber = '${vers[1]}';
  static String firebaseAndroidId = '$fbai';
  static String firebaseiOSId = '$fbii';
}
''');

  try {
    updateVersionInfo(vers[0], vers[1]);
  } catch (e) {
    return Future.value(null);
  }

  return Future.value(BuildConfig(
    buildType: buildType,
    env: env,
    versionName: vers[0],
    buildNumber: vers[1],
    firebaseAndroidId: fbai,
    firebaseiOSId: fbii,
  ));
}

void updateVersionInfo(String versionName, String buildNumber) {
  stdout.write('\n⏳ Updating version info...');
  File iosInfoFile = File('ios/Runner/Info.plist');
  File iosInfoDebugFile = File('ios/Runner/Info.debug.plist');
  File iosNotiAppexInfoFile = File('ios/CustomNotification/Info.plist');
  updateIosVersionInfo(iosInfoFile, versionName, buildNumber);
  updateIosVersionInfo(iosInfoDebugFile, versionName, buildNumber);
  updateIosVersionInfo(iosNotiAppexInfoFile, versionName, buildNumber);
  updateAndroidVersionInfo(versionName, buildNumber);
}

void updateIosVersionInfo(
  File infoPlist,
  String versionName,
  String buildNumber,
) {
  try {
    int versionIndex = -1;
    int buildNumberIndex = -1;
    List<String> infos = infoPlist.readAsLinesSync();
    infos.forEachIndexed((v, i) {
      if (v == '	<key>CFBundleShortVersionString</key>') {
        versionIndex = i + 1;
      }

      if (v == '	<key>CFBundleVersion</key>') {
        buildNumberIndex = i + 1;
      }
    });

    infos[versionIndex] = '	<string>$versionName</string>';
    infos[buildNumberIndex] = '	<string>$buildNumber</string>';
    infoPlist.writeAsStringSync(infos.join('\n'));
    stdout.write('\n👉🏻 ${infoPlist.path} updated');
  } catch (e) {
    stdout.write('❌ Error!\n');
    rethrow;
  }
}

void updateAndroidVersionInfo(
  String versionName,
  String buildNumber,
) {
  try {
    File androidProp = File('android/local.properties');
    List<String> props = androidProp.readAsLinesSync();
    int versionIndex = -1;
    int buildNumberIndex = -1;
    props.forEachIndexed((v, i) {
      if (v.contains('flutter.versionName')) {
        versionIndex = i;
      }

      if (v.contains('flutter.versionCode')) {
        buildNumberIndex = i;
      }
    });

    props[versionIndex] = 'flutter.versionName=$versionName';
    props[buildNumberIndex] = 'flutter.versionCode=$buildNumber';
    androidProp.writeAsStringSync(props.join('\n'));
    stdout.write('\n👉🏻 ${androidProp.path} updated');
  } catch (e) {
    stdout.write('❌ Error!\n');
    rethrow;
  }
}

void startTimer() async {
  timerIsolate = await Isolate.spawn((_) async {
    stdout.write('\n');
    int sec = 0;
    while (true) {
      stdout.write('\r$sec seconds elapsed... ');
      await Future.delayed(const Duration(seconds: 1));
      sec += 1;
    }
  }, null);
}

void stopTimer() {
  timerIsolate?.kill();
}
