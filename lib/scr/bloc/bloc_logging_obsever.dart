import 'dart:developer';

import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';

class AppBlocLoggingObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    Logger.debug('*** OnEvent *** \n${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // log('*** OnChange *** \n${bloc.state}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    Logger.debug('*** OnError *** \n${error.toString()}');
  }
}
