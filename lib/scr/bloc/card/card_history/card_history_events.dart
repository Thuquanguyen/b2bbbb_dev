import 'package:b2b/scr/data/model/card/card_history_request.dart';
import 'package:dio/dio.dart';

class CardHistoryEvents {}

class GetCardListEvent extends CardHistoryEvents {
  GetCardListEvent();
}

class GetCardHistoryEvent extends CardHistoryEvents {
  final CardHistoryRequestModel request;
  final CancelToken cancelToken;

  GetCardHistoryEvent({required this.request, required this.cancelToken});
}

class ClearGetCardHistoryEvent extends CardHistoryEvents {}

// class GetCardStatementEvent extends CardHistoryEvents {
//   final CardStatementRequestModel request;
//   final CancelToken cancelToken;
//
//   GetCardStatementEvent({required this.request, required this.cancelToken});
// }
//
// class GetCardStatementMonthEvent extends CardHistoryEvents {
//   final CancelToken cancelToken;
//
//   GetCardStatementMonthEvent({required this.cancelToken});
// }
//
// class ClearGetCardStatementEvent extends CardHistoryEvents {}
