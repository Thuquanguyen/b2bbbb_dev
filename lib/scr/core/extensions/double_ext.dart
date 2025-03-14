import 'package:b2b/utilities/text_formatter.dart';

extension FormatWithCurrency on double? {
  String getFormattedWithCurrency(String? currencyCode, {bool? showCurrency}) {
    String res = currencyCode == 'VND'
        ? CurrencyInputFormatter.formatVNNumber(this ?? 0)
        : CurrencyInputFormatter.formatUSNumber(this ?? 0, false);
    if (showCurrency == true) res += ' $currencyCode';
    return res;
  }
}
