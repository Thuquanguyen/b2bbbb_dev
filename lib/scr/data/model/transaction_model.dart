import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/utilities/text_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

enum TransactionStatus {
  WAI, //Waiting for approval
  WCF, //Waiting for confirmation
  APP, //Under Processing
  REJ, //Rejected by Approver,
  SUC, //Processed
  FAL, //Failed
  REV //Returned by Beneficiary’s Bank
}

extension TransactionStatusExt on TransactionStatus {
  String getValue() {
    switch (this) {
      case TransactionStatus.WAI:
        return 'WAI';
      case TransactionStatus.WCF:
        return 'WCF';
      case TransactionStatus.APP:
        return 'APP';
      case TransactionStatus.REJ:
        return 'REJ';
      case TransactionStatus.SUC:
        return 'SUC';
      case TransactionStatus.FAL:
        return 'FAL';
      case TransactionStatus.REV:
        return 'REV';
      default:
        return '';
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionMainModel extends TransactionBaseModel {
  TransactionMainModel({
    this.bankId,
    this.debitAccountBalance,
    this.debitAmount,
    this.debitAccountCcy,
    this.beneficiaryName,
    this.currency,
    this.status,
    this.benAccountName,
    this.benBranch,
    this.benBranchName,
    this.benBankName,
    this.benBankCode,
    this.benCcy,
    this.city,
    this.transactionType,
    this.amountInWords,
    this.exchangeRate,
    this.charges,
    this.vatFeeAmount,
    this.feeAmount,
    this.feeAmountCcy,
    this.approver,
    this.dateApprover,
    this.createdBy,
    this.createdDateTime,
    this.groupDate,
    this.chargesAccount,
    this.rejectCause,
    this.totalInhouse,
    this.totalOther,
  });

  String? bankId;
  double? debitAccountBalance;
  double? debitAmount;
  String? debitAccountCcy;
  String? beneficiaryName;
  String? currency;
  NameModel? status;
  String? benBankName;
  String? benBankCode;
  String? benAccountName;
  String? benBranch;
  String? benBranchName;
  String? benCcy;
  String? city;
  NameModel? transactionType;
  NameModel? amountInWords;
  double? exchangeRate;
  NameModel? charges;
  double? vatFeeAmount;
  double? feeAmount;
  String? feeAmountCcy;
  String? approver;
  String? dateApprover;
  String? createdBy;
  DateTime? createdDateTime;
  String? groupDate;
  String? chargesAccount;
  String? rejectCause;
  int? totalInhouse;
  int? totalOther;

  factory TransactionMainModel.fromJson(Map<String, dynamic> json) => _$TransactionMainModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionMainModelToJson(this);

  String _formatNumber({required double input, required String currency}) {
    String r = TransactionManage().formatCurrency(input, currency);
    return r;
  }

  String formattedAmount({bool withCurrency = false}) {
    String result = CurrencyInputFormatter.formatCcyString(amount.toString(), ccy: currency, removeDecimal: true);

    return result += (withCurrency ? (currency != null ? ' $currency' : '') : '');
  }

  String formattedFeeAmount({bool withCurrency = false}) {
    if ((vatFeeAmount ?? 0) == 0) return AppTranslate.i18n.freeAmountStr.localized;
    String r = _formatNumber(input: vatFeeAmount ?? 0, currency: feeAmountCcy ?? 'VND') + ' ';

    if (withCurrency) r += feeAmountCcy ?? '';

    return r;
  }

  String formattedDebitAmount({bool withCurrency = false}) {
    String r = _formatNumber(input: debitAmount ?? 0, currency: debitAccountCcy ?? 'VND') + ' ';

    if (withCurrency) r += debitAccountCcy ?? '';

    return r;
  }

  bool get isFreeCharge => vatFeeAmount == 0;

  bool get shouldShowBranchCity {
    switch (transactionType?.transactionType) {
      case TransactionType.INTERBANK:
      case TransactionType.SALARY_INTERBANK:
        return true;
      default:
        return false;
    }
  }

  bool get shouldShowChargeAccount {
    switch (charges?.chargeType) {
      case ChargeType.BEN:
        return false;
      default:
        return true;
    }
  }

  bool get isCardPayment {
    return (transactionType?.transactionType == TransactionType.CARD_PAYMENT &&
            benAccountName?.contains("C") == false) ||
        benAccountName?.contains("xxxx") == true;
  }

  String get exchangeRateFormated {
    return '${(exchangeRate ?? 0) > 999 ? TransactionManage().tryFormatCurrency(exchangeRate, 'VND') : (exchangeRate ?? 0)}';
  }
}

class TransactionGrouped<T> {
  final List<T> list;
  final String date;

  TransactionGrouped({required this.list, required this.date});
}
