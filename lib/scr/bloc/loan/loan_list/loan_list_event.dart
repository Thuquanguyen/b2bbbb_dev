part of 'loan_list_bloc.dart';

@immutable
abstract class LoanListEvent {}

class GetLoanListEvent extends LoanListEvent {}

class GetLoanDetailEvent extends LoanListEvent {
  String contractId;

  GetLoanDetailEvent(this.contractId);
}

class ExportLoan extends LoanListEvent {
  VPShareFile fileType;

  ExportLoan(this.fileType);
}
