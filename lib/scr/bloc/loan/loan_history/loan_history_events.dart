class LoanHistoryEvents {}

class GetLoanHistoryEvent extends LoanHistoryEvents {
  final String contractNumber;
  final String? fromDate;
  final String? toDate;

  GetLoanHistoryEvent({required this.contractNumber, this.fromDate, this.toDate});
}

class ClearLoanHistoryEvent extends LoanHistoryEvents {}
