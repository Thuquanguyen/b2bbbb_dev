import 'dart:async';

import 'package:b2b/scr/bloc/card/payment_card/payment_card_event.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_state.dart';
import 'package:b2b/scr/bloc/transfer/transfer_bloc.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_constract_list_response.dart';
import 'package:b2b/scr/data/model/card/card_contract_info.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/transfer/confirm_transfer_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_state.dart';

class PaymentCardBloc extends Bloc<PaymentCardEvent, PaymentCardState> {
  PaymentCardBloc(this.repository) : super(PaymentCardState());
  CardRepository repository;

  @override
  Stream<PaymentCardState> mapEventToState(PaymentCardEvent event) async* {
    switch (event.runtimeType) {
      case PaymentCardInitEvent:
        yield* _mapToPaymentCardInitEvent();
        break;
      case GetCardContractListEvent:
        yield* _getListCardContract(event as GetCardContractListEvent);
        break;
      case PaymentCardChangeStatusEvent:
        yield* _mapToPaymentCardChangeStatusEvent(
            event as PaymentCardChangeStatusEvent);
        break;
      case PaymentCardChangeDebitAccountEvent:
        yield* _mapChangeDebitAccountEventEventToState(
          event as PaymentCardChangeDebitAccountEvent,
        );
        break;
      case ChangeSelectedCardEvent:
        yield* _mapChangeSelectedCardEvent(
          event as ChangeSelectedCardEvent,
        );
        break;
      case InitPaymentCardEvent:
        yield* _mapInitPaymentCardEvent(
          event as InitPaymentCardEvent,
        );
        break;
      case PaymentCardConfirmEvent:
        yield* _mapPaymentCardConfirmEvent();
        break;
      case GetContractInfo:
        yield* _mapGetContractInfo(event as GetContractInfo);
        break;
      default:
        break;
    }
  }

  Stream<PaymentCardState> _mapChangeDebitAccountEventEventToState(
      PaymentCardChangeDebitAccountEvent event) async* {
    yield state.copyWith(
      selectedDebitAccount: event.debitAccountModel,
    );
  }

  Stream<PaymentCardState> _mapToPaymentCardInitEvent() async* {
    yield* _getDebitListAccount();
  }

