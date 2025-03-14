import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/cubit/connect_internet_cubit/connect_internet_cubit.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppInterceptorLogging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // if (SessionManager().getContext != null &&
    //     !BlocProvider.of<ConnectInternetCubit>(SessionManager().getContext!).state) {
    //   // popScreen(SessionManager().getContext!, routeName: ReLoginScreen.routeName);
    //   // return;?
    //   showDialogErrorForceGoBack(SessionManager().getContext!, 'Lỗi mạng', () {
    //     Navigator.of(SessionManager().getContext!).pop();
    //   });
    //   return super.onError(
    //     DioError(
    //       requestOptions: options,
    //       type: DioErrorType.connectTimeout,
    //     ),
    //     ErrorInterceptorHandler(),
    //   );
    // }
    Logger.info('*** Request ***\nREQUEST[${options.method}] => ${options.uri}', logToFile: true);
    if (options.method == 'POST' || options.method == 'PUT') {
      Logger.info('*** PARAMS ***\n' + options.data.toString(), logToFile: true);
    }
    if (options.method == 'GET') {
      Logger.info('*** PARAMS ***\n' + options.queryParameters.toString(), logToFile: true);
    }
    Logger.info('*** HEADERS ***\n' + options.headers.toString(), logToFile: true);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.info(
        '*** Response ***\nRESPONSE[${response.statusCode}] => ${response.realUri}\n${response.data.toString()}',
        logToFile: true);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger.info(
        '*** Error ***\nERROR[${err.response?.data?['code'] ?? err.response?.statusCode}] => ${err.requestOptions.uri} WITH MESSAGE: ${err.response?.data?['message'] ?? err.message}',
        logToFile: true);
    return super.onError(err, handler);
  }
}
