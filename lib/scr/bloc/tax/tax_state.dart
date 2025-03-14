part of 'tax_bloc.dart';

class TaxState extends Equatable {
  DataState? getTaxOnlineDataState;
  TaxOnline? taxOnline;
  String? errMsg;
  List<DebitAccountModel>? listDebitAccount;
  DataState? getListDebitDataState;
  DebitAccountModel? rootAccount;
  DebitAccountModel? feeAccount;

  DataState? initTaxDataState;
  DataState? confirmTaxDataState;
  InitTransferModel? initTransferModel;
  ConfirmTransferModel? confirmPaymentModel;

  TaxState(
      {this.getTaxOnlineDataState,
      this.taxOnline,
      this.errMsg,
      this.listDebitAccount,
      this.getListDebitDataState,
      this.rootAccount,
      this.feeAccount,
      this.initTaxDataState,
      this.confirmTaxDataState,
      this.initTransferModel,
      this.confirmPaymentModel});

  TaxState copyWith({
    DataState? getTaxOnlineDataState,
    TaxOnline? taxOnline,
    String? errMsg,
    List<DebitAccountModel>? listDebitAccount,
    DataState? getListDebitDataState,
    DebitAccountModel? rootAccount,
    DebitAccountModel? feeAccount,
    DataState? initTaxDataState,
    DataState? confirmTaxDataState,
    InitTransferModel? initTransferModel,
    ConfirmTransferModel? confirmPaymentModel,
  }) {
    return TaxState(
      getTaxOnlineDataState:
          getTaxOnlineDataState ?? this.getTaxOnlineDataState,
      taxOnline: taxOnline ?? this.taxOnline,
      listDebitAccount: listDebitAccount ?? this.listDebitAccount,
      errMsg: errMsg ?? this.errMsg,
      getListDebitDataState:
          getListDebitDataState ?? this.getListDebitDataState,
      rootAccount: rootAccount ?? this.rootAccount,
      feeAccount: feeAccount ?? this.feeAccount,
      initTaxDataState: initTaxDataState ?? this.initTaxDataState,
      confirmTaxDataState: confirmTaxDataState ?? this.confirmTaxDataState,
      initTransferModel: initTransferModel ?? this.initTransferModel,
      confirmPaymentModel: confirmPaymentModel ?? this.confirmPaymentModel,
    );
  }

  @override
  List<Object?> get props => [
        getTaxOnlineDataState,
        taxOnline,
        errMsg,
        listDebitAccount,
        getTaxOnlineDataState,
        rootAccount,
        feeAccount,
        initTaxDataState,
        confirmTaxDataState,
        initTransferModel,
        confirmPaymentModel
      ];
}
