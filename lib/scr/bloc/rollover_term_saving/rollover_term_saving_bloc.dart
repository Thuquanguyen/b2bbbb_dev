import 'dart:async';

import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/saving/rollover_term_saving_model.dart';
import 'package:b2b/scr/data/repository/rollover_term_saving_repository.dart';
import 'package:b2b/scr/presentation/screens/saving/interest_rate_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../data_state.dart';

part 'rollover_term_saving_event.dart';

part 'rollover_term_saving_state.dart';

class RolloverTermSavingBloc extends Bloc<RolloverTermSavingEvent, RolloverTermSavingState> {
  RolloverTermSavingBloc({required this.savingPeriodRepositoryImpl}) : super(RolloverTermSavingState());

  RolloverTermSavingRepositoryImpl savingPeriodRepositoryImpl;

  @override
  Stream<RolloverTermSavingState> mapEventToState(
    RolloverTermSavingEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetSavingPeriodEvent:
        yield* _mapGetSavingPeriodEventToState(event as GetSavingPeriodEvent);
        break;
      case ChooseTermSavingEvent:
        yield* _mapChooseTermSavingEventToState(event as ChooseTermSavingEvent);
        break;
      case ChooseTermSavingPeriodicallyEvent:
        yield* _mapChooseTermSavingPeriodicallyEventToState(event as ChooseTermSavingPeriodicallyEvent);
        break;
      default:
        break;
    }
  }

  Stream<RolloverTermSavingState> _mapChooseTermSavingPeriodicallyEventToState(
      ChooseTermSavingPeriodicallyEvent event) async* {
    if (state.termSavingPeriodically == event.termSavingPeriodically) return;
    yield state.copyWith(
      termSavingPeriodically: event.termSavingPeriodically,
      listDisplayData: InterestRateManager().getDisplayPeriodically(
          state.rolloverTermSavingModel, event.termSavingPeriodically ?? TermSavingPeriodically.monthly),
    );
  }

  Stream<RolloverTermSavingState> _mapChooseTermSavingEventToState(ChooseTermSavingEvent event) async* {
    if (state.termSaving == event.termSaving) return;

    List<InterestRateDisplayModel> listModel = [];

    switch (event.termSaving) {
      case TermSaving.prepaid:
        listModel.addAll(state.listPrepaid ?? []);
        break;
      case TermSaving.endOfPeriod:
        listModel.addAll(state.listEndOfPeriod ?? []);
        break;
      case TermSaving.periodically:
        TermSavingPeriodically termSavingPeriodically = state.termSavingPeriodically ?? TermSavingPeriodically.monthly;
        listModel.addAll(
            InterestRateManager().getDisplayPeriodically(state.rolloverTermSavingModel, termSavingPeriodically));
        break;
      default:
    }
    yield state.copyWith(
      termSaving: event.termSaving,
      termSavingPeriodically: event.termSavingPeriodically,
      listDisplayData: listModel,
    );
  }

  Stream<RolloverTermSavingState> _mapGetSavingPeriodEventToState(GetSavingPeriodEvent event) async* {
    try {
      yield state.copyWith(rolloverTermSavingDataState: DataState.preload);
      final response = await savingPeriodRepositoryImpl.getRolloverTermSaving();
      if (response.result!.isSuccess()) {
        final rolloverTermSavingResponse =
            SingleResponse(response.data, (item) => RolloverTermSavingModel.fromJson(item));
        yield state.copyWith(
          rolloverTermSavingModel: rolloverTermSavingResponse.item,
          rolloverTermSavingDataState: DataState.data,
          savingPeriodModel: rolloverTermSavingResponse.item,
          chosenTermSaving: rolloverTermSavingResponse.item.endOfPeriod,
          listDisplayData: InterestRateManager().getDisplayEndOfPreviousList(rolloverTermSavingResponse.item),
          listPrepaid: InterestRateManager().getDisplayPrepaid(rolloverTermSavingResponse.item),
          listEndOfPeriod: InterestRateManager().getDisplayEndOfPreviousList(rolloverTermSavingResponse.item),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        rolloverTermSavingDataState: DataState.error,
        errorMessage: e is BaseResultModel ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }
}
