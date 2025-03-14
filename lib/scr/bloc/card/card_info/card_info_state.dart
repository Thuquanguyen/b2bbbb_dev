import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:equatable/equatable.dart';

class CardInfoState extends Equatable {
  final CardModel? cardInfo;
  final DataState? cardInfoDataState;
  final String? errorMessage;

  CardInfoState({
    this.cardInfo,
    this.cardInfoDataState,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        cardInfo,
        cardInfoDataState,
        errorMessage,
      ];

  CardInfoState copyWith({
    CardModel? cardInfo,
    DataState? cardInfoDataState,
    String? errorMessage,
  }) {
    return CardInfoState(
      cardInfo: cardInfo ?? this.cardInfo,
      cardInfoDataState: cardInfoDataState ?? this.cardInfoDataState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
