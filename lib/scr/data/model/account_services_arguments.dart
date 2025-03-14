import 'package:b2b/scr/data/model/account_service/account_model.dart';

class AccountServicesArguments {
  AccountServicesArguments(this.screenType,
      {this.dateFrom,
      this.dateTo,
      this.amountFrom,
      this.amountTo,
      this.memo,
      this.accountInfo,
      this.accountType,
      this.callBack});

  final String screenType;
  final String? dateFrom;
  final String? accountType;
  final String? dateTo;
  final double? amountFrom;
  final double? amountTo;
  final String? memo;
  final Function? callBack;

  final AccountInfo? accountInfo;
}
