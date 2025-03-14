import 'dart:async';

import 'package:b2b/scr/core/api_service/data_connection_checker.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';

part 'connect_internet_state.dart';

class ConnectInternetCubit extends Cubit<bool> {
  ConnectInternetCubit() : super(false) {
    try {
      checkInternetConnected();
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          if (result == ConnectivityResult.none) {
            emit(false);
          } else {
            checkInternetConnected();
          }
        },
      );
    } catch (e) {
      Logger.debug(e);
    }
  }
  late StreamSubscription<ConnectivityResult> subscription;

  void checkInternetConnected() async {
    final isDeviceConnected = await DataConnectionChecker().hasConnection;
    if (isDeviceConnected) {
      emit(true);
    } else {
      emit(false);
    }
  }
}
