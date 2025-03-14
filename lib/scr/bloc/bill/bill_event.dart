part of 'bill_bloc.dart';

class BillEvent {}

class GetBillServiceEvent extends BillEvent {}

class GetBillProviderEvent extends BillEvent {
  String code;

  GetBillProviderEvent(this.code);
}

class GetListBillSavedEvent extends BillEvent{
  String providerCode;

  GetListBillSavedEvent(this.providerCode);
}

class BillProviderInitEvent extends BillEvent{
  String serviceCode;

  BillProviderInitEvent(this.serviceCode);
}
