import 'dart:async';

import 'package:b2b/scr/bloc/card/statement_card/statement_card_event.dart';
import 'package:b2b/scr/bloc/card/statement_card/statement_card_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/card/card_constract_list_response.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/card/card_statement_request.dart';
import 'package:b2b/scr/data/model/card/export_card_statement_response.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_state.dart';

class StatementCardBloc extends Bloc<StatementCardEvent, StatementCardState> {
  StatementCardBloc(this.repository) : super(StatementCardState());
  CardRepository repository;

  @override
  Stream<StatementCardState> mapEventToState(StatementCardEvent event) async* {
    switch (event.runtimeType) {
      case StatementCardInitEvent:
        yield* _mapToStatementCardInitEvent();
        break;
      case StatementChangeSelectedCardEvent:
        yield* _mapChangeSelectedCardEvent(
          event as StatementChangeSelectedCardEvent,
        );
        break;
      case StatementGetCardContractListEvent:
        yield* _getListCardContract(event as StatementGetCardContractListEvent);
        break;
      case StatementGetPeriodMonthEvent:
        yield* _getCardStatementMonth(event as StatementGetPeriodMonthEvent);
        break;
      case StatementChangePeriodEvent:
        yield state.copyWith(
            selectedPeriod: (event as StatementChangePeriodEvent).value);
        break;
      case StatementExportFileEvent:
        yield* _getCardStatement();
        break;
      default:
        break;
    }
  }

  Stream<StatementCardState> _mapToStatementCardInitEvent() async* {}

  Stream<StatementCardState> _mapChangeSelectedCardEvent(
      StatementChangeSelectedCardEvent event) async* {
    yield state.copyWith(selectedCardModel: event.cardModel);
  }

  Stream<StatementCardState> _getListCardContract(
      StatementGetCardContractListEvent event) async* {
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
            selectedCardModel: defaultCard);
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

  Stream<StatementCardState> _getCardStatementMonth(
      StatementGetPeriodMonthEvent e) async* {
    yield state.copyWith(statementPeriodDataState: DataState.preload);

    try {
      final response = await repository.getCardStatementMonth();
      if (response.result?.isSuccess() == true) {
        final ListResponse<String> listMonth = ListResponse<String>(
          response.data,
          (item) => item,
        );
        String? selectedValue;
        if (listMonth.items.isNotEmpty) {
          selectedValue = listMonth.items[0];
        }
        yield state.copyWith(
          statementPeriodDataState: DataState.data,
          listStatementPeriod: listMonth.items,
          selectedPeriod: selectedValue,
        );
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        statementPeriodDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<StatementCardState> _getCardStatement() async* {
    yield state.copyWith(getExportFileDataState: DataState.preload);

    try {
      CardStatementRequestModel requestModel = CardStatementRequestModel(
          contractCardId: state.selectedCardModel?.cardId,
          stmtMonth: state.selectedPeriod);
      final response = await repository.getCardStatement(request: requestModel);
      if (response.result?.isSuccess() == true) {
        yield state.copyWith(
          getExportFileDataState: DataState.data,
          fileData: ExportCardStatementResponse.fromJson(response.data),
        );
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        getExportFileDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }
}
