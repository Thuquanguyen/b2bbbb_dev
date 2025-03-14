part of 'bill_bloc.dart';

class BillState extends Equatable {
  DataState? getBillServiceDataState;
  List<BillService>? listBillService;
  String? errMsg;

  DataState? getBillProviderDataState;
  List<BillProvider>? listBillProvider;
  String? getBillProviderErrMsg;

  DataState? getListBillSavedDataState;
  List<BillSaved>? listBillSaved;
  String? getListBillSavedErrMsg;

  BillState(
      {this.getBillServiceDataState,
      this.listBillService,
      this.errMsg,
      this.getBillProviderDataState,
      this.listBillProvider,
      this.getBillProviderErrMsg,
      this.getListBillSavedDataState,
      this.listBillSaved,
      this.getListBillSavedErrMsg});

  BillState copyWith({
    DataState? getBillServiceDataState,
    List<BillService>? listBillService,
    String? errMsg,
    DataState? getBillProviderDataState,
    List<BillProvider>? listBillProvider,
    String? getBillProviderErrMsg,
    DataState? getListBillSavedDataState,
    List<BillSaved>? listBillSaved,
    String? getListBillSavedErrMsg,
  }) {
    return BillState(
        getBillServiceDataState:
            getBillServiceDataState ?? this.getBillServiceDataState,
        listBillService: listBillService ?? this.listBillService,
        errMsg: errMsg ?? this.errMsg,
        getBillProviderDataState:
            getBillProviderDataState ?? this.getBillProviderDataState,
        listBillProvider: listBillProvider ?? this.listBillProvider,
        getBillProviderErrMsg:
            getBillProviderErrMsg ?? this.getBillProviderErrMsg,
        getListBillSavedDataState:
            getListBillSavedDataState ?? this.getListBillSavedDataState,
        listBillSaved: listBillSaved ?? this.listBillSaved,
        getListBillSavedErrMsg:
            getListBillSavedErrMsg ?? this.getListBillSavedErrMsg);
  }

  @override
  List<Object?> get props => [
        getBillServiceDataState,
        listBillService,
        errMsg,
        getBillProviderDataState,
        listBillProvider,
        getBillProviderErrMsg,
        getListBillSavedDataState,
        listBillSaved,
        getListBillSavedErrMsg
      ];
}
