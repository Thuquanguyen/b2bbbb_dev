part of 'exchange_rate_bloc.dart';

@immutable
abstract class ExchangeRateEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ExchangeRateGetListAll extends ExchangeRateEvent {}