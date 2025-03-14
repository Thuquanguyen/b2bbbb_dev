import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_state.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';

abstract class TransuctionManageChildBloc {
  Stream<TransuctionManageState> loadList(
      TransuctionManageBloc bloc,
  ) async* {}

  Stream<TransuctionManageState> loadServiceList(
      TransuctionManageBloc bloc,
      ) async* {}
}
