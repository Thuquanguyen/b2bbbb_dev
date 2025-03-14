part of 'transfer_rate_bloc.dart';

class TransferRateEvent {}

class GetRateEvent extends TransferRateEvent {
  String fcy;
  String amountCcy;
  double amount;
  int? typeCode;

  GetRateEvent(
      {required this.fcy,
      required this.amountCcy,
      required this.amount,
      this.typeCode});
}

class ClearTransferRateStateEvent extends TransferRateEvent {}
