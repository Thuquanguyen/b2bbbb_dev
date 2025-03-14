import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/exchange_rate_model.dart';
import 'package:b2b/scr/data/repository/exchange_rate_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'exchange_rate_event.dart';

part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  ExchangeRateBloc({
    required this.exchangeRateRepositoryImpl,
  }) : super(const ExchangeRateState());

  final ExchangeRateRepositoryImpl exchangeRateRepositoryImpl;

  @override
  Stream<ExchangeRateState> mapEventToState(event) async* {
    yield const ExchangeRateState(dataState: DataState.preload);

    try {
      final responseData =
          await exchangeRateRepositoryImpl.getExchangeRateList();
      final code = responseData.item.result?.code;
      if (code == '200') {
        ExchangeRateModel _erModel = responseData.item.toModel(
          (json) => ExchangeRateModel.fromJson(json),
        );
        yield ExchangeRateState(
          dataState: DataState.data,
          model: _erModel.copyWith(
              dataRate:
                  _erModel.dataRate?.where((c) => c.code != 'VND').toList()),
        );
      } else {
        yield const ExchangeRateState(dataState: DataState.error);
      }
    } catch (e) {
      //print(e.toString());
    }
  }
}
