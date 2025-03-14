// ignore_for_file: file_names

import 'dart:io';
import 'package:b2b/utilities/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'user.dart';

// ignore: avoid_classes_with_only_static_members
class LocalStorageHelper {
  static FlutterSecureStorage prefs = const FlutterSecureStorage();
  static String _prefix = '';

  static String DEVICE_ID_KEY = '78a24a02-0905-4402-9006-ac5a62465494';

  //Shared prefences
  static Future setInt(String key, int value) async {
    await prefs.write(key: '$_prefix$key', value: value.toString());
  }

  static Future setDouble(String key, double value) async {
    await prefs.write(key: '$_prefix$key', value: value.toString());
  }

  static Future setBool(String key, bool value) async {
    await prefs.write(key: '$_prefix$key', value: value ? 'true' : 'false');
  }

  static Future setString(String key, String value) async {
    await prefs.write(key: '$_prefix$key', value: value);
  }

  static Future setStringList(String key, List<String> values) async {
    try {
      await prefs.write(key: '$_prefix$key', value: values.join("||"));
      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  }

  static Future<dynamic> getData(String key) async {
    return prefs.read(key: '$_prefix$key');
  }

  static Future<int?> getInt(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return int.parse(value);
      }
    } catch (e) {}
    return null;
  }

  static Future setCurrentUser(String username) async {
    LocalStorageHelper._prefix = username;
    Logger.debug('[B2B] SET CURRENT USER TO $username');
    await prefs.write(key: 'vpb_current_user', value: username);
  }

  static Future<String?> getCurrentUser() async {
    try {
      final value = await prefs.read(key: 'vpb_current_user');
      if (value != null) {
        Logger.debug('[B2B] CURRENT USER IS $value');
        LocalStorageHelper._prefix = value;
        return value;
      }
    } catch (e) {}
    return null;
    // if (prefs.getString('vpb_current_user') != null) {
    //   final username = prefs.getString('vpb_current_user')!;
    //   Logger.debug('[B2B] CURRENT USER IS $username');
    //   LocalStorageHelper._prefix = username;
    //   return username;
    // } else {
    //   return null;
    // }
  }

  static Future setAppPinCode(String pinCode) async {
    await prefs.write(key: '${_prefix}vpb_app_pin_code', value: pinCode);
  }

  static Future<String> getAppPinCode() async {
    try {
      final value = await prefs.read(key: '${_prefix}vpb_app_pin_code');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return '';
  }

  static Future setOtpPinCode(String pinCode) async {
    await prefs.write(key: 'vpb_otp_pin_code', value: pinCode);
  }

  static Future<String> getOtpPinCode() async {
    try {
      final value = await prefs.read(key: 'vpb_otp_pin_code');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return '';
  }

  static Future setLanguage(String lang) async {
    await prefs.write(key: 'vpb_language', value: lang);
  }

  static Future<String?> getLanguage() async {
    try {
      final value = await prefs.read(key: 'vpb_language');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return null;
  }

  static Future clearOtpPinCode() async {
    await prefs.delete(key: 'vpb_otp_pin_code');
  }

  static Future saveUsers(String users) async {
    await prefs.write(key: 'vpb_list_users', value: users);
  }

  static Future<String> getUsers() async {
    try {
      final value = await prefs.read(key: 'vpb_list_users');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return '[]';
  }

  static Future<String> getTimeInstallApp() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      final time = _prefs.getString('time_install_app');
      if (time != null) {
        return time;
      } else {
        prefs.deleteAll();
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        await _prefs.setString('time_install_app', time);
        return time;
      }
    } catch (e) {}
    return 'none';
  }

  static Future<double?> getDouble(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return double.parse(value);
      }
    } catch (e) {}
    return null;
  }

  static Future<bool?> getBool(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return value == 'true';
      }
    } catch (e) {}
    return null;
  }

  static Future<String?> getString(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return null;
  }

  static Future<List<String>?> getStringListWithPrefix(String key, String prefix) async {
    try {
      final value = await prefs.read(key: '$prefix$key');
      if (value != null) {
        return value.split('||');
      }
    } catch (e) {}
    return null;
  }

  static Future<List<String>?> getStringList(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return value.split('||');
      }
    } catch (e) {}
    return null;
  }

  static Future removeData(String key) async {
    await prefs.delete(key: '$_prefix$key');
  }

  //Write and read file
  static late String _fileName;

  static String get _getFileName {
    return _fileName;
  }

  static void _setFileName(String filename) {
    _fileName = filename;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_getFileName.txt');
  }

  static Future<File> writeToFile(String fileName, dynamic data) async {
    _setFileName(fileName);
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$data');
  }

  static Future<String> readFromFile(String filename) async {
    try {
      _setFileName(filename);
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      Logger.debug(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return ""
      return '';
    }
  }

  //SQLite
  static late String _databasebName = '';

  static late String _tableName = '';

  static late String _arguments = '';

  static late int _sqliteVersion = -1;

  static bool _databaseCreated() {
    if (_databasebName == '' || _tableName == '' || _sqliteVersion == -1) {
      return false;
    } else {
      return true;
    }
  }

  //Create a table in SQLite
  static Future<Database> createDatabase(String db, String table, String arg, int version) async {
    final String path = await getDatabasesPath();
    _databasebName = db;
    _tableName = table;
    _arguments = arg;
    _sqliteVersion = version;
    return openDatabase(join(path, '$db.db'), onCreate: (database, version) async {
      await database.execute(
        arg,
      );
    }, version: version);
  }

  static Future<Database?> _initializeDB() async {
    if (!_databaseCreated()) {
      return null;
    }
    final String path = await getDatabasesPath();
    return openDatabase(join(path, '$_databasebName.db'), onCreate: (database, version) async {
      await database.execute(
        _arguments,
      );
    }, version: _sqliteVersion);
  }

  //Saving data in SQLite
  static Future<int> insertRow(String table, List<dynamic> dataList) async {
    int result = 0;
    final Database? db = await _initializeDB();
    if (db == null) {
      Logger.debug('null');
      return -1;
    } else {
      for (var user in dataList) {
        result = await db.insert(table, user.toMap());
      }
      return result;
    }
  }

  //Retrieve data from SQLite
  static Future<List<Object>?> retrieveTable(String table) async {
    final Database? db = await _initializeDB();
    if (db == null) {
      return null;
    } else {
      final List<Map<String, Object?>> queryResult = await db.query(table);
      return queryResult.map((e) => User.fromMap(e)).toList();
    }
  }

  //Delete data from SQLite
  static Future<void> deleteRowByID(String table, int id) async {
    final Database? db = await _initializeDB();
    try {
      await db!.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      Logger.debug('Error: $e');
    }
  }

  //Delete data from SQLite
  static Future<void> deleteRowByKey(String table, dynamic key, String object) async {
    final Database? db = await _initializeDB();
    try {
      await db!.delete(table, where: '$key = ?', whereArgs: [object]);
    } catch (e) {
      Logger.debug('Error: $e');
    }
  }

  static Future<String> getDeviceId() async {
    String? deviceId = await prefs.read(key: LocalStorageHelper.DEVICE_ID_KEY);
    if (deviceId.isNullOrEmpty) {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        final androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.androidId; // unique ID on Android
      }

      if (deviceId.isNullOrEmpty) {
        deviceId = const Uuid().v4();
      }

      await LocalStorageHelper.setString(LocalStorageHelper.DEVICE_ID_KEY, deviceId!);
    }

    return Future.value(deviceId);
  }

  static clearDeviceId() async {
    await prefs.delete(key: LocalStorageHelper.DEVICE_ID_KEY);
  }
}
