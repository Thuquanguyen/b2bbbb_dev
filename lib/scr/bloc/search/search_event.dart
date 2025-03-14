class SearchEvent {
  String? keyWord;

  SearchEvent({this.keyWord});
}

class SearchClearStateEvent extends SearchEvent {}

class SearchBenListEvent extends SearchEvent {
  int transferTypeOfCode;

  SearchBenListEvent({this.transferTypeOfCode = -1});
}

class SearchBankListEvent extends SearchEvent {
  int? transferTypeOfCode;

  SearchBankListEvent({this.transferTypeOfCode = -1});
}

class SearchLocationEvent extends SearchEvent {}

class SearchBranchListEvent extends SearchEvent {
  final String bankCode;
  final String cityCode;

  SearchBranchListEvent({this.bankCode = '', this.cityCode = ''});
}
