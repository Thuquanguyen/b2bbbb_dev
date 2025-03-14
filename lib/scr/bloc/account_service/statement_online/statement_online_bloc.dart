import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/custom_exception.dart';
import 'package:b2b/scr/data/model/as_request_model.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/data/repository/account_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'statement_online_event.dart';

part 'statement_online_state.dart';

class StatementOnlineBloc extends Bloc<StatementOnlineEvent, StatementOnlineState> {
  StatementOnlineBloc({required this.accountInfoRepository}) : super(const StatementOnlineState());

  final AccountInfoRepositoryImpl accountInfoRepository;

  @override
  Stream<StatementOnlineState> mapEventToState(StatementOnlineEvent event) async* {
    if (event is StatementOnlineEventGetTransactionHistory) {
      yield* _sentReceiveStatementOnline(event, state);
    }
  }

  Stream<StatementOnlineState> _sentReceiveStatementOnline(
      StatementOnlineEventGetTransactionHistory event, StatementOnlineState state) async* {
    // yield const StatementOnlineState(statementState: DataState.preload);
    yield state.copyWith(statementState: DataState.preload);
    try {
      final response = await accountInfoRepository.sendStatementOnline(
        event.fromDate,
        event.toDate,
        event.accountNumber,
        event.fromAmount,
        event.toAmount,
        event.memo,
      );
      yield state.copyWith(statementOnlineResponse: response.item, statementState: DataState.data);
    } on Object catch (e) {
      // print('Catch error and return fail here ${e.toString()}');
      yield state.copyWith(statementState: DataState.error,isRequestTimeOut: e is FetchDataException);
    }
  }
}
