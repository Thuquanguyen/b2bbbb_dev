import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String getFeeAccountDisplay(String? accountNumber, String? currency) {
    if (accountNumber.isNullOrEmpty) {
      return '';
    }
    if (currency.isNullOrEmpty) {
      return accountNumber!;
    }
    return '$currency - $accountNumber';
  }

  // VN : 17 thang 10, 2021
  // EN : 17 Oct, 2021
  static List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String getDateTimeTitle(DateTime dateTime) {
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;

    String monthStr = AppTranslate().currentLanguage == SupportLanguages.Vi
        ? '${AppTranslate.i18n.monthStr.localized} $month'
        : months[month - 1];
    return '$day $monthStr, $year';
  }

  static String getDateTimeInFormat(DateTime dateTime, String format) {
    try {
      DateFormat df = DateFormat(format, AppTranslate().currentLanguage.locale);
      return df.format(dateTime);
    } catch (e) {
      print(e);
    }
    return '';
  }

  static T? tryCast<T>(dynamic x, {T? defaultValue}) {
    try {
      return (x as T);
    } catch (_) {
      return defaultValue;
    }
  }
}
