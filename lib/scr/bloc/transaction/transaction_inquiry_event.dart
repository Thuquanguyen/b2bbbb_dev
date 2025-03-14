part of 'transaction_inquiry_bloc.dart';

@immutable
abstract class TransactionInquiryEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TransactionInquiryGetListEvent extends TransactionInquiryEvent {
  TransactionInquiryGetListEvent({required this.request, this.memo});

  final TransactionInquiryRequest request;
  final String? memo;
}

class TransactionInquiryGetDetailEvent extends TransactionInquiryEvent {
  TransactionInquiryGetDetailEvent({required this.code});

  final String code;
}
