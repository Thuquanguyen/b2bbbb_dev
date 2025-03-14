import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:intl/intl.dart';

class TransactionManager {
  factory TransactionManager() => _instance;

  TransactionManager._();

  static final _instance = TransactionManager._();

  List<Object> getTransactionManagerDisplayList(List<TransactionMainModel> data) {
    //convert date
    // DateF format = DateFormat("yyyy-MM-dd");
    // DateTime.parse('1974-03-20 00:00:00.000')
    try {
      for (var element in data) {
        DateTime createdDateTime = DateFormat('M/d/yyyy h:mm:ss a').parse(element.createdDate ?? '');
        element.createdDateTime = createdDateTime;
        // int day = createdDateTime.day;
        // int month = createdDateTime.month;
        // int year = createdDateTime.year;
        //
        // element.groupDate = '$day ${AppTranslate.i18n.monthStr.localized} $month, $year';
        element.groupDate = AppUtils.getDateTimeTitle(createdDateTime);

        // 17 thang 10, 2021
        //17 Oct, 2021
      }
    } catch (e) {
      Logger.debug("Exception $e");
    }
    //sort list
    data.sort((a, b) {
      if (a.createdDateTime == null || b.createdDateTime == null || a.createdDateTime == b.createdDateTime) {
        return 0;
      } else {
        return b.createdDateTime!.compareTo(a.createdDateTime!);
      }
    });
    //group date
    List<Object> result = [];
    Map<String, bool> mark = {};
    for (int i = 0; i < data.length; i++) {
      final element = data[i];
      String groupDate = element.groupDate ?? '';
      if (mark[groupDate] != true) {
        mark[groupDate] = true;
        result.add(groupDate);
      }
      result.add(element);
    }
    return result;
  }
}
