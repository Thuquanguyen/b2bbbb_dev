part of 'transfer_bloc.dart';

// ignore: must_be_immutable
class TransferState extends Equatable {
  /**
   * Get Rate khi ck ngoại tệ => VND
   */
  bool needGetRate() {
    if (transferType == TransferType.TRANSINTERBANK) {
      return debitAccountDefault?.accountCurrency != 'VND';
    }
    return debitAccountDefault?.accountCurrency != 'VND' &&
        detailBeneficianAccount?.accountCurrency == 'VND';
  }

  @override
  List<Object?> get props => [
        transferType,
        transfer247,
        transferInterbankState,
        isShowLoading,
        listDebitAccountDataState,
        listDebitAccount,
        debitAccountDefault,
        detailBeneficianAccountDataState,
        detailBeneficianAccount,
        initTransferModel,
        initTransferModelDataState,
        confirmTransferModelDataState,
        confirmTransferModel,
        listBenModel,
        listBenDataState,
        listBranch,
        listBranchDataState,
        errorMessage,
        errorAccountMessage,
      ];

  TransferState({
    this.transferType,
    this.transfer247 = const Transfer247State(),
    this.transferInterbankState = const TransferInterbankState(),
    this.isShowLoading = false,
    this.listDebitAccountDataState = DataState.init,
    this.listDebitAccount,
    this.debitAccountDefault,
    this.detailBeneficianAccount,
    this.detailBeneficianAccountDataState = DataState.init,
    this.initTransferModel,
    this.initTransferModelDataState = DataState.init,
    this.confirmTransferModelDataState = DataState.init,
    this.confirmTransferModel,
    this.errorMessage,
    this.amountInfo,
    this.listBenModel,
    this.listBranch,
    this.listBranchDataState,
    this.listBenDataState = DataState.init,
    this.isShowLoadingAccount = false,
    this.errorAccountMessage,
    this.isShowLoadingBranch = false,
  });

  TransferState copyWith(
      {final String? errorMessage,
      final String? errorAccountMessage,
      final TransferType? transferType,
      final Transfer247State? transfer247,
      final TransferInterbankState? transferInterbankState,
      final bool? isShowLoading,
      final DataState? listDebitAccountDataState,
      final List<DebitAccountModel>? listDebitAccount,
      final DebitAccountModel? debitAccountDefault,
      final DataState? detailBeneficianAccountDataState,
      final BeneficianAccountModel? detailBeneficianAccount,
      final InitTransferModel? initTransferModel,
      final DataState? initTransferModelDataState,
      final DataState? confirmTransferModelDataState,
      final ConfirmTransferModel? confirmTransferModel,
      final AmountInfo? amountInfo,
      final List<BeneficiarySavedModel>? listBenModel,
      final List<BranchModel>? listBranch,
      final DataState? listBenDataState,
      final DataState? listBranchDataState,
      final bool? isShowLoadingAccount,
      final bool? isShowLoadingBranch,
      final bool? clearMessage = false,
      final bool? clearBenDetail = false,
      final bool? clearErrorAccountMessage = false}) {
    return TransferState(
        transferType: transferType ?? this.transferType,
        transfer247: transfer247 ?? this.transfer247,
        transferInterbankState:
            transferInterbankState ?? this.transferInterbankState,
        isShowLoading: isShowLoading ?? this.isShowLoading,
        listDebitAccountDataState:
            listDebitAccountDataState ?? this.listDebitAccountDataState,
        listDebitAccount: listDebitAccount ?? this.listDebitAccount,
        debitAccountDefault: debitAccountDefault ?? this.debitAccountDefault,
        detailBeneficianAccountDataState: detailBeneficianAccountDataState ??
            this.detailBeneficianAccountDataState,
        detailBeneficianAccount: clearBenDetail == true
            ? null
            : detailBeneficianAccount ?? this.detailBeneficianAccount,
        initTransferModel: initTransferModel ?? this.initTransferModel,
        initTransferModelDataState:
            initTransferModelDataState ?? this.initTransferModelDataState,
        amountInfo: amountInfo ?? this.amountInfo,
        confirmTransferModelDataState:
            confirmTransferModelDataState ?? this.confirmTransferModelDataState,
        confirmTransferModel: confirmTransferModel ?? this.confirmTransferModel,
        listBenModel: listBenModel ?? this.listBenModel,
        listBranch: listBranch ?? this.listBranch,
        listBenDataState: listBenDataState ?? this.listBenDataState,
        listBranchDataState: listBranchDataState ?? this.listBranchDataState,
        errorMessage:
            clearMessage == true ? null : errorMessage ?? this.errorMessage,
        isShowLoadingAccount: isShowLoadingAccount ?? this.isShowLoadingAccount,
        isShowLoadingBranch: isShowLoadingBranch ?? this.isShowLoadingBranch,
        errorAccountMessage: clearErrorAccountMessage == true
            ? null
            : errorAccountMessage ?? this.errorAccountMessage);
  }

