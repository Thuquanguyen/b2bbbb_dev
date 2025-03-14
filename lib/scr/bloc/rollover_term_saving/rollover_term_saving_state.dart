part of 'rollover_term_saving_bloc.dart';

enum TermSaving { endOfPeriod, prepaid, periodically }

enum TermSavingPeriodically { yearly, quarterly, every6Months, monthly }

extension TermSavingToText on TermSaving {
  String get termSavingToText {
    switch (this) {
      case TermSaving.endOfPeriod:
        return AppTranslate.i18n.interestEndOfPeriodStr.localized;
      case TermSaving.periodically:
        return AppTranslate.i18n.interestPeriodicallyStr.localized;
      case TermSaving.prepaid:
        return AppTranslate.i18n.interestPrepaidStr.localized;
      default:
        return '';
    }
  }
}

extension TermSavingPeriodicallyToText on TermSavingPeriodically {
  String get termSavingPeriodicallyToText {
    switch (this) {
      case TermSavingPeriodically.yearly:
        return AppTranslate.i18n.interestYearlyStr.localized;
      case TermSavingPeriodically.quarterly:
        return AppTranslate.i18n.interestQuarterlyStr.localized;
      case TermSavingPeriodically.every6Months:
        return AppTranslate.i18n.interestEvery6MonthsStr.localized;
      case TermSavingPeriodically.monthly:
        return AppTranslate.i18n.interestMonthlyStr.localized;
      default:
        return '';
    }
  }
}

class RolloverTermSavingState extends Equatable {
  @override
  List<Object?> get props => [
        rolloverTermSavingDataState,
        savingPeriodModel,
        termSaving,
        termSavingPeriodically,
        chosenTermSaving,
        listDisplayData
      ];

  const RolloverTermSavingState(
      {this.rolloverTermSavingDataState = DataState.init,
      this.termSaving = TermSaving.endOfPeriod,
      this.savingPeriodModel,
      this.termSavingPeriodically = TermSavingPeriodically.monthly,
      this.chosenTermSaving,
      this.errorMessage,
      this.listDisplayData,
      this.listEndOfPeriod,
      this.listPrepaid,
      this.rolloverTermSavingModel});

  final DataState rolloverTermSavingDataState;
  final RolloverTermSavingModel? savingPeriodModel;
  final TermSaving termSaving;
  final TermSavingPeriodically? termSavingPeriodically;
  final EndOfPeriod? chosenTermSaving;
  final String? errorMessage;
  final RolloverTermSavingModel? rolloverTermSavingModel;

  final List<InterestRateDisplayModel>? listDisplayData;

  //Lai cuoi ky
  final List<InterestRateDisplayModel>? listEndOfPeriod;

  //Tiền gửi lãi trước
  final List<InterestRateDisplayModel>? listPrepaid;

  RolloverTermSavingState copyWith(
      {final DataState? rolloverTermSavingDataState,
      final RolloverTermSavingModel? savingPeriodModel,
      final TermSaving? termSaving,
      final TermSavingPeriodically? termSavingPeriodically,
      final EndOfPeriod? chosenTermSaving,
      final String? errorMessage,
      final RolloverTermSavingModel? rolloverTermSavingModel,
      final List<InterestRateDisplayModel>? listDisplayData,
      final List<InterestRateDisplayModel>? listEndOfPeriod,
      final List<InterestRateDisplayModel>? listPeriodically,
      final List<InterestRateDisplayModel>? listPrepaid}) {
    return RolloverTermSavingState(
        rolloverTermSavingDataState: rolloverTermSavingDataState ?? this.rolloverTermSavingDataState,
        savingPeriodModel: savingPeriodModel ?? this.savingPeriodModel,
        termSaving: termSaving ?? this.termSaving,
        termSavingPeriodically: termSavingPeriodically ?? this.termSavingPeriodically,
        chosenTermSaving: chosenTermSaving ?? this.chosenTermSaving,
        errorMessage: errorMessage,
        listDisplayData: listDisplayData ?? this.listDisplayData,
        listEndOfPeriod: listEndOfPeriod ?? this.listEndOfPeriod,
        listPrepaid: listPrepaid ?? this.listPrepaid,
        rolloverTermSavingModel: rolloverTermSavingModel ?? this.rolloverTermSavingModel);
  }
}
