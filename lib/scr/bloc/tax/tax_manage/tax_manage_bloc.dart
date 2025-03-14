import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_events.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/repository/tax_repository.dart';
import 'package:bloc/bloc.dart';

class TaxManageBloc extends Bloc<TaxManageEvent, TaxManageState> {
  TaxManageBloc(this.repository)
      : super(
          TaxManageState(
            initState: TaxManageInitState(),
            confirmState: TaxManageConfirmState(),
            listState: TaxManageListState(),
          ),
        ) {
    on<TaxManageGetListEvent>(_onTaxManageGetListEvent);
    on<TaxManageInitEvent>(_onTaxManageInitEvent);
    on<TaxManageConfirmEvent>(_onTaxManageConfirmEvent);
  }

  TaxRepository repository;

  void _onTaxManageGetListEvent(TaxManageGetListEvent event, Emitter<TaxManageState> emit) async {
    emit(
      state.copyWith(
        listState: state.listState?.copyWith(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      final response = await repository.getTaxOnlineList();
      if (response.result?.isSuccess() == true) {
        emit(
          state.copyWith(
            listState: state.listState?.copyWith(
              dataState: DataState.data,
              list: response.toArrayModel((json) => TaxOnline.fromJson(json)),
            ),
          ),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      emit(
        state.copyWith(
          listState: state.listState?.copyWith(
              dataState: DataState.error,
              errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized),
        ),
      );
    }
  }

  void _onTaxManageInitEvent(TaxManageInitEvent event, Emitter<TaxManageState> emit) async {
    emit(
      state.copyWith(
        initState: state.initState?.copyWith(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      final response = await repository.initTaxOnlineManage(transCode: event.transCode);
      if (response.result?.isSuccess() == true) {
        emit(
          state.copyWith(
            initState: state.initState?.copyWith(
              dataState: DataState.data,
              data: response.toModel((json) => TaxOnline.fromJson(json)),
            ),
          ),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      emit(
        state.copyWith(
          initState: state.initState?.copyWith(
              dataState: DataState.error,
              errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized),
        ),
      );
    }
  }

  void _onTaxManageConfirmEvent(TaxManageConfirmEvent event, Emitter<TaxManageState> emit) async {
    emit(
      state.copyWith(
        confirmState: state.confirmState?.copyWith(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      final response = await repository.confirmTaxOnlineManage(
        transCode: event.transCode,
        secureTrans: event.secureTrans,
        commitType: event.actionType,
      );
      if (response.result?.isSuccess() == true) {
        emit(
          state.copyWith(
            confirmState: state.confirmState?.copyWith(
              dataState: DataState.data,
              actionType: event.actionType,
              rejectReason: event.rejectReason,
              data: response.toModel((json) => TransactionManageConfirmResponse.fromJson(json)),
              successMessage: response.result?.getMessage(),
            ),
          ),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      emit(
        state.copyWith(
          confirmState: state.confirmState?.copyWith(
              dataState: DataState.error,
              errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized),
        ),
      );
    }
  }
}
