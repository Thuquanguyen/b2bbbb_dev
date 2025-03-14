part of 'open_online_deposits_bloc.dart';

@immutable
abstract class OpenOnlineDepositsEvent {}

class OpenDepositsInitEvent extends OpenOnlineDepositsEvent {}

class ClearDepositsStateEvent extends OpenOnlineDepositsEvent {}

class GetRollOverTermListEvent extends OpenOnlineDepositsEvent {
  double amount;

  GetRollOverTermListEvent(this.amount);
}

class ChangeRolloverTermEvent extends OpenOnlineDepositsEvent {
  RolloverTerm rolloverTerm;
  double amount;

  ChangeRolloverTermEvent(this.rolloverTerm, this.amount);
}

class ClearRolloverTermRateEvent extends OpenOnlineDepositsEvent {}

class ClearInputState extends OpenOnlineDepositsEvent {}

class ChangeOnlineDepositsProduct extends OpenOnlineDepositsEvent {
  final SavingDepositsProductResponse currentDepositProduct;

  ChangeOnlineDepositsProduct(
    this.currentDepositProduct,
  );
}

class ChangeOnlineDepositsType extends OpenOnlineDepositsEvent {
  final DepositsType depositsType;

  ChangeOnlineDepositsType(
    this.depositsType,
  );
}

class ChangeSavingReceiveMethod extends OpenOnlineDepositsEvent {
  final SavingReceiveMethod savingReceiveMethod;

  ChangeSavingReceiveMethod(
    this.savingReceiveMethod,
  );
}

class ChangeDebitAccountEvent extends OpenOnlineDepositsEvent {
  final DebitAccountModel debitAccountModel;
  final bool isRootAccount;

  ChangeDebitAccountEvent(
      {required this.debitAccountModel, required this.isRootAccount});
}

class GetSavingDepositsProductEvent extends OpenOnlineDepositsEvent {
  GetSavingDepositsProductEvent();
}

// Thay đổi phương thức nhận lãi
class ChangeSettElementEvent extends OpenOnlineDepositsEvent {
  Settelment settelment;

  ChangeSettElementEvent(this.settelment);
}

class InitDepositsEvent extends OpenOnlineDepositsEvent {
  SavingInitRequest initRequest;

  InitDepositsEvent(this.initRequest);
}

class ConfirmOpenDepositsEvent extends OpenOnlineDepositsEvent {
  InitDepositsResult initDepositsResult;

  ConfirmOpenDepositsEvent(this.initDepositsResult);
}

class ClearDepositInitDataState extends OpenOnlineDepositsEvent {
  ClearDepositInitDataState();
}
