import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term_rate.dart';
import 'package:b2b/scr/data/model/open_saving/settelment.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:equatable/equatable.dart';

class DepositsInputState extends Equatable {
  //Kỳ hạn gửi
  final DataState? rollOverTermListDataState;
  final List<RolloverTerm>? rollOverTermList;
  final RolloverTerm? selectedRollOverTerm;
  final RolloverTermRate? rolloverTermRate;

  //Phuonh thuc nhan lai
  final DataState? settElmentDataState;
  final Settelment? selectedSettelment;
  final List<Settelment>? listSettelment;

  final DataState? rollTermRateDataState;

  final String? errMessage;

  const DepositsInputState({
    this.rollOverTermListDataState,
    this.rollOverTermList,
    this.selectedRollOverTerm,
    this.rollTermRateDataState,
    this.rolloverTermRate,
    this.settElmentDataState,
    this.selectedSettelment,
    this.listSettelment,
    this.errMessage,
  });

  DepositsInputState copyWith({
    DataState? rollOverTermListDataState,
    List<RolloverTerm>? rollOverTermList,
    RolloverTerm? selectedRollOverTerm,
    bool? clearRollOverTermList = false,
    DataState? rollTermRateDataState,
    bool? isClearRolloverRateEvent,
    RolloverTermRate? rolloverTermRate,
    DataState? settelmentDataState,
    Settelment? selectedSettelment,
    List<Settelment>? listSettelment,
    String? errMessage,
  }) {
    Logger.debug('DepositsInputState copyWith');

    if (isClearRolloverRateEvent == true) {
      return DepositsInputState(
        settElmentDataState: this.settElmentDataState,
        listSettelment: this.listSettelment,
        selectedSettelment: this.selectedSettelment,
      );
    }

    return DepositsInputState(
      rollOverTermListDataState:
          rollOverTermListDataState ?? this.rollOverTermListDataState,
      rollOverTermList: clearRollOverTermList == true
          ? null
          : rollOverTermList ?? this.rollOverTermList,
      selectedRollOverTerm: clearRollOverTermList == true
          ? null
          : selectedRollOverTerm ?? this.selectedRollOverTerm,
      rollTermRateDataState:
          rollTermRateDataState ?? this.rollTermRateDataState,
      rolloverTermRate: clearRollOverTermList == true
          ? null
          : rolloverTermRate ?? this.rolloverTermRate,
      settElmentDataState: settelmentDataState ?? this.settElmentDataState,
      selectedSettelment: selectedSettelment ?? this.selectedSettelment,
      listSettelment: listSettelment ?? this.listSettelment,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  @override
  List<Object?> get props => [
        rollOverTermListDataState,
        selectedRollOverTerm,
        rollTermRateDataState,
        rolloverTermRate,
        settElmentDataState,
        selectedSettelment,
      ];
}
