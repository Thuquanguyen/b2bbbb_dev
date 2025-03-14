import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/card/card_constract_list_response.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/card/export_card_statement_response.dart';
import 'package:equatable/equatable.dart';

class StatementCardState extends Equatable {
  final CardModel? selectedCardModel;
  final String? errorMessage;

  final DataState? cardContractDataState;
  final CardContractListResponse? cardContractListResponse;

  final DataState? statementPeriodDataState;

  final List<String>? listStatementPeriod;
  final String? selectedPeriod;

  final DataState? getExportFileDataState;
  final ExportCardStatementResponse? fileData;

  const StatementCardState(
      {this.selectedCardModel,
      this.errorMessage,
      this.cardContractDataState,
      this.cardContractListResponse,
      this.statementPeriodDataState,
      this.listStatementPeriod,
      this.selectedPeriod,
      this.getExportFileDataState,
      this.fileData});

  @override
  List<Object?> get props => [
        errorMessage,
        selectedCardModel,
        cardContractDataState,
        cardContractListResponse,
        statementPeriodDataState,
        listStatementPeriod,
        selectedPeriod,
        getExportFileDataState,
      ];

  StatementCardState copyWith(
      {String? errorMessage,
      CardModel? selectedCardModel,
      DataState? cardContractDataState,
      CardContractListResponse? cardContractListResponse,
      DataState? statementPeriodDataState,
      List<String>? listStatementPeriod,
      String? selectedPeriod,
      DataState? getExportFileDataState,
      ExportCardStatementResponse? fileData}) {
    return StatementCardState(
        errorMessage: errorMessage ?? this.errorMessage,
        selectedCardModel: selectedCardModel ?? this.selectedCardModel,
        cardContractDataState:
            cardContractDataState ?? this.cardContractDataState,
        cardContractListResponse:
            cardContractListResponse ?? this.cardContractListResponse,
        statementPeriodDataState:
            statementPeriodDataState ?? this.statementPeriodDataState,
        listStatementPeriod: listStatementPeriod ?? this.listStatementPeriod,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        getExportFileDataState:
            getExportFileDataState ?? this.getExportFileDataState,
        fileData: fileData ?? this.fileData);
  }
}
