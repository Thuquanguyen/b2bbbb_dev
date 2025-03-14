import 'package:b2b/scr/data/model/card/card_display.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';

class CardListResponse {
  final List<CardModel>? creditCards;
  final List<CardModel>? debitCards;

  CardListResponse({this.creditCards, this.debitCards});

  static CardListResponse fromJson(Map<String, dynamic> json) {


    return CardListResponse(
      creditCards: (json['credit_card'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))

          .toList(),
      debitCards: (json['debit_card'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
