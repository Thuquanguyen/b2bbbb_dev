import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/transfer/transfer_rate.dart';
import 'package:b2b/scr/data/repository/transfer_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../utilities/logger.dart';
import '../../../core/language/app_translate.dart';
import '../../../data/model/base_result_model.dart';

part 'transfer_rate_event.dart';

part 'transfer_rate_state.dart';

class TransferRateBloc extends Bloc<TransferRateEvent, TransferRateState> {
  TransferRepositoryImpl repository;

  TransferRateBloc(this.repository) : super(TransferRateState());

  @override
  Stream<TransferRateState> mapEventToState(TransferRateEvent event) async* {
    switch (event.runtimeType) {
      case GetRateEvent:
        yield* _getTransferRate(event as GetRateEvent);
        break;
      case ClearTransferRateStateEvent:
        yield TransferRateState();
        break;
      default:
        break;
    }
  }

  Stream<TransferRateState> _getTransferRate(GetRateEvent event) async* {
    yield state.copyWith(getRateDataState: DataState.preload);
    try {
      var response = await repository.getTransferRate(
          fcy: event.fcy,
          amountCcy: event.amountCcy,
          amount: event.amount,
          transferTypeCode: event.typeCode);
      if (response.result?.isSuccess() == true) {
        var rate = TransferRate.fromJson(response.data);

        yield state.copyWith(
            getRateDataState: DataState.data, transferRate: rate);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
          getRateDataState: DataState.error,
          errMsg: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }
}
