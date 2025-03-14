import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:equatable/equatable.dart';

class CardHistoryState extends Equatable {
  final DataState? dataState;
  final String? errorMessage;
  final StatementOnlineData? historyData;
  final CardHistoryCardListState? cardList;

  const CardHistoryState({
    this.dataState,
    this.errorMessage,
    this.historyData,
    this.cardList,
  });

  CardHistoryState copyWith({
    DataState? dataState,
    String? errorMessage,
    StatementOnlineData? historyData,
    CardHistoryCardListState? cardList,
  }) {
    return CardHistoryState(
      dataState: dataState ?? this.dataState,
      errorMessage: errorMessage,
      historyData: historyData ?? this.historyData,
      cardList: cardList ?? this.cardList,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        errorMessage,
        historyData,
        cardList,
      ];
}

class CardHistoryCardListState extends Equatable {
  final DataState? dataState;
  final String? errorMessage;
  final List<CardModel>? cards;
  final List<BenefitContract>? contracts;

  const CardHistoryCardListState({
    this.dataState,
    this.errorMessage,
    this.cards,
    this.contracts,
  });

  CardHistoryCardListState copyWith({
    DataState? dataState,
    String? errorMessage,
    List<CardModel>? cards,
    List<BenefitContract>? contracts,
  }) {
    return CardHistoryCardListState(
      dataState: dataState ?? this.dataState,
      errorMessage: errorMessage,
      cards: cards ?? this.cards,
      contracts: contracts ?? this.contracts,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        errorMessage,
        cards,
        contracts,
      ];
}
