import 'dart:async';

import 'package:b2b/scr/data/model/auth/login_model.dart';
import 'package:b2b/scr/data/model/auth/menu_model.dart';
import 'package:b2b/scr/data/model/auth/register_type_model.dart';
import 'package:b2b/scr/data/model/auth/session_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/repository/authen_repository.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';

part 'authen_event.dart';

part 'authen_state.dart';

class AuthenBloc extends Bloc<AuthenEvent, AuthenState> {
  AuthenBloc({required this.authenRepository}) : super(const AuthenState());

  final AuthenRepositoryImpl authenRepository;

  @override
  Stream<AuthenState> mapEventToState(
    AuthenEvent event,
  ) async* {
    if (event is AuthenEventStartApp) {
      Logger.debug('init Bloc');
    } else if (event is AuthenEventLogin) {
      yield* _mapLoginState(event, state);
    } else if (event is AuthenEventReLogin) {
      yield* _mapReLoginState(event, state);
    } else if (event is AuthenEventRegisterLoginType) {
      yield* _mapRegisterLoginTypeState(event, state);
    } else if (event is AuthenEventGetSession) {
      yield* _mapSessionState(event, state);
    } else if (event is AuthenEventGetMenuUserPermission) {
      yield* _mapMenuUserPermissionState(event, state);
    } else if (event is AuthenEventLogOut) {
      _logoutState();
    } else if (event is AuthenEventCleanUserDevice) {
      _clearUserDevice(event);
    } else {
      // yield Unauthenticated();
    }
  }

  void _logoutState() {
    authenRepository.logout();
  }

  void _clearUserDevice(AuthenEventCleanUserDevice event) {
    Logger.debug('event.username ${event.username}');
    authenRepository.cleanUserDevice(event.username);
  }

  Stream<AuthenState> _mapLoginState(
      AuthenEventLogin event, AuthenState state) async* {
    // throw the loading state
    yield const AuthenState(loginState: DataState.preload);
    try {
      Logger.debug('event.username ${event.username}');
      final responseData = await authenRepository.login(
          event.username, event.password, event.authenType);
      final code = responseData.item.result?.code;
      AuthenStatus loginStatus;
      if (code == '200') {
        loginStatus = AuthenStatus.SUCCESS;
      } else if (code == '201') {
        loginStatus = AuthenStatus.OTP;
      } else if (code == '998' || code == '999') {
        loginStatus = AuthenStatus.MAINTENANCE;
      } else if (code == '444') {
        loginStatus = AuthenStatus.BIOMETRIC_INVALID;
      } else {
        loginStatus = AuthenStatus.ERROR;
      }
      yield AuthenState(
          loginModel: responseData.item,
          loginState: DataState.data,
          loginStatus: loginStatus);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AuthenState(loginState: DataState.error);
    }
  }

  Stream<AuthenState> _mapReLoginState(
      AuthenEventReLogin event, AuthenState state) async* {
    // throw the loading state
    yield const AuthenState(loginState: DataState.preload);
    try {
      Logger.debug('event.username ${event.username}');
      final responseData = await authenRepository.login(
          event.username, event.password, event.authenType);
      final code = responseData.item.result?.code;
      AuthenStatus loginStatus;
      if (code == '200') {
        loginStatus = AuthenStatus.SUCCESS;
      } else {
        loginStatus = AuthenStatus.ERROR;
      }
      yield AuthenState(
          loginModel: responseData.item,
          loginState: DataState.data,
          loginStatus: loginStatus);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AuthenState(loginState: DataState.error);
    }
  }

  Stream<AuthenState> _mapRegisterLoginTypeState(
      AuthenEventRegisterLoginType event, AuthenState state) async* {
    // throw the loading state
    yield const AuthenState(registerState: DataState.preload);
    try {
      final responseData =
          await authenRepository.registerLoginType(event.authenType);
      final code = responseData.item.result?.code;
      AuthenStatus registerStatus;
      if (code == '200') {
        registerStatus = AuthenStatus.SUCCESS;
        MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
      } else {
        registerStatus = AuthenStatus.ERROR;
      }
      yield AuthenState(
          registerModel: responseData.item,
          registerState: DataState.data,
          registerStatus: registerStatus);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AuthenState(registerState: DataState.error);
    }
  }

  Stream<AuthenState> _mapMenuUserPermissionState(
      AuthenEventGetMenuUserPermission event, AuthenState state) async* {
    // throw the loading state
    yield const AuthenState(menuState: DataState.preload);
    try {
      final responseData = await authenRepository.getMenuUserPermission();
      final code = responseData.item.result?.code;
      AuthenStatus menuStatus;
      if (code == '200') {
        menuStatus = AuthenStatus.SUCCESS;
      } else {
        menuStatus = AuthenStatus.ERROR;
      }
      // responseData.item.toArrayModel((json) => BeneficianAccountModel.fromJson(json))
      yield AuthenState(
          menuModel: responseData.item
              .toArrayModel((json) => MenuModel.fromJson(json)),
          menuState: DataState.data,
          menuStatus: menuStatus);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AuthenState(menuState: DataState.error);
    }
  }

  Stream<AuthenState> _mapSessionState(
      AuthenEventGetSession event, AuthenState state) async* {
    // throw the loading state
    yield const AuthenState(sessionState: DataState.preload);
    try {
      final responseData = await authenRepository.getSessionInfo();
      final code = responseData.item.result?.code;
      AuthenStatus sessionStatus;
      if (code == '200') {
        sessionStatus = AuthenStatus.SUCCESS;
      } else if (code == '202') {
        sessionStatus = AuthenStatus.CHANGE_PASSWORD;
      } else {
        sessionStatus = AuthenStatus.ERROR;
      }

      SessionModel sessionModel = responseData.item.toModel(
        (json) => SessionModel.fromJson(json),
      );

      RolePermissionManager().getUserRole(sessionModel);
      yield AuthenState(
          sessionModel: sessionModel,
          sessionState: DataState.data,
          sessionStatus: sessionStatus);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AuthenState(sessionState: DataState.error);
    }
  }
}
