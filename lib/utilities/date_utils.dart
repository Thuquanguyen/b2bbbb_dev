import 'package:intl/intl.dart';

class VpDateUtils {
  // from "2011-04-27T00:00:00" => '07/11/2017'
  static String getDisplayDateTime(String? dateTimeInput) {
    try {
      DateTime dateTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateTimeInput ?? '');
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
