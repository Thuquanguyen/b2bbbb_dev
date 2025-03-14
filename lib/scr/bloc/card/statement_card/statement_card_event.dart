import 'package:b2b/scr/data/model/card/card_model.dart';

class StatementCardEvent {}

class StatementCardInitEvent extends StatementCardEvent {}

class StatementChangeSelectedCardEvent extends StatementCardEvent {
  CardModel cardModel;

  StatementChangeSelectedCardEvent(this.cardModel);
}

class StatementGetCardContractListEvent extends StatementCardEvent {}

class StatementGetPeriodMonthEvent extends StatementCardEvent {}
class StatementChangePeriodEvent extends StatementCardEvent {
  String value;

  StatementChangePeriodEvent(this.value);
}

class StatementExportFileEvent extends StatementCardEvent{

}
