part of 'tax_bloc.dart';

class TaxEvent {}

class ClearTaxState extends TaxEvent {}

class TaxEventGetTaxOnline extends TaxEvent {}

class TaxEventGetListDebitAccount extends TaxEvent {}

class TaxEventChangeRootAccount extends TaxEvent {
  DebitAccountModel accountModel;

  TaxEventChangeRootAccount(this.accountModel);
}

class TaxEventChangeFeeAccount extends TaxEvent {
  DebitAccountModel accountModel;

  TaxEventChangeFeeAccount(this.accountModel);
}

class InitTaxEvent extends TaxEvent {}

class ConfirmTaxEvent extends TaxEvent {}
