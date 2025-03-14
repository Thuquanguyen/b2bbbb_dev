part of 'current_deposits_bloc.dart';

class CurrentDepositsEvents {}

class CurrentDepositsGetListEvent extends CurrentDepositsEvents {
  final TransactionFilterRequest? filterRequest;

  CurrentDepositsGetListEvent({
    this.filterRequest,
  });
}

class CurrentDepositsClearFilterEvent extends CurrentDepositsEvents {}

class CurrentDepositsGetDetailEvent extends CurrentDepositsEvents {
  final String? accountNo;

  CurrentDepositsGetDetailEvent({
    this.accountNo,
  });
}

class CurrentDepositsInitSettlementEvent extends CurrentDepositsEvents {
  final String? accountNo;
  final String? nominatedAcc;

  CurrentDepositsInitSettlementEvent({
    this.accountNo,
    this.nominatedAcc,
  });
}

class CurrentDepositsConfirmSettlementEvent extends CurrentDepositsEvents {
  final String? transCode;
  final String? secureTrans;

  CurrentDepositsConfirmSettlementEvent({
    this.transCode,
    this.secureTrans,
  });
}

class CurrentDepositsCommitSettlementEvent extends CurrentDepositsEvents {
  final SavingAccountModel? savingAccount;

  CurrentDepositsCommitSettlementEvent({
    this.savingAccount,
  });
}

class CurrentDepositsGetListDebitAccountEvent extends CurrentDepositsEvents {
  final String? secureId;
  final String? productId;

  CurrentDepositsGetListDebitAccountEvent({
    this.secureId,
    this.productId,
  });
}

class CurrentDepositsChangeSettlementAccEvent extends CurrentDepositsEvents {}

class CurrentDepositsFinalSettlementEvent extends CurrentDepositsEvents {}
