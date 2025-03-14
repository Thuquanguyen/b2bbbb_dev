part of 'commerce_bloc.dart';

class CommerceEvent {}

class ClearCommerceEvent extends CommerceEvent{}

class CommerceChangeFilterStatusEvent extends CommerceEvent {}

class CommerceUpdateFilterRequestEvent extends CommerceEvent {
  CommerceFilterRequest filterRequest;

  CommerceUpdateFilterRequestEvent(this.filterRequest);
}

class CommerceGetDataList extends CommerceEvent {
  CommerceFilterRequest? filterRequest;
  CommerceType? type;

  CommerceGetDataList({this.filterRequest, required this.type});
}

class CommerceGetContractListEvent extends CommerceEvent {
  String? refNumber;

  CommerceGetContractListEvent({this.refNumber});
}
