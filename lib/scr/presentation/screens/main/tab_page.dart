import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';

import 'home_action_manager.dart';

// ignore: constant_identifier_names
enum TabPage { HOME, TRANSACTION, NOTIFICATION, MORE }

// ignore: constant_identifier_names
final List<Map<String, Object>> TABS = [
  {
    'title': AppTranslate.i18n.tabHomeStr,
    'icon': AssetHelper.icoTabHome,
    'page': TabPage.HOME,
  },
  {
    'title': AppTranslate.i18n.tabTransactionStr,
    'icon': AssetHelper.icoTabTransaction,
    'page': TabPage.TRANSACTION,
  },
  {
    'title': AppTranslate.i18n.tabNotificationStr,
    'icon': AssetHelper.icoTabNotification,
    'page': TabPage.NOTIFICATION,
  },
  {
    'title': AppTranslate.i18n.tabMoreStr,
    'icon': AssetHelper.icoTabMore,
    'page': TabPage.MORE,
  },
];
