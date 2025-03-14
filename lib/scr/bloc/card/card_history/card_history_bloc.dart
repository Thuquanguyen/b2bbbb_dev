import 'package:b2b/scr/bloc/card/card_history/card_history_events.dart';
import 'package:b2b/scr/bloc/card/card_history/card_history_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/data/model/card/card_list_response.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:bloc/bloc.dart';

class CardHistoryBloc extends Bloc<CardHistoryEvents, CardHistoryState> {
  CardHistoryBloc(this.repository)
      : super(
          const CardHistoryState(
            cardList: CardHistoryCardListState(),
          ),
        ) {
    on<GetCardHistoryEvent>(getCardHistory);
    on<GetCardListEvent>(getCardList);
    on<ClearGetCardHistoryEvent>((event, emit) {
      emit(const CardHistoryState(
        cardList: CardHistoryCardListState(),
      ));
    });
  }

  final CardRepository repository;

  void getCardHistory(GetCardHistoryEvent e, Emitter emit) async {
    emit(state.copyWith(dataState: DataState.preload));

    try {
      final response = await repository.getCardHistory(e.request, e.cancelToken);
      if (response.result?.isSuccess() == true) {
        final StatementOnlineData? statementData = response.toModel((json) => StatementOnlineData.fromJson(json));

        emit(state.copyWith(
          dataState: DataState.data,
          errorMessage: null,
          historyData: statementData,
        ));
      } else {
        emit(state.copyWith(
          dataState: DataState.error,
          errorMessage: response.result?.getMessage(
            defaultValue: AppTranslate.i18n.errorNoReasonStr.localized,
          ),
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        dataState: DataState.error,
        errorMessage: AppTranslate.i18n.errorNoReasonStr.localized,
      ));
    }
  }

  void getCardList(GetCardListEvent event, Emitter emit) async {
    emit(state.copyWith(
      cardList: state.cardList?.copyWith(
        dataState: DataState.preload,
      ),
    ));

    try {
      final response = await repository.getCardList();
      if (response.item.data != null) {
        CardListResponse? cardListResponse = response.item.toModel((json) => CardListResponse.fromJson(json));

        List<CardModel> cardList = [];
        cardList.addAll(cardListResponse?.debitCards ?? []);
        cardList.addAll(cardListResponse?.creditCards ?? []);

        emit(state.copyWith(
          cardList: state.cardList?.copyWith(
            dataState: DataState.data,
            cards: cardList,
          ),
        ));
      } else {
        emit(state.copyWith(
          cardList: state.cardList?.copyWith(
            dataState: DataState.error,
          ),
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        cardList: state.cardList?.copyWith(
          dataState: DataState.error,
          errorMessage: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      ));
    }
  }
}
