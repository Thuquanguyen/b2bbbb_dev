import 'package:b2b/scr/data/model/card/card_model.dart';


class CardDisplay  {
  final bool isExpand;
  final CardModel? cardModel;

  CardDisplay({this.isExpand = true,this.cardModel});

  CardDisplay reverseExpand() {
    CardDisplay display = CardDisplay(isExpand: !(isExpand),cardModel: cardModel);
    return display;
  }
}
