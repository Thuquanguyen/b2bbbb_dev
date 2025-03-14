import 'dart:async';

import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/repository/authen_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:b2b/scr/data/model/change_password_request_model.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({required this.authenRepository}) : super(const ChangePasswordState());

  final AuthenRepositoryImpl authenRepository;

  @override
  Stream<ChangePasswordState> mapEventToState(ChangePasswordEvent event) async* {
    if (event is ChangePasswordExecuteEvent) {
      yield* _changePassword(event);
    }
  }

  Stream<ChangePasswordState> _changePassword(ChangePasswordExecuteEvent event) async* {
    yield ChangePasswordState(dataState: DataState.preload);
    try {
      final responseData = await authenRepository.changePassword(event.request);
      final code = responseData.code;
      ChangePasswordStatus status;
      if (code == '200') {
        status = ChangePasswordStatus.SUCCESS;
        SessionManager().doingChangePassword = false;
      } else {
        status = ChangePasswordStatus.OTHER;
      }
      yield ChangePasswordState(dataState: DataState.data, status: status, message: responseData.getMessage());
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield ChangePasswordState(dataState: DataState.error);
    }
  }
}