  Stream<PaymentCardState> _getDebitListAccount() async* {
    yield state.copyWith(
        debitDataState: DataState.preload,
        cardContractDataState: DataState.preload);
    try {
      final response = await repository.getListDebitAccount();
      if (response.result!.isSuccess()) {
        final SingleResponse<DebitAccountResponseModel> listAccountDebitModel =
            SingleResponse<DebitAccountResponseModel>(
          response.data,
          (item) => DebitAccountResponseModel.fromJson(item),
        );
        if (listAccountDebitModel.item.debbitAccountList!.isEmpty) {
          throw AppTranslate.i18n.canNotFindAccountStr.localized;
        }
        var accountDebit;
        try {
          accountDebit =
              listAccountDebitModel.item.debbitAccountList?.firstWhere(
            (element) =>
                element.accountNumber ==
                listAccountDebitModel.item.accountDefault,
          );
          listAccountDebitModel.item.debbitAccountList!.removeWhere(
            (element) =>
                listAccountDebitModel.item.accountDefault ==
                element.accountNumber,
          );
          listAccountDebitModel.item.debbitAccountList!.insert(
            0,
            accountDebit,
          );
        } catch (e) {
          accountDebit = listAccountDebitModel.item.debbitAccountList?[0];
        }
        yield state.copyWith(
          debitDataState: DataState.data,
          listDebitAccount: listAccountDebitModel.item.debbitAccountList,
          selectedDebitAccount: accountDebit,
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        debitDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<PaymentCardState> _getListCardContract(
      GetCardContractListEvent event) async* {
    yield state.copyWith(
      cardContractDataState: DataState.preload,
    );
    try {
      final response = await repository.getCardContractList();
      if (response.item.result?.isSuccess() == true) {
        CardContractListResponse? cardListResponse = response.item
            .toModel((json) => CardContractListResponse.fromJson(json));

        CardModel? defaultCard = state.selectedCardModel;
        if (cardListResponse != null &&
            cardListResponse.card != null &&
            cardListResponse.card!.isNotEmpty &&
            defaultCard == null) {
          defaultCard = cardListResponse.card![0];
        }

        yield state.copyWith(
            cardContractDataState: DataState.data,
            cardContractListResponse: cardListResponse,
            selectedCardModel: defaultCard,
            isAllPaySelected: true);
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        cardContractDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<PaymentCardState> _mapToPaymentCardChangeStatusEvent(
      PaymentCardChangeStatusEvent event) async* {
    yield state.copyWith(
      isMinPaySelected: event.isMinPay
          ? event.isSelected
          : (event.isMinPay == false && event.isSelected == true)
              ? false
              : null,
      isAllPaySelected: !event.isMinPay
          ? event.isSelected
          : (event.isMinPay == true && event.isSelected == true)
              ? false
              : null,
    );
  }

  Stream<PaymentCardState> _mapChangeSelectedCardEvent(
      ChangeSelectedCardEvent event) async* {
    yield state.copyWith(
        selectedCardModel: event.cardModel, isAllPaySelected: true);

    // String? oldId = "";
    // if (state.selectedCardModel is CardModel) {
    //   oldId = (state.selectedCardModel as CardModel).cardId;
    // }else if(state.selectedCardModel is BenefitContract){
    //   oldId = (state.selectedCardModel as BenefitContract).contractId;
    // }
    //
    // if (event.cardModel is CardModel &&
    //     event.cardModel.cardId == state.selectedCardModel?.cardId) {
    //   return;
    // }
    //
    // yield state.copyWith(selectedCardModel: cardModel, isAllPaySelected: true);
  }

  Stream<PaymentCardState> _mapInitPaymentCardEvent(
      InitPaymentCardEvent event) async* {
    try {
      yield state.copyWith(
        initPaymentDataState: DataState.preload,
      );

      final rawResponse = await repository.initPayment(
          debitAccountModel: event.debitAccountModel,
          cardId: event.cardId,
          amountInfo: event.amountInfo);
      if (rawResponse.result!.isSuccess()) {
        final response = SingleResponse<InitTransferModel>(
          rawResponse.data,
          (item) => InitTransferModel.fromJson(item),
        );
        yield state.copyWith(
          initPaymentDataState: DataState.data,
          initTransferModel: response.item,
        );
      } else {
        throw rawResponse.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        initPaymentDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<PaymentCardState> _mapPaymentCardConfirmEvent() async* {
    try {
      yield state.copyWith(
        confirmPaymentDataState: DataState.preload,
      );
      final rawResponse = await repository.confirmPayment(
        state.initTransferModel!,
        TransferType.CARD.getTransferTypeCode,
      );
      if (rawResponse.result!.isSuccess()) {
        final response = rawResponse.data;
        yield state.copyWith(
          confirmPaymentDataState: DataState.data,
          confirmPaymentModel: ConfirmTransferModel(
            rawResponse.result!.getMessage(),
            (response['verify_otp_display_type'] as int),
          ),
        );
      } else {
        throw rawResponse.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        confirmPaymentDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<PaymentCardState> _mapGetContractInfo(GetContractInfo event) async* {
    if (event.contractId == null) {
      return;
    }
    yield state.copyWith(
      contractInfoDataState: DataState.preload,
      isAllPaySelected: false,
      isMinPaySelected: false,
    );
    try {
      final response = await repository.getCardContractInfo(event.contractId!);
      if (response.item.result?.isSuccess() == true) {
        CardContractInfo? contractInfo =
            response.item.toModel((json) => CardContractInfo.fromJson(json));
        yield state.copyWith(
            contractInfoDataState: DataState.data,
            contractInfo: contractInfo,
            isAllPaySelected: true);
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        contractInfoDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.cardGetContractInfoErrStr.localized,
      );
    }
  }
}
