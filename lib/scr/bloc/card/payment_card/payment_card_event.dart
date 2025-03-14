import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/transfer/amount_info.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';

class PaymentCardEvent {}

class PaymentCardInitEvent extends PaymentCardEvent {}

class PaymentCardChangeStatusEvent extends PaymentCardEvent {
  bool isMinPay;
  bool isSelected;

  PaymentCardChangeStatusEvent(
      {required this.isMinPay, required this.isSelected});
}

class PaymentCardChangeDebitAccountEvent extends PaymentCardEvent {
  DebitAccountModel debitAccountModel;

  PaymentCardChangeDebitAccountEvent(this.debitAccountModel);
}

class GetCardContractListEvent extends PaymentCardEvent {
  CardModel? cardModel;

  GetCardContractListEvent(this.cardModel);
}

class ChangeSelectedCardEvent extends PaymentCardEvent {
  dynamic cardModel;

  ChangeSelectedCardEvent(this.cardModel);
}

class InitPaymentCardEvent extends PaymentCardEvent {
  final AmountInfo? amountInfo;
  final String? cardId;
  final DebitAccountModel? debitAccountModel;

  InitPaymentCardEvent({this.amountInfo, this.cardId, this.debitAccountModel});
}

class PaymentCardConfirmEvent extends PaymentCardEvent {}

class GetContractInfo extends PaymentCardEvent {
  String? contractId;

  GetContractInfo({this.contractId});
}
