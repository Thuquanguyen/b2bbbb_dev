import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'loan_statement_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoanStatementModel {
  String? transactionDate;
  String? transactionType;
  double? disbursementAmount;
  double? principleRepayment;
  double? overduePrinciple;
  double? interestRepayment;
  double? overdueInterest;
  double? overdueFee;

  LoanStatementModel({
    this.transactionDate,
    this.transactionType,
    this.disbursementAmount,
    this.principleRepayment,
    this.overduePrinciple,
    this.interestRepayment,
    this.overdueInterest,
    this.overdueFee,
  });

  factory LoanStatementModel.fromJson(Map<String, dynamic> json) => _$LoanStatementModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoanStatementModelToJson(this);

  LoanStatementAmount? get theAmount {
    if ((disbursementAmount ?? 0) != 0) {
      return LoanStatementAmount(
        title: NameModel(
          valueVi: 'Giải ngân gốc',
          valueEn: 'Disbursement amount',
        ),
        amount: disbursementAmount!,
      );
    }

    if ((principleRepayment ?? 0) != 0) {
      return LoanStatementAmount(
        title: NameModel(
          valueVi: 'Thu nợ gốc trong hạn',
          valueEn: 'Principle repayment',
        ),
        amount: principleRepayment!,
      );
    }

    if ((overduePrinciple ?? 0) != 0) {
      return LoanStatementAmount(
        title: NameModel(
          valueVi: 'Thu nợ gốc quá hạn',
          valueEn: 'Overdue principle repayment',
        ),
        amount: overduePrinciple!,
      );
    }

    if ((interestRepayment ?? 0) != 0) {
      return LoanStatementAmount(
        title: NameModel(
          valueVi: 'Thu nợ lãi trong hạn',
          valueEn: 'Interest repayment',
        ),
        amount: interestRepayment!,
      );
    }

    if ((overdueInterest ?? 0) != 0) {
      return LoanStatementAmount(
        title: NameModel(
          valueVi: 'Thu nợ lãi quá hạn',
          valueEn: 'Overdue interest repayment',
        ),
        amount: overdueInterest!,
      );
    }

    if ((overdueFee ?? 0) != 0) {
      return LoanStatementAmount(
        title: NameModel(
          valueVi: 'Thu nợ lãi phạt quá hạn',
          valueEn: 'Overdue fee repayment',
        ),
        amount: overdueFee!,
      );
    }

    return null;
  }
}

class LoanStatementAmount {
  NameModel title;
  double amount;

  LoanStatementAmount({
    required this.title,
    required this.amount,
  });
}

class LoanStatementGrouped {
  String date;
  List<LoanStatementModel> list;

  LoanStatementGrouped({
    required this.date,
    required this.list,
  });
}
