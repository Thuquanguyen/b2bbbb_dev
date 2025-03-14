import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:equatable/equatable.dart';
import 'package:b2b/scr/data/model/card/card_display.dart';

class CardListState extends Equatable {
  List<CardDisplay>? creditCards; // Thẻ tín dụng
  List<CardDisplay>? debitCards; // Thẻ ghi nợ

  DataState? cardListDataState = DataState.init;

  bool? needUpdate;

  String? errorMessage;

  @override
  List<Object?> get props =>
      [creditCards, debitCards, cardListDataState, needUpdate, errorMessage];

  CardListState({this.creditCards,
    this.debitCards,
    this.cardListDataState,
    this.needUpdate, this.errorMessage});

  CardListState copyWith({List<CardDisplay>? creditCards,
    List<CardDisplay>? debitCards,
    DataState? cardListDataState,
    bool? needUpdate, String? errorMessage}) {
    return CardListState(
        creditCards: creditCards ?? this.creditCards,
        debitCards: debitCards ?? this.debitCards,
        cardListDataState: cardListDataState ?? this.cardListDataState,
        needUpdate: needUpdate ?? this.needUpdate,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
