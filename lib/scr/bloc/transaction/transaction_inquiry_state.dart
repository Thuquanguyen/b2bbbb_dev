part of 'transaction_inquiry_bloc.dart';

@immutable
class TransactionInquiryState extends Equatable {
  const TransactionInquiryState({
    this.listState,
    this.detailState,
  });

  final TransactionInquiryListState? listState;
  final TransactionInquiryDetailState? detailState;

  TransactionInquiryState copyWith({
    TransactionInquiryListState? listState,
    TransactionInquiryDetailState? detailState,
  }) {
    return TransactionInquiryState(
      listState: listState ?? this.listState,
      detailState: detailState ?? this.detailState,
    );
  }

  @override
  List<Object?> get props => [
        listState,
        detailState,
      ];
}

class TransactionInquiryListState {
  const TransactionInquiryListState({
    this.list,
    this.dataState = DataState.init,
    this.errorMessage,
  });

  final List<TransactionGrouped<TransactionMainModel>>? list;
  final DataState dataState;
  final String? errorMessage;
}

class TransactionInquiryDetailState {
  const TransactionInquiryDetailState({
    this.data,
    this.dataState = DataState.init,
    this.errorMessage,
  });

  final TransactionMainModel? data;
  final DataState dataState;
  final String? errorMessage;
}