  final Transfer247State transfer247;
  final TransferInterbankState transferInterbankState;
  final TransferType? transferType;
  final bool isShowLoading;
  final bool isShowLoadingAccount;
  final bool isShowLoadingBranch;
  final DataState listDebitAccountDataState;
  final List<DebitAccountModel>? listDebitAccount;
  final List<BeneficiarySavedModel>? listBenModel;
  final List<BranchModel>? listBranch;
  final DataState? listBranchDataState;
  final DataState listBenDataState;
  final DebitAccountModel? debitAccountDefault;
  final DataState detailBeneficianAccountDataState;
  final BeneficianAccountModel? detailBeneficianAccount;
  final InitTransferModel? initTransferModel;
  final DataState initTransferModelDataState;
  final DataState confirmTransferModelDataState;
  final ConfirmTransferModel? confirmTransferModel;
  final String? errorMessage;
  final String? errorAccountMessage;
  final AmountInfo? amountInfo;
}

// Transfer247State
class Transfer247State extends Equatable {
  final BenBankModel? benBank;
  final DebitAccountModel? feeAccount;
  final bool autoFillBenAlias;

  const Transfer247State({
    this.benBank,
    this.feeAccount,
    this.autoFillBenAlias = true,
  });

  Transfer247State copyWith({
    final BenBankModel? benBank,
    final DebitAccountModel? feeAccount,
    final bool? autoFillBenAlias,
  }) {
    return Transfer247State(
        benBank: benBank ?? this.benBank,
        feeAccount: feeAccount ?? this.feeAccount,
        autoFillBenAlias: autoFillBenAlias ?? this.autoFillBenAlias);
  }

  @override
  List<Object?> get props => [benBank, feeAccount];
}

// Transfer Interbank
class TransferInterbankState extends Equatable {
  final BenBankModel? benBank;
  final CityModel? cityModel;
  final BaseItemModel? baseItemModel;
  final BranchModel? branchModel;
  final DebitAccountModel? feeAccount;
  final String? beneficiaryName;
  final String? accountNumber;
  final SaveBen? saveBen;
  final List<BeneficiarySavedModel>? listBenModel;
  final List<BranchModel>? listBranch;

  const TransferInterbankState(
      {this.cityModel,
      this.branchModel,
      this.accountNumber,
      this.baseItemModel,
      this.benBank,
      this.saveBen,
      this.feeAccount,
      this.listBenModel,
      this.listBranch,
      this.beneficiaryName});

  TransferInterbankState copyWith(
      {final CityModel? cityModel,
      final BenBankModel? benBank,
      final BaseItemModel? baseItemModel,
      final BranchModel? branchModel,
      final DebitAccountModel? feeAccount,
      final String? beneficiaryName,
      final String? accountNumber,
      final SaveBen? saveBen,
      final List<BeneficiarySavedModel>? listBenModel,
      final List<BranchModel>? listBranch,
      final bool clearData = false,
      bool clearCityModel = false,
      bool clearBranchModel = false}) {
    Logger.debug("CLEAR ============> $clearCityModel - $clearData");
    return TransferInterbankState(
        cityModel: (clearCityModel || clearData)
            ? null
            : (cityModel ?? this.cityModel),
        branchModel: (clearBranchModel || clearData)
            ? null
            : (branchModel ?? this.branchModel),
        baseItemModel: baseItemModel ?? this.baseItemModel,
        benBank: benBank ?? this.benBank,
        feeAccount: feeAccount ?? this.feeAccount,
        saveBen: clearData ? null : (saveBen ?? this.saveBen),
        listBenModel: listBenModel ?? this.listBenModel,
        listBranch: listBranch ?? this.listBranch,
        beneficiaryName:
            beneficiaryName ?? (clearData ? null : this.beneficiaryName),
        accountNumber:
            clearData ? null : (accountNumber ?? this.accountNumber));
  }

  @override
  List<Object?> get props => [
        cityModel,
        branchModel,
        accountNumber,
        baseItemModel,
        benBank,
        saveBen,
        feeAccount,
        beneficiaryName,
        listBenModel,
        listBranch
      ];
}
