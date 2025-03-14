part of 'rollover_term_saving_bloc.dart';

@immutable
abstract class RolloverTermSavingEvent {}

class GetSavingPeriodEvent extends RolloverTermSavingEvent {}

class ChooseTermSavingEvent extends RolloverTermSavingEvent {
  ChooseTermSavingEvent(this.termSaving, {this.termSavingPeriodically});
  final TermSaving termSaving;
  final TermSavingPeriodically? termSavingPeriodically;
}

class ChooseTermSavingPeriodicallyEvent extends RolloverTermSavingEvent {
  ChooseTermSavingPeriodicallyEvent(this.termSavingPeriodically);
  final TermSavingPeriodically? termSavingPeriodically;
}
