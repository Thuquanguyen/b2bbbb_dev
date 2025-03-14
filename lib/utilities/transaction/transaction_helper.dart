import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/saving_account_model.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionHelper {
  static List<TransactionGrouped<T>>
      groupByDate<T extends TransactionBaseModel>(List<T> list,
          {String? memoSearch, bool? shouldSort, bool? sortAsc}) {
    DateFormat displayFormat =
        DateFormat('dd MMMM yyyy', AppTranslate().currentLanguage.locale);
    DateFormat serverFormat = DateFormat('M/d/yyyy h:mm:ss a');
    List<TransactionGrouped<T>> result = [];
    for (T element in list) {
      String? _memoSearch = memoSearch;
      String transactionDate = '';

      if (_memoSearch != null && _memoSearch.isNotEmpty) {
        if (element.memo?.contains(_memoSearch) == false) {
          continue;
        }
      }

      try {
        DateTime transactionDateTime =
            serverFormat.parse(element.createdDate ?? '');
        transactionDate = displayFormat.format(transactionDateTime);
      } catch (e) {}

      if (result.any((e) => e.date == transactionDate)) {
        result.firstWhere((e) => e.date == transactionDate).list.add(element);
      } else {
        result.add(TransactionGrouped(list: [element], date: transactionDate));
      }
    }

    List<TransactionGrouped<T>> sortedResult = [];
    for (TransactionGrouped<T> tg in result) {
      tg.list.sort((a, b) {
        try {
          int diff = serverFormat
              .parse(b.createdDate ?? '')
              .compareTo(serverFormat.parse(a.createdDate ?? ''));
          return diff;
        } catch (_) {
          return 1;
        }
      });
      sortedResult.add(tg);
    }

    sortedResult.sort((a, b) {
      try {
        int diff =
            displayFormat.parse(b.date).compareTo(displayFormat.parse(a.date));
        return diff;
      } catch (_) {
        return 1;
      }
    });

    return sortedResult;
  }

  static List<TransactionGrouped<SavingAccountModel>> groupSavingByDate(
      List<SavingAccountModel> list) {
    DateFormat displayFormat =
        DateFormat('dd MMMM yyyy', AppTranslate().currentLanguage.locale);
    List<TransactionGrouped<SavingAccountModel>> result = [];
    for (SavingAccountModel sa in list) {
      String transactionDate = '';

      try {
        DateTime transactionDateTime =
            DateFormat("dd/MM/yyyy").parse(sa.startDate ?? '');
        transactionDate = displayFormat.format(transactionDateTime);
      } catch (_) {}

      if (result.any((e) => e.date == transactionDate)) {
        result.firstWhere((e) => e.date == transactionDate).list.add(sa);
      } else {
        result.add(TransactionGrouped(list: [sa], date: transactionDate));
      }

      result.sort((a, b) {
        try {
          int diff = displayFormat
              .parse(b.date)
              .compareTo(displayFormat.parse(a.date));
          return diff;
        } catch (_) {
          return 1;
        }
      });
    }
    return result;
  }
}
