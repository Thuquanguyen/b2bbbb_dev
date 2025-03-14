part of 'transfer_rate_bloc.dart';

class TransferRateState extends Equatable {
  DataState? getRateDataState;
  TransferRate? transferRate;
  String? errMsg;

  TransferRateState({this.getRateDataState, this.transferRate, this.errMsg});

  TransferRateState copyWith(
      {DataState? getRateDataState,
      TransferRate? transferRate,
      String? errMsg}) {
    return TransferRateState(
        getRateDataState: getRateDataState ?? this.getRateDataState,
        transferRate: transferRate ?? this.transferRate,
        errMsg: errMsg ?? this.errMsg);
  }

  @override
  List<Object?> get props => [getRateDataState, transferRate, errMsg];
}
