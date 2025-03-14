import 'package:b2b/scr/data/model/card/card_constract_list_response.dart';
import 'package:b2b/scr/data/model/card/card_contract_info.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/transfer/confirm_transfer_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:equatable/equatable.dart';

import '../../data_state.dart';

class PaymentCardState extends Equatable {
  final DataState? debitDataState;

  final List<DebitAccountModel>? listDebitAccount;
  final DebitAccountModel? selectedDebitAccount;

  final DataState? cardContractDataState;
  final CardContractListResponse? cardContractListResponse;
  final dynamic selectedCardModel;

  final String? errorMessage;

  final bool? isMinPaySelected;

  final bool? isAllPaySelected;

  final DataState? initPaymentDataState;
  final InitTransferModel? initTransferModel;

  final DataState? confirmPaymentDataState;
  final ConfirmTransferModel? confirmPaymentModel;

  final CardContractInfo? contractInfo;
  final DataState? contractInfoDataState;

  PaymentCardState(
      {this.debitDataState,
      this.listDebitAccount,
      this.selectedDebitAccount,
      this.errorMessage,
      this.isMinPaySelected,
      this.isAllPaySelected,
      this.cardContractDataState,
      this.cardContractListResponse,
      this.selectedCardModel,
      this.initPaymentDataState,
      this.initTransferModel,
      this.confirmPaymentDataState,
      this.confirmPaymentModel,
      this.contractInfoDataState,
      this.contractInfo});

  @override
  List<Object?> get props => [
        debitDataState,
        selectedDebitAccount,
        errorMessage,
        isMinPaySelected,
        isAllPaySelected,
        cardContractDataState,
        cardContractListResponse,
        selectedCardModel,
        initPaymentDataState,
        initTransferModel,
        confirmPaymentDataState,
        confirmPaymentModel,
        contractInfo,
        confirmPaymentDataState,
        contractInfoDataState,
        contractInfo
      ];

  PaymentCardState copyWith(
      {DataState? debitDataState,
      List<DebitAccountModel>? listDebitAccount,
      DebitAccountModel? selectedDebitAccount,
      String? errorMessage,
      bool? isMinPaySelected,
      bool? isAllPaySelected,
      DataState? cardContractDataState,
      CardContractListResponse? cardContractListResponse,
      dynamic selectedCardModel,
      DataState? initPaymentDataState,
      InitTransferModel? initTransferModel,
      DataState? confirmPaymentDataState,
      ConfirmTransferModel? confirmPaymentModel,
      DataState? contractInfoDataState,
      CardContractInfo? contractInfo}) {
    return PaymentCardState(
        debitDataState: debitDataState ?? this.debitDataState,
        listDebitAccount: listDebitAccount ?? this.listDebitAccount,
        selectedDebitAccount: selectedDebitAccount ?? this.selectedDebitAccount,
        errorMessage: errorMessage ?? this.errorMessage,
        isMinPaySelected: isMinPaySelected ?? this.isMinPaySelected,
        isAllPaySelected: isAllPaySelected ?? this.isAllPaySelected,
        cardContractDataState:
            cardContractDataState ?? this.cardContractDataState,
        cardContractListResponse:
            cardContractListResponse ?? this.cardContractListResponse,
        selectedCardModel: selectedCardModel ?? this.selectedCardModel,
        initPaymentDataState: initPaymentDataState ?? this.initPaymentDataState,
        initTransferModel: initTransferModel ?? this.initTransferModel,
        confirmPaymentDataState:
            confirmPaymentDataState ?? this.confirmPaymentDataState,
        confirmPaymentModel: confirmPaymentModel ?? this.confirmPaymentModel,
        contractInfoDataState:
            contractInfoDataState ?? this.contractInfoDataState,
        contractInfo: contractInfo ?? this.contractInfo);
  }
}
