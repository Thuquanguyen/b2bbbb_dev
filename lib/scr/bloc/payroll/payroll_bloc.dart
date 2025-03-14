import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/payroll/payroll_events.dart';
import 'package:b2b/scr/bloc/payroll/payroll_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/payroll_ben_model.dart';
import 'package:b2b/scr/data/repository/payroll_repository.dart';
import 'package:bloc/bloc.dart';

class PayrollBloc extends Bloc<PayrollEvents, PayrollState> {
  final PayrollRepository payrollRepository;

  PayrollBloc(this.payrollRepository)
      : super(
          const PayrollState(
            benListState: PayrollBenListState(),
          ),
        );

  @override
  Stream<PayrollState> mapEventToState(PayrollEvents event) async* {
    switch (event.runtimeType) {
      case PayrollGetBenListEvent:
        yield* getBenList(event as PayrollGetBenListEvent);
        break;
    }
  }

  Stream<PayrollState> getBenList(PayrollGetBenListEvent event) async* {
    PayrollBenListFilterRequest? filterRequest = event.filterRequest ?? state.benListState?.filterRequest;
    yield state.copyWith(
      benListState: PayrollBenListState(
        dataState: DataState.preload,
        filterRequest: filterRequest,
      ),
    );

    try {
      var response = await payrollRepository.getBenList(filterRequest);

      if (response.result?.isSuccess() == true) {
        final ListResponse<PayrollBenModel> listAccount =
        ListResponse<PayrollBenModel>(
          response.data,
              (item) => PayrollBenModel.fromJson(item),
        );
        List<PayrollBenModel> result = listAccount.items;

        yield state.copyWith(
          benListState: state.benListState?.copyWith(
            dataState: DataState.data,
            list: result,
          ),
        );
      } else {
        yield state.copyWith(
          benListState: state.benListState?.copyWith(
            dataState: DataState.error,
            errorMessage: response.result?.getMessage(
                defaultValue: AppTranslate.i18n.errorNoReasonStr.localized),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        benListState: state.benListState?.copyWith(
          dataState: DataState.error,
          errorMessage: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }
}
