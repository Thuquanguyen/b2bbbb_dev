part of 'payment_electric_bloc.dart';

class PaymentElectricState extends Equatable {
  DataState? debitDataState;
  DebitAccountModel? selectedDebitAccount;
  List<DebitAccountModel>? listDebitAccount;
  String? getDebitErrMsg;

  DataState? getBillInfoDataState;
  BillInfo? billInfo;
  String? getBillInfoErrMsg;

  DataState? initBillDataState;
  InitBillResponse? initBillResponse;
  String? initBillErrMsg;

  DataState? confirmBillDataState;
  ConfirmTransferModel? confirmBillResponse;
  String? confirmBillErrMsg;

  PaymentElectricState(
      {this.debitDataState,
      this.selectedDebitAccount,
      this.listDebitAccount,
      this.getDebitErrMsg,
      this.getBillInfoDataState,
      this.billInfo,
      this.getBillInfoErrMsg,
      this.initBillDataState,
      this.initBillResponse,
      this.initBillErrMsg,
      this.confirmBillDataState,
      this.confirmBillResponse,
      this.confirmBillErrMsg});

  PaymentElectricState copyWith({
    DataState? debitDataState,
    DebitAccountModel? selectedDebitAccount,
    List<DebitAccountModel>? listDebitAccount,
    String? getDebitErrMsg,
    DataState? getBillInfoDataState,
    BillInfo? billInfo,
    String? getBillInfoErrMsg,
    DataState? initBillDataState,
    InitBillResponse? initBillResponse,
    String? initBillErrMsg,
    bool? clearBillInfo,
    DataState? confirmBillDataState,
    ConfirmTransferModel? confirmBillResponse,
    String? confirmBillErrMsg,
  }) {
    return PaymentElectricState(
        debitDataState: debitDataState ?? this.debitDataState,
        selectedDebitAccount: selectedDebitAccount ?? this.selectedDebitAccount,
        listDebitAccount: listDebitAccount ?? this.listDebitAccount,
        getDebitErrMsg: getDebitErrMsg ?? this.getDebitErrMsg,
        getBillInfoDataState: clearBillInfo == true
            ? null
            : getBillInfoDataState ?? this.getBillInfoDataState,
        billInfo: clearBillInfo == true ? null : billInfo ?? this.billInfo,
        getBillInfoErrMsg: clearBillInfo == true
            ? null
            : getBillInfoErrMsg ?? this.getBillInfoErrMsg,
        initBillDataState: initBillDataState ?? this.initBillDataState,
        initBillResponse: initBillResponse ?? this.initBillResponse,
        initBillErrMsg: initBillErrMsg ?? this.initBillErrMsg,
        confirmBillDataState: confirmBillDataState ?? this.confirmBillDataState,
        confirmBillResponse: confirmBillResponse ?? this.confirmBillResponse,
        confirmBillErrMsg: confirmBillErrMsg ?? this.confirmBillErrMsg);
  }

  @override
  List<Object?> get props => [
        debitDataState,
        selectedDebitAccount,
        listDebitAccount,
        getDebitErrMsg,
        getBillInfoDataState,
        billInfo,
        getBillInfoErrMsg,
        initBillDataState,
        initBillResponse,
        initBillErrMsg,
        confirmBillDataState,
        confirmBillResponse,
        confirmBillErrMsg
      ];
}
