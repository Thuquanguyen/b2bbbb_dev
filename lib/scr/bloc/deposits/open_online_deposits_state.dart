part of 'open_online_deposits_bloc.dart';

class OpenOnlineDepositsState extends Equatable {
  final SavingDepositsProductResponse? currentDepositProduct;

  //Tien gui online, lai tra trc, cuoi ky
  final DepositsType? currentDepositType;

  //Phuong thuc nhan lai
  final SavingReceiveMethod? savingReceiveMethod;

  final DataState? debitAccountDataState;
  final DataState? depositsSavingProductState;

  final List<DebitAccountModel>? listDebitAccount;
  final DebitAccountModel? debitAccountDefault;

  final DebitAccountModel? rootAccountDebit;
  final DebitAccountModel? receiveAccountProfit;
  final String? errorMessage;

  //tien gui thuong, tien gui VPS
  final List<SavingDepositsProductResponse>? listDepositsProduct;

  final DepositsInputState? depositsInputState;

  final DataState? initDepositsDataState;
  final InitDepositsResult? intDepositsResult;

  final DataState? confirmDepositsDataState;
  final TransactionManageConfirmResponse? confirmResponse;

  OpenOnlineDepositsState(
      {this.currentDepositProduct,
      this.currentDepositType,
      this.savingReceiveMethod,
      this.debitAccountDataState,
      this.listDebitAccount,
      this.debitAccountDefault,
      this.errorMessage,
      this.rootAccountDebit,
      this.receiveAccountProfit,
      this.depositsSavingProductState,
      this.listDepositsProduct,
      this.depositsInputState = const DepositsInputState(),
      this.intDepositsResult,
      this.initDepositsDataState,
      this.confirmDepositsDataState,
      this.confirmResponse});

  OpenOnlineDepositsState copyWith(
      {DataState? debitAccountDataState,
      DataState? depositsSavingProductState,
      List<DebitAccountModel>? listDebitAccount,
      DebitAccountModel? debitAccountDefault,
      DebitAccountModel? rootAccountDebit,
      DebitAccountModel? receiveAccountProfit,
      String? errorMessage,
      List<SavingDepositsProductResponse>? listDepositsProduct,
      SavingDepositsProductResponse? currentDepositProduct,
      DepositsType? currentDepositType,
      SavingReceiveMethod? savingReceiveMethod,
      bool? clearSavingReceiveMethod,
      DepositsInputState? depositsInputState,
      DataState? confirmDepositsDataState,
      InitDepositsResult? intDepositsResult,
      DataState? initDepositsDataState,
      TransactionManageConfirmResponse? confirmResponse,
      bool? isClearInputState,
      bool? clearDepositInitDataState = false}) {
    if (isClearInputState == true) {
      return OpenOnlineDepositsState(
        currentDepositProduct: this.currentDepositProduct,
        depositsSavingProductState:
            depositsSavingProductState ?? this.depositsSavingProductState,
        listDepositsProduct: listDepositsProduct ?? this.listDepositsProduct,
        currentDepositType: currentDepositType ?? this.currentDepositType,
        savingReceiveMethod: this.savingReceiveMethod,
      );
    }

    return OpenOnlineDepositsState(
      currentDepositProduct:
          currentDepositProduct ?? this.currentDepositProduct,
      debitAccountDataState:
          debitAccountDataState ?? this.debitAccountDataState,
      listDebitAccount: listDebitAccount ?? this.listDebitAccount,
      debitAccountDefault: debitAccountDefault ?? this.debitAccountDefault,
      rootAccountDebit: rootAccountDebit ?? this.rootAccountDebit,
      receiveAccountProfit: receiveAccountProfit ?? this.receiveAccountProfit,
      errorMessage: errorMessage ?? this.errorMessage,
      depositsSavingProductState:
          depositsSavingProductState ?? this.depositsSavingProductState,
      listDepositsProduct: listDepositsProduct ?? this.listDepositsProduct,
      currentDepositType: currentDepositType ?? this.currentDepositType,
      savingReceiveMethod: (clearSavingReceiveMethod == true)
          ? null
          : savingReceiveMethod ?? this.savingReceiveMethod,
      depositsInputState: depositsInputState ?? this.depositsInputState,
      initDepositsDataState: clearDepositInitDataState == true
          ? null
          : initDepositsDataState ?? this.initDepositsDataState,
      intDepositsResult: intDepositsResult ?? this.intDepositsResult,
      confirmDepositsDataState:
          confirmDepositsDataState ?? this.confirmDepositsDataState,
      confirmResponse: confirmResponse ?? this.confirmResponse,
    );
  }

  @override
  List<Object?> get props => [
        currentDepositProduct,
        debitAccountDataState,
        rootAccountDebit,
        receiveAccountProfit,
        depositsSavingProductState,
        currentDepositType,
        savingReceiveMethod,
        depositsInputState,
        confirmDepositsDataState,
        initDepositsDataState,
      ];
}
