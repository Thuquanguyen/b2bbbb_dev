import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/widgets.dart';
const ON_CHANGE_SCREEN = 'ON_CHANGE_SCREEN';
class AppLoggingRoutesObserver extends NavigatorObserver {

  void onChangeScreen(String? screen) {
    SessionManager().hasAction();
    MessageHandler().notify(ON_CHANGE_SCREEN, data: screen ?? '');
    setCurrentScreen(screen ?? '');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    Logger.debug(
      '[Navigator] Route Pushed: '
      "(Pushed Route='${route.settings.name}', "
      "Previous Route='${previousRoute?.settings.name}'"
      ')',
    );
    onChangeScreen(route.settings.name);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    Logger.debug(
      '[Navigator] Route Popped: '
      "(New Route='${previousRoute?.settings.name}', "
      "Popped Route='${route.settings.name}'"
      ')',
    );
    onChangeScreen(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    Logger.debug(
      '[Navigator] Route Replaced: '
      "(New Route='${newRoute?.settings.name}', "
      "Old Route='${oldRoute?.settings.name}'"
      ')',
    );
    onChangeScreen(newRoute?.settings.name);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    Logger.debug(
      '[Navigator] Route Removed: '
      "(New Route='${previousRoute?.settings.name}', "
      "Removed Route='${route.settings.name}'"
      ')',
    );
    onChangeScreen(previousRoute?.settings.name);
  }
}
