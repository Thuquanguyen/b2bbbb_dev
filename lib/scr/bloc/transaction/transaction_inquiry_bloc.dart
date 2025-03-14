import 'dart:async';
import 'dart:developer';

import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/data/model/transaction_inquiry_request.dart';
import 'package:b2b/scr/data/repository/transaction_repository.dart';
import 'package:b2b/utilities/transaction/transaction_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'transaction_inquiry_event.dart';
part 'transaction_inquiry_state.dart';

class TransactionInquiryBloc
    extends Bloc<TransactionInquiryEvent, TransactionInquiryState> {
  TransactionInquiryBloc({required this.transactionRepository})
      : super(const TransactionInquiryState());

  final TransactionRepositoryImpl transactionRepository;

  @override
  Stream<TransactionInquiryState> mapEventToState(
      TransactionInquiryEvent event) async* {
    if (event is TransactionInquiryGetListEvent) {
      yield* mapGetListState(event);
    } else if (event is TransactionInquiryGetDetailEvent) {
      yield* mapGetDetailState(event);
    } else {
      log('No event matched ${event.toString()}');
    }
  }

  Stream<TransactionInquiryState> mapGetListState(
    TransactionInquiryGetListEvent event,
  ) async* {
    yield const TransactionInquiryState(
      listState: TransactionInquiryListState(
        dataState: DataState.preload,
      ),
    );

    try {
      BaseResponseModel<TransactionMainModel> responseData =
          await transactionRepository.getTransactionList(event.request);
      String? code = responseData.result?.code;
      if (code == '200' || code == '0') {
        List<TransactionMainModel> list = responseData.toArrayModel(
          (json) => TransactionMainModel.fromJson(json),
        );
        yield TransactionInquiryState(
          listState: TransactionInquiryListState(
            list: TransactionHelper.groupByDate(list, memoSearch: event.memo),
            dataState: DataState.data,
          ),
        );
      } else {
        yield TransactionInquiryState(
          listState: TransactionInquiryListState(
            dataState: DataState.error,
            errorMessage: responseData.result?.getMessage(),
          ),
        );
      }
    } catch (e) {
      yield const TransactionInquiryState(
        listState: TransactionInquiryListState(
          dataState: DataState.error,
        ),
      );
    }
  }

  Stream<TransactionInquiryState> mapGetDetailState(
    TransactionInquiryGetDetailEvent event,
  ) async* {
    yield state.copyWith(
      detailState: const TransactionInquiryDetailState(
        dataState: DataState.preload,
      ),
    );

    try {
      BaseResponseModel<TransactionMainModel> responseData =
          await transactionRepository.getTransactionDetail(event.code);
      String? code = responseData.result?.code;
      if (code == '200') {
        yield state.copyWith(
          detailState: TransactionInquiryDetailState(
            data: responseData.toModel(
              (json) => TransactionMainModel.fromJson(json),
            ),
            dataState: DataState.data,
          ),
        );
      } else {
        yield state.copyWith(
          detailState: TransactionInquiryDetailState(
            dataState: DataState.error,
            errorMessage: responseData.result?.getMessage(),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        detailState: const TransactionInquiryDetailState(
          dataState: DataState.error,
        ),
      );
    }
  }
}
