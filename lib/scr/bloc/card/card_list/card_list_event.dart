import 'package:b2b/scr/data/model/card/card_display.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';

class CardListEvent {}

class CardListGetDataEvent extends CardListEvent {}

class CardDebitChangeExpandStatusEvent extends CardListEvent {
  int index;
  CardDisplay cardData;

  CardDebitChangeExpandStatusEvent(
      {required this.cardData, required this.index});
}

class CardCreditChangeExpandStatusEvent extends CardListEvent {
  int index;
  CardDisplay cardData;

  CardCreditChangeExpandStatusEvent(
      {required this.cardData, required this.index});
}

class CardListClearDataEvent extends CardListEvent {}
