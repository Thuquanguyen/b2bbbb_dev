import 'package:intl/intl.dart';

extension DateTimeConvert on DateTime? {
  String? get to24H {
    if (this != null) {
      return DateFormat('Hm').format(this!);
    }

    return null;
  }

  String? get toDateTime {
    if (this != null) {
      return DateFormat('dd/MM/yyyy HH:mm').format(this!);
    }

    return null;
  }
}