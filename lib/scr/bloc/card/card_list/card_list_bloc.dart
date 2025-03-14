import 'dart:async';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/card/card_list_response.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/card/card_display.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';

import '../../data_state.dart';
import 'card_list_event.dart';
import 'card_list_state.dart';

class CardListBloc extends Bloc<CardListEvent, CardListState> {
  CardListBloc(this.repository) : super(CardListState());

  final CardRepository repository;

  @override
  Stream<CardListState> mapEventToState(CardListEvent event) async* {
    switch (event.runtimeType) {
      case CardListGetDataEvent:
        yield* _mapToCardListGetDataEvent();
        break;
      case CardDebitChangeExpandStatusEvent:
        yield* _mapToCardDebitChangeExpandStatusEvent(event as CardDebitChangeExpandStatusEvent);
        break;
      case CardCreditChangeExpandStatusEvent:
        yield* _mapToCardCreditChangeExpandStatusEvent(event as CardCreditChangeExpandStatusEvent);
        break;
      default:
        break;
    }
  }

  Stream<CardListState> _mapToCardListGetDataEvent() async* {
    yield state.copyWith(
      cardListDataState: DataState.preload,
    );
    try {
      final response = await repository.getCardList();
      if (response.item.result?.isSuccess() == true) {
        CardListResponse? cardListResponse = response.item.toModel((json) => CardListResponse.fromJson(json));

        Logger.debug('credit card list SIZE ${cardListResponse?.creditCards?.length}');
        Logger.debug('Debit card list SIZE ${cardListResponse?.debitCards?.length}');

        List<CardDisplay> creditCards = cardListResponse?.creditCards?.map((e) {
              CardModel _e = e;
              _e.type = CardType.CREDIT;
              _e.cardSub?.forEach((c) {
                c.type = CardType.CREDIT;
              });
              return CardDisplay(cardModel: _e);
            }).toList() ??
            [];

        List<CardDisplay> debitCards = cardListResponse?.debitCards?.map((e) {
              CardModel _e = e;
              _e.type = CardType.DEBIT;
              _e.cardSub?.forEach((c) {
                c.type = CardType.DEBIT;
              });
              return CardDisplay(cardModel: e);
            }).toList() ??
            [];
        yield state.copyWith(cardListDataState: DataState.data, debitCards: debitCards, creditCards: creditCards);
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        cardListDataState: DataState.error,
        errorMessage: (e is BaseResultModel) ? e.getMessage() : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<CardListState> _mapToCardDebitChangeExpandStatusEvent(CardDebitChangeExpandStatusEvent event) async* {
    CardDisplay cardData = event.cardData;

    List<CardDisplay> cardModelList = [];
    cardModelList.addAll(state.debitCards ?? []);

    cardModelList[event.index] = cardData.reverseExpand();

    yield state.copyWith(
      debitCards: cardModelList,
      needUpdate: !(state.needUpdate ?? false),
    );
  }

  Stream<CardListState> _mapToCardCreditChangeExpandStatusEvent(CardCreditChangeExpandStatusEvent event) async* {
    CardDisplay cardData = event.cardData;

    List<CardDisplay> cardModelList = [];
    cardModelList.addAll(state.creditCards ?? []);

    cardModelList[event.index] = cardData.reverseExpand();

    yield state.copyWith(
      creditCards: cardModelList,
      needUpdate: !(state.needUpdate ?? false),
    );
  }
}
