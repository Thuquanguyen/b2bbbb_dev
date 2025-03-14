import 'dart:math';

import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:b2b/utilities/text_formatter.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final String? currency;

  CurrencyInputFormatter({required this.currency});

  static String formatVNNumber(double input) {
    String newText =
        NumberFormat('#,##0', 'en_US').format(input).replaceAll(',', ' ');
    return newText;
  }

  static String formatVNNumberFromString(String input) {
    if (input.isEmpty) return '';
    double value =
        double.tryParse(input.replaceAll(' ', '').replaceAll(',', '')) ?? 0;
    return formatVNNumber(value);
  }

  static String formatUSNumber(double input, bool hasDecimal) {
    String newText =
        NumberFormat(hasDecimal ? '#,##0.0#' : '#,##0', 'en_US').format(input);
    return newText;
  }

  static String formatUSNumberFromString(String input) {
    if (input.isEmpty) return '';
    if (input.endsWith('.')) return input;
    double value =
        double.tryParse(input.replaceAll(' ', '').replaceAll(',', '')) ?? 0;
    return formatUSNumber(value, input.contains('.'));
  }

  //1234.0234 => 1,234.0234
  static formatCcyString(String amount,
      {String? ccy = 'VND',
      bool removeDecimal = false,
      int maxDecimalDigits = 2,
      bool isTextInput = false}) {
    if ((ccy ?? 'VND') == 'VND' || ccy == 'JPY' || !amount.contains('.')) {
      if (amount.endsWith('.0')) {
        amount = amount.replaceAll('.0', '');
      }
      return amount.toMoneyFormat;
    }

    String input = amount.substring(
      0,
      min(amount.length, amount.lastIndexOf('.') + maxDecimalDigits + 1),
    );

    if (input.endsWith('.')) {
      return input;
    }
    double value =
        double.tryParse(input.replaceAll(',', '').replaceAll(' ', '')) ?? 0;

    if (value == 0) {
      return '';
    }

    int decimalDigits = input.contains('.')
        ? input.substring(input.lastIndexOf('.')).length - 1
        : 0;

    String result =
        NumberFormat.currency(locale: 'en_US', decimalDigits: decimalDigits)
            .format(value)
            .replaceAll('USD', '')
            .replaceAll(',', ' ');

    if (result.endsWith('.0') && removeDecimal) {
      result = result.replaceAll('.0', '');
    }
    if (isTextInput != true &&
        result.contains('.') &&
        result.substring(result.lastIndexOf('.')).length == maxDecimalDigits) {
      result = '${result}0';
    }

    Logger.debug('formatCcyString result $result');
    return result;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0 || newValue.text.endsWith('.')) {
      return newValue;
    }

    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;
    String newText = '';

    if (currency == 'VND') {
      newText = formatVNNumberFromString(newValue.text);
    } else {
      newText = formatUSNumberFromString(newValue.text);
    }

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
            offset: newText.length - selectionIndexFromTheRight));
  }
}
