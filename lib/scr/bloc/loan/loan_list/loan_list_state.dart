part of 'loan_list_bloc.dart';

class LoanListState extends Equatable {
  DataState? getLoanListDataState;
  List<LoanListModel>? loanLists;
  String? errorMessage;
  LoanDetailState? loanDetailState;

  LoanListState({
    this.getLoanListDataState,
    this.loanLists,
    this.errorMessage,
    this.loanDetailState,
  });

  LoanListState copyWith({
    DataState? getLoanListDataState,
    List<LoanListModel>? loanLists,
    String? errorMessage,
    DataState? loanInfoDataState,
    LoanDetailInfo? loanDetailInfo,
    LoanDetailState? loanDetailState,
  }) {
    return LoanListState(
      getLoanListDataState: getLoanListDataState ?? this.getLoanListDataState,
      loanLists: loanLists ?? this.loanLists,
      errorMessage: errorMessage ?? this.errorMessage,
      loanDetailState: loanDetailState ?? this.loanDetailState,
    );
  }

  @override
  List<Object?> get props => [
        getLoanListDataState,
        loanLists,
        loanDetailState,
      ];
}

class LoanDetailState extends Equatable {
  final DataState? loanInfoDataState;
  final LoanDetailInfo? loanDetailInfo;
  final String? errorMessage;
  DataState? exportLoanDataState;
  String? exportLoanData;

  LoanDetailState(
      {this.loanInfoDataState,
      this.loanDetailInfo,
      this.errorMessage,
      this.exportLoanDataState,
      this.exportLoanData});

  LoanDetailState copyWith({
    DataState? loanInfoDataState,
    LoanDetailInfo? loanDetailInfo,
    String? errorMessage,
    DataState? exportLoanDataState,
    String? exportLoanData,
  }) {
    return LoanDetailState(
      loanInfoDataState: loanInfoDataState ?? this.loanInfoDataState,
      loanDetailInfo: loanDetailInfo ?? this.loanDetailInfo,
      errorMessage: errorMessage ?? this.errorMessage,
      exportLoanData: exportLoanData ?? this.exportLoanData,
      exportLoanDataState: exportLoanDataState ?? this.exportLoanDataState,
    );
  }

  @override
  List<Object?> get props => [
        loanInfoDataState,
        loanDetailInfo,
        errorMessage,
        exportLoanDataState,
        exportLoanData
      ];
}
