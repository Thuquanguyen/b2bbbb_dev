import 'dart:async';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/repository/account_info_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_info_state.dart';

part 'account_info_event.dart';

class AccountInfoBloc extends Bloc<AccountInfoEvent, AccountInfoState> {
  AccountInfoBloc({required this.accountInfoRepository}) : super(const AccountInfoState());

  final AccountInfoRepositoryImpl accountInfoRepository;

  @override
  Stream<AccountInfoState> mapEventToState(AccountInfoEvent event) async* {
    if (event is AccountInfoEventGetAccountList) {
      yield* _getAccountList(event, state);
    } else if (event is AccountInfoEventSendStatement) {
      yield* _sendStatement(event, state);
    } else if (event is AccountInfoEventSendStatementOnline) {
      yield* _sendStatementOnline(event, state);
    } else {}
  }

  Stream<AccountInfoState> _getAccountList(AccountInfoEventGetAccountList event, AccountInfoState state) async* {
    yield const AccountInfoState(dataState: DataState.preload);
    try {
      final responseData = await accountInfoRepository.getAccountList();
      if (responseData.result!.isSuccess()) {
        final response = SingleResponse<AccountModel>(responseData.data, (item) => AccountModel.fromJson(item));
        yield AccountInfoState(
          accountModel: response.item,
          dataState: DataState.data,
        );
      } else {
        throw responseData;
      }
    } on BaseResultModel catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield AccountInfoState(
        dataState: DataState.error,
        errorMessage: e.getMessage(),
      );
    }
  }

  Stream<AccountInfoState> _sendStatement(AccountInfoEventSendStatement event, AccountInfoState state) async* {
    yield const AccountInfoState(statementState: DataState.preload);
    try {
      final response = await accountInfoRepository.sendStatement(event.fileType, event.fromDate, event.toDate,
          event.accountNumber, event.fromAmount, event.toAmount, event.memo);
      yield AccountInfoState(baseResultModel: response.item, statementState: DataState.data);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AccountInfoState(statementState: DataState.error);
    }
  }

  Stream<AccountInfoState> _sendStatementOnline(
      AccountInfoEventSendStatementOnline event, AccountInfoState state) async* {
    yield const AccountInfoState(statementState: DataState.preload);
    try {
      final response = await accountInfoRepository.sendStatementOnline(
          event.fromDate, event.toDate, event.accountNumber, event.fromAmount, event.toAmount, event.memo);
      yield AccountInfoState(baseResultModel: response.item, statementState: DataState.data);
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const AccountInfoState(statementState: DataState.error);
    }
  }
}
