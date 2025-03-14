import 'package:dio/dio.dart';

class CardInfoEvents {}

class GetCardInfoEvent extends CardInfoEvents {
  // final CancelToken cancelToken;
  final String contractId;

  GetCardInfoEvent({
    // required this.cancelToken,
    required this.contractId,
  });
}

class ClearCardInfoEvents extends CardInfoEvents {}
