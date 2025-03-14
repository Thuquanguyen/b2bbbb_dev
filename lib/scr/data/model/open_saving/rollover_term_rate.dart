import 'package:b2b/utilities/logger.dart';
import 'package:intl/intl.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class RolloverTermRate {
  String? interestRate;
  String? startDate;
  String? endDate;
  double? amountInterestRate;

  RolloverTermRate(
      {this.interestRate, this.startDate, this.amountInterestRate});

  RolloverTermRate.fromJson(Map<String, dynamic> json) {
    interestRate = json['interest_rate']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    amountInterestRate = json['amount_interest_rate']?.toDouble();
  }

  String? getInterestRate() {
    if (interestRate == null) {
      return null;
    }
    return '$interestRate %';
  }

  String? getAmountInterestRate() {
    try {
      String tmp = '$amountInterestRate';
      Logger.debug('getAmountInterestRate $tmp');
      String ccy = tmp.substring(tmp.indexOf('.'));

      if (ccy == '.0') {
        ccy = '';
      }

      String vl = tmp.substring(0, tmp.indexOf('.'));
      return '${vl.toMoneyFormat} $ccy VND';
    } catch (e) {
      return '$amountInterestRate VND';
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['interest_rate'] = interestRate;
    data['start_date'] = startDate;
    data['endDate'] = endDate;
    data['amount_interest_rate'] = amountInterestRate;
    return data;
  }
}
