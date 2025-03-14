part of 'transfer_bloc.dart';

@immutable
abstract class TransferEvent {}

class ClearTransferStateEvent extends TransferEvent {}

class GetBenListEvent extends TransferEvent {
  GetBenListEvent(this.transferType);

  final TransferType transferType;
}

class GetListDebitAccountEvent extends TransferEvent {
  GetListDebitAccountEvent(this.transferType);

  final TransferType transferType;
}

class UpdateListBranchEvent extends TransferEvent {
  UpdateListBranchEvent();
}

class Transfer247InitEvent extends TransferEvent {
  Transfer247InitEvent();
}

class ChangeTransfer247TypeEvent extends TransferEvent {
  final TransferType transferType;

  ChangeTransfer247TypeEvent(this.transferType);
}

class Transfer247ChangeAccountEvent extends TransferEvent {
  final String accountNumber;

  Transfer247ChangeAccountEvent(this.accountNumber);
}

class GetBankListEvent extends TransferEvent {}

class GetBankListResultEvent extends TransferEvent {
  final BenBankModel? benBank;

  GetBankListResultEvent({this.benBank});
}

class UpdateTransfer247BankEvent extends TransferEvent {
  final BenBankModel? benBank;

  UpdateTransfer247BankEvent({this.benBank});
}

class ClearAccountErrorMessage extends TransferEvent {
  ClearAccountErrorMessage();
}

class UpdateInterbankSaveBenEvent extends TransferEvent {
  final SaveBen? saveBen;

  UpdateInterbankSaveBenEvent({this.saveBen});
}

class Change247FeeAccountEvent extends TransferEvent {
  final DebitAccountModel? debitAccountModel;

  Change247FeeAccountEvent({this.debitAccountModel});
}

class ChangeTransferInterbankTypeEvent extends TransferEvent {
  final TransferType transferType;

  ChangeTransferInterbankTypeEvent(this.transferType);
}

class UpdateTransferInterbankEvent extends TransferEvent {
  final BenBankModel? benBank;
  final String? accountNumber;

  UpdateTransferInterbankEvent({this.benBank, this.accountNumber});
}

class ChangeInterbankLocationEvent extends TransferEvent {
  final CityModel? cityModel;

  ChangeInterbankLocationEvent({this.cityModel});
}

class ChangeInterbankBranchEvent extends TransferEvent {
  final BranchModel? branchModel;

  ChangeInterbankBranchEvent({this.branchModel});
}

class GetBenListInterBankEvent extends TransferEvent {
  int transferTypeOfCode;

  GetBenListInterBankEvent({this.transferTypeOfCode = -1});
}

class ChangeInterbankFeeTypeEvent extends TransferEvent {
  final BaseItemModel? baseItemModel;

  ChangeInterbankFeeTypeEvent({this.baseItemModel});
}

class ChangeInterbankBeneficiaryNameEvent extends TransferEvent {
  final String? beneficiaryName;

  ChangeInterbankBeneficiaryNameEvent({this.beneficiaryName});
}

class ChangeInterbankAccountNumberEvent extends TransferEvent {
  final String? accountNumber;

  ChangeInterbankAccountNumberEvent({this.accountNumber});
}

class ChangeInterbankFeeAccountEvent extends TransferEvent {
  final DebitAccountModel? debitAccountModel;

  ChangeInterbankFeeAccountEvent({this.debitAccountModel});
}

class GetDebitAccountDetailEvent extends TransferEvent {
  GetDebitAccountDetailEvent(this.transferType);

  final TransferType transferType;
}

class ConfirmTransferEvent extends TransferEvent {
  ConfirmTransferEvent();
}

class SearchBranchListInterbankEvent extends TransferEvent {
  final String bankCode;
  final String cityCode;

  SearchBranchListInterbankEvent({this.bankCode = '', this.cityCode = ''});
}

class GetBenAccountDetailEvent extends TransferEvent {
  GetBenAccountDetailEvent(this.benAccount,
      {this.benBank,
      this.isAccountBenFromListSaved = false,
      this.oldAliasName = ''});

  final String benAccount;

  final String? benBank;

  final bool isAccountBenFromListSaved;
  final String? oldAliasName;
}

// class UpdateBenAccountFromBenListSavedEvent extends TransferEvent {
//   UpdateBenAccountFromBenListSavedEvent(this.beneficiarySavedModel);

//   final BeneficiarySavedModel beneficiarySavedModel;
// }

// ignore: must_be_immutable
class InitTransferEvent extends TransferEvent {
  InitTransferEvent(this.amountInfo, this.isAddBen, this.benAlias, this.memo,
      {this.chargeAccount,
      this.city,
      this.branch,
      this.accountName,
      this.accountNumber,
      this.bankCode,
      this.cityName,
      this.branchName,
      this.outBenFee,
      this.benCcy});

  final AmountInfo amountInfo;
  final bool isAddBen;
  final String? benAlias;
  final String memo;
  final String? city;
  final String? cityName;
  final String? branch;
  final String? branchName;
  final String? accountName;
  final String? accountNumber;
  final String? bankCode;
  final String? outBenFee;
  final DebitAccountModel? chargeAccount;
  final String? benCcy; // ccy người nhận . VD chuyển USD qua qua VND
}

class ChangeDebitAccountEvent extends TransferEvent {
  ChangeDebitAccountEvent(this.accountDebitModel);

  final DebitAccountModel accountDebitModel;
}

class GetTransferRateEvent extends TransferEvent {
  int? transferTypeCode;
  String? fcy;
  double? amount;

  GetTransferRateEvent({this.transferTypeCode, this.fcy, this.amount});
}
