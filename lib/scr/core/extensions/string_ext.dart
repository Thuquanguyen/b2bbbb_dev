import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

extension ExtendedString on String {
  String mergeURLWithParam(Map<String, dynamic> params) {
    var _url = this;
    if (params.isNotEmpty && !_url.contains('?')) {
      _url += '?';
      params.forEach((String key, dynamic value) {
        _url += '$key=$value&';
      });
      _url.substring(0, _url.length - 1); // remove the '&' at the end of url
    }
    return _url;
  }

  String get localized {
    return AppTranslate().translate(this);
  }

  String get toDateString {
    return substring(6) + '/' + substring(4, 6) + '/' + substring(0, 4);
  }

  String get parseToDateString {
    if (length >= 14) {
      return substring(0, 4) +
          '/' +
          substring(4, 6) +
          '/' +
          substring(6, 8) +
          ' ' +
          substring(8, 10) +
          ':' +
          substring(10, 12) +
          ':' +
          substring(12, 14);
    }
    return '';
  }

  String get toProfileDateString {
    if (length >= 10) {
      return substring(3, 5) + '/' + substring(0, 2) + '/' + substring(6);
    }
    return '';
  }

  String toSentence() {
    return sentenceCase;
  }

  String toTitleCase() {
    return titleCase;
  }

  String interpolate(Map<String, dynamic> params) {
    String result = this;
    params.forEach((key, value) {
      result = result.replaceAll('%$key', value.toString());
    });
    return result;
  }

  bool isNumeric() {
    try {
      final value = double.parse(this);
      Logger.debug('value: $value');
    } on FormatException {
      return false;
    } finally {
      // ignore: control_flow_in_finally
      return true;
    }
  }

  String get toMoneyFormat {
    if (isNullOrEmpty) {
      return '';
    }
    var moneyRaw = replaceAll(' ', '').split('').reversed.toList();
    var money = moneyRaw;
    int intTime = moneyRaw.length ~/ 3;
    if (intTime > 0) {
      for (var i = 0; i < intTime; i++) {
        money.insert(((i + 1) * 3) + i, ' ');
      }
    }
    return money.reversed.join().trim();
  }

  String get formatToInt {
    return int.parse(replaceAll(' ', '')).toString();
  }

  String get formatDateString {
    if (AppTranslate().currentLanguage == SupportLanguages.Vi) {
      return replaceAll('D', ' ${AppTranslate.i18n.titleDayStr.localized}')
          .replaceAll('M', ' ${AppTranslate.i18n.monthStr.localized}');
    } else {
      if (this == '1D') {
        return '1 day';
      }
      if (this == '1M') {
        return '1 month';
      }
      return replaceAll('D', ' days').replaceAll('M', ' months');
    }
  }

  String get getLetterStartName {
    if (length == 1) return toUpperCase();
    String nameRaw = trim();
    var listName = nameRaw.split(' ');
    if (listName.length == 1) {
      return (listName[0][0] + listName[0][1]).toUpperCase();
    }
    return (listName[0][0] + listName[1][0]).toUpperCase();
  }

  String get onlyNumber {
    return replaceAll(RegExp('.*?[^0-9].*'), '');
  }
}

extension NullEmptyCheck on String? {
  bool get isNotNullAndEmpty {
    if (this != null && this?.isNotEmpty == true) {
      return true;
    }

    return false;
  }

  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}

extension ConvertDateTime on String? {
  DateTime? get convertServerTime {
    if (this != null && this?.isNotEmpty == true) {
      try {
        DateTime r = DateFormat("M/d/yyyy h:mm:ss a").parse(this!);
        return r;
      } catch (_) {
        try {
          DateTime r = DateFormat("MM/dd/yyyy HH:mm").parse(this!);
          return r;
        } catch (_) {
          return null;
        }
      }
    }

    return null;
  }
}

extension ExtendedNullableString on String? {
  String? get maskedCardNumber {
    if (this != null && this?.isNotEmpty == true) {
      return '${this?.substring(0, 4) ?? ''} •••• •••• ${this?.substring((this?.length ?? 4) - 4) ?? ''}';
    }

    return null;
  }
}
