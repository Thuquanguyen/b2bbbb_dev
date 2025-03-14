import 'package:b2b/scr/bloc/card/card_info/card_info_event.dart';
import 'package:b2b/scr/bloc/card/card_info/card_info_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:bloc/bloc.dart';

class CardInfoBloc extends Bloc<CardInfoEvents, CardInfoState> {
  CardInfoBloc(this.repository) : super(CardInfoState());
  CardRepository repository;

  @override
  Stream<CardInfoState> mapEventToState(CardInfoEvents event) async* {
    switch (event.runtimeType) {
      case GetCardInfoEvent:
        yield* getCardInfo(event as GetCardInfoEvent);
    }
  }

  Stream<CardInfoState> getCardInfo(GetCardInfoEvent e) async* {
    yield state.copyWith(
      cardInfoDataState: DataState.preload,
    );

    try {
      final response = await repository.getCardInfo(e.contractId);
      if (response.item.result?.isSuccess() == true) {
        CardModel? cardInfo = response.item.toModel((json) => CardModel.fromJson(json));
        yield state.copyWith(
          cardInfoDataState: DataState.data,
          cardInfo: cardInfo,
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        cardInfoDataState: DataState.error,
        errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.errorNoReasonStr.localized,
      );
    }
  }
}
