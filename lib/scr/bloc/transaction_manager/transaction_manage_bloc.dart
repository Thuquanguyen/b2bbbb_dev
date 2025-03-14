import 'package:b2b/commons.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/bill/bill_child_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/fx/fx_manage_child_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/payroll/payroll_child_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/saving/saving_child_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transfer/transfer_child_bloc.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/data/model/transaction_payroll_model.dart';
import 'package:b2b/scr/data/repository/payroll_repository.dart';
import 'package:b2b/scr/data/repository/saving_repository.dart';
import 'package:b2b/scr/data/repository/transaction_manager_repository.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:bloc/bloc.dart';
import 'transaction_manage_events.dart';
import 'transaction_manage_state.dart';

class TransuctionManageBloc extends Bloc<TransuctionManageEvent, TransuctionManageState> {
  TransactionManagerRepository transManangerRepository;
  SavingRepository savingRepo;
  PayrollRepository payrollRepo;

  TransuctionManageBloc({
    required this.transManangerRepository,
    required this.savingRepo,
    required this.payrollRepo,
  }) : super(const TransuctionManageState());

  @override
  Stream<TransuctionManageState> mapEventToState(TransuctionManageEvent event) async* {
    switch (event.runtimeType) {
      case TransuctionManageStartEvent:
        // EH = event handler
        // yield* _startedEH(event as TransuctionManageStartEvent);
        break;
      case TransuctionManageRefreshEvent:
        // EH = event handler
        yield* _refreshEH();
        break;
      case TransuctionManageClearEvent:
        yield const TransuctionManageState();
        break;
      case TransuctionManageUpdateFilterEvent:
        yield* _updateFilterEH(event as TransuctionManageUpdateFilterEvent);
        break;
      case TransuctionManageEnableSelectEvent:
        yield state.copyWith(
          isSelecting: true,
        );
        break;
      case TransuctionManageSelectAllEvent:
        yield* _selectAllEH();
        break;
      case TransuctionManageSelectSingleEvent:
        yield* _selectSingleEH(event as TransuctionManageSelectSingleEvent);
        break;
      case TransuctionManageClearSelectEvent:
        yield* _clearSelectEH();
        break;
    }
  }

  // Stream<TransuctionManageState> _startedEH(
  //     TransuctionManageStartEvent event) async* {
  //   if (event.category?.key == TransactionFilterCategory.payrollCat.key) {
  //     yield TransuctionManageState(
  //       shouldShowFilterBtn: true,
  //       shouldShowSelectAllBtn: false,
  //       selectedCategory: event.category?.key,
  //     );
  //     // yield* PayrollChildBloc().loadServiceList(this);
  //     yield* PayrollChildBloc().loadList(this);
  //   } else if (event.category?.key == TransactionFilterCategory.savingCat.key) {
  //     yield TransuctionManageState(
  //       shouldShowFilterBtn: true,
  //       shouldShowSelectAllBtn: false,
  //       selectedCategory: event.category?.key,
  //     );
  //     yield* SavingChildBloc().loadServiceList(this);
  //     yield* SavingChildBloc().loadList(this);
  //   } else {
  //     yield TransuctionManageState(
  //       shouldShowFilterBtn: true,
  //       shouldShowSelectAllBtn: true,
  //       selectedCategory: event.category?.key,
  //     );
  //     yield* TransferChildBloc().loadServiceList(this);
  //     yield* TransferChildBloc().loadList(this);
  //   }
  // }

  Stream<TransuctionManageState> _refreshEH() async* {
    yield* _reloadList(null, null);
  }

  Stream<TransuctionManageState> _updateFilterEH(TransuctionManageUpdateFilterEvent event) async* {
    yield* _reloadList(event.category?.key, event.filterRequest);
  }

  Stream<TransuctionManageState> _reloadList(String? catKey, TransactionFilterRequest? filterRequest) async* {
    String? key = catKey ?? state.selectedCategory;
    if (key == TransactionManage.payrollCat.key) {
      yield state.copyWith(
        isSelecting: false,
        shouldShowFilterBtn: true,
        shouldShowSelectAllBtn: false,
        currentFilterRequest: filterRequest,
        filterServiceTypes: [],
        selectedCategory: key,
        listState: TransuctionManageListState<TransactionPayrollModel>(
          dataState: DataState.preload,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      // yield* PayrollChildBloc().loadServiceList(this);
      yield* PayrollChildBloc().loadList(this);
    } else if (key == TransactionManage.savingCat.key) {
      yield state.copyWith(
        isSelecting: false,
        shouldShowFilterBtn: true,
        shouldShowSelectAllBtn: false,
        currentFilterRequest: filterRequest,
        selectedCategory: key,
        listState: TransuctionManageListState<TransactionSavingModel>(
          dataState: DataState.preload,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      yield* SavingChildBloc().loadServiceList(this);
      yield* SavingChildBloc().loadList(this);
    } else if (key == TransactionManage.fxCat.key) {
      yield state.copyWith(
        isSelecting: false,
        shouldShowFilterBtn: true,
        shouldShowSelectAllBtn: false,
        currentFilterRequest: filterRequest,
        selectedCategory: key,
        listState: TransuctionManageListState<TransactionMainModel>(
          dataState: DataState.preload,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      yield* FxManageChildBloc().loadServiceList(this);
      yield* FxManageChildBloc().loadList(this);
    } else if (key == TransactionManage.billCat.key) {
      yield state.copyWith(
        isSelecting: false,
        shouldShowFilterBtn: true,
        shouldShowSelectAllBtn: false,
        currentFilterRequest: filterRequest,
        selectedCategory: key,
        listState: TransuctionManageListState<TransactionMainModel>(
          dataState: DataState.preload,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      yield* BillManageChildBloc().loadServiceList(this);
      yield* BillManageChildBloc().loadList(this);
    } else {
      yield state.copyWith(
        isSelecting: false,
        shouldShowFilterBtn: true,
        shouldShowSelectAllBtn: true,
        currentFilterRequest: filterRequest,
        selectedCategory: key,
        listState: TransuctionManageListState<TransactionMainModel>(
          dataState: DataState.preload,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      yield* TransferChildBloc().loadServiceList(this);
      yield* TransferChildBloc().loadList(this);
    }
  }

  Stream<TransuctionManageState> _selectSingleEH(TransuctionManageSelectSingleEvent event) async* {
    List<String> selected = [...?state.listState?.selected];
    if (selected.contains(event.transCode)) {
      selected.remove(event.transCode);
    } else {
      selected.add(event.transCode);
    }

    yield state.copyWith(
      isSelecting: true,
      listState: state.listState?.copyWith(
        selected: selected,
      ),
    );
  }

  bool get isAllSelected {
    int transCount = 0;
    state.listState?.transactions?.forEach((tg) {
      transCount += tg.list.length;
    });

    return transCount == state.listState?.selected.length;
  }

  Stream<TransuctionManageState> _selectAllEH() async* {
    List<String> selected = [];
    state.listState?.transactions?.forEach((tg) {
      for (var t in tg.list) {
        if (t.transCode != null) {
          selected.add(t.transCode!);
        }
      }
    });

    yield state.copyWith(
      listState: state.listState?.copyWith(
        selected: selected,
      ),
    );
  }

  Stream<TransuctionManageState> _clearSelectEH() async* {
    yield state.copyWith(
      isSelecting: false,
      listState: state.listState?.copyWith(
        selected: [],
      ),
    );
  }
}
