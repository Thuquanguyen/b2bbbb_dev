class SettingManager {
  factory SettingManager() => _instance;

  SettingManager._();

  static final _instance = SettingManager._();

  bool isNotificationActivated = false;
}
