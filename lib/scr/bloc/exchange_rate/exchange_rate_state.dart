part of 'exchange_rate_bloc.dart';

class ExchangeRateState extends Equatable {
  const ExchangeRateState({
    this.model,
    this.dataState = DataState.init,
  });

  final ExchangeRateModel? model;
  final DataState dataState;

  @override
  List<Object?> get props => [
        model,
        dataState,
      ];
}
