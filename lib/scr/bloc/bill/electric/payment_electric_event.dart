part of 'payment_electric_bloc.dart';

abstract class PaymentElectricEvent {}

class PaymentElectricInitEvent extends PaymentElectricEvent {}

class GetListDebitEvent extends PaymentElectricEvent {}

class ChangeDebitAccountEvent extends PaymentElectricEvent {
  DebitAccountModel debitAccountModel;

  ChangeDebitAccountEvent(this.debitAccountModel);
}

class GetBillInfo extends PaymentElectricEvent {
  String serviceCode;
  String providerCode;
  String customerCode;

  GetBillInfo(this.serviceCode, this.providerCode, this.customerCode);

  Map<String, dynamic> toJson() {
    return {
      'service_code': serviceCode,
      'provider_code': providerCode,
      'customer_code': customerCode
    };
  }
}

class BillInitEvent extends PaymentElectricEvent {
  BillInitRequestData initRequestData;

  BillInitEvent(this.initRequestData);
}

class ClearBillInfoEvent extends PaymentElectricEvent {}

class ConfirmBillEvent extends PaymentElectricEvent{}
