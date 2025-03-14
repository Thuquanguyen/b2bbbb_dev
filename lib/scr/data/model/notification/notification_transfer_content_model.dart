import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../presentation/screens/account_service/transaction_manage.dart';

part 'notification_transfer_content_model.g.dart';

enum NotiTransferType { TRANSFER, SAVING, PAYROLL, BILL }

extension NotiTransferTypeExt on NotiTransferType {
  String getValue() {
    switch (this) {
      case NotiTransferType.TRANSFER:
        return 'transfer';
      case NotiTransferType.SAVING:
        return 'saving';
      case NotiTransferType.PAYROLL:
        return 'payroll';
      case NotiTransferType.BILL:
        return 'billing';
      default:
        return 'transfer';
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationTransferContentModel {
  String? bankId;
  double? amount;
  String? userAppr;
  String? status;
  String? functionType;
  String? dateAction;
  String? dateReceive;
  String? userReceive;
  String? memo;
  String? transCode;
  DateTime? timeInDateTime;
  String? debitCcy;
  String? debitAccount;
  bool? hasRead;
  String? id;

  NotificationTransferContentModel(
      {this.bankId,
      this.amount,
      this.userAppr,
      this.status,
      this.functionType,
      this.dateAction,
      this.dateReceive,
      this.memo,
      this.transCode,
      this.hasRead,
      this.userReceive,
      this.debitAccount,
      this.debitCcy,
      this.id});

  factory NotificationTransferContentModel.fromJson(
          Map<String, dynamic> json) =>
      _$NotificationTransferContentModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificationTransferContentModelToJson(this);

  NotificationTransferContentModel copyWith({bool? hasRead}) {
    return NotificationTransferContentModel(
        bankId: bankId,
        amount: amount,
        userAppr: userAppr,
        status: status,
        functionType: functionType,
        userReceive: userReceive,
        memo: memo,
        transCode: transCode,
        dateAction: dateAction,
        hasRead: hasRead ?? this.hasRead,
        debitAccount: debitAccount,
        debitCcy: debitCcy,
        id: id);
  }

  String timeInFormat() {
    try {
      if (dateAction?.isNotEmpty ?? false) {
        int timeAction = double.parse(dateAction ?? '0').toInt();
        timeInDateTime ??= DateTime.fromMillisecondsSinceEpoch(timeAction);
        return AppUtils.getDateTimeTitle(timeInDateTime!);
      }
    } catch (e) {
      Logger.debug(e.toString());
    }
    return '';
  }

  String hoursInFormat() {
    try {
      if (dateAction?.isNotEmpty ?? false) {
        int timeAction = double.parse(dateAction ?? '0').toInt();
        timeInDateTime ??= DateTime.fromMillisecondsSinceEpoch(timeAction);
        return AppUtils.getDateTimeInFormat(timeInDateTime!, 'HH:mm');
      }
    } catch (e) {
      Logger.debug(e.toString());
    }
    return '';
  }

  String getSavingMemo() {
    Logger.debug('getSavingMemo $memo');
    if (memo == 'saving_open') {
      return AppTranslate.i18n.openOnlineDepositsStr.localized;
    } else if (memo == 'saving_close') {
      return AppTranslate.i18n.cddsFinalSettlementTitleStr
          .localized; //cdds_final_settlement_title
    } else {
      return memo ?? '';
    }
  }

  String getMemo() {
    final balance = TransactionManage()
        .formatCurrency((amount ?? 0).toDouble(), debitCcy ?? 'VND');

    if (NotiTransferType.SAVING.getValue() == functionType) {
      return AppTranslate.i18n.notiSavingContentStr.localized.interpolate(
        {
          'amount': balance,
          'ccy': debitCcy,
          'content': getSavingMemo(),
        },
      );
    } else if (NotiTransferType.BILL.getValue() == functionType) {
      return AppTranslate.i18n.notiBillContentStr.localized.interpolate(
        {
          'amount': balance,
          'ccy': debitCcy,
        },
      );
    }

    return AppTranslate.i18n.notiTransferContentStr.localized.interpolate(
      {'amount': balance, 'ccy': debitCcy, 'content': memo},
    );
  }

  String getDialogMessage() {
    final balance = TransactionManage()
        .formatCurrency((amount ?? 0).toDouble(), debitCcy ?? 'VND');

    if (NotiTransferType.BILL.getValue() == functionType) {
      return AppTranslate.i18n.messageBillNotiStr.localized.interpolate({
        'account': '$debitAccount',
        'title': AppTranslate.i18n.tasTdAmountStr.localized,
        'balance': '-$balance $debitCcy',
        'color': 'red',
      });
    } else {
      return AppTranslate.i18n.messageContentNotiStr.localized.interpolate({
        'account': '$debitAccount',
        'title': AppTranslate.i18n.tasTdAmountStr.localized,
        'balance': '-$balance $debitCcy',
        'content': '$memo',
        'color': 'red',
      });
    }
  }
}
