import 'package:common_utils/common_utils.dart';
import 'package:intl/intl.dart';

class MyDateUtils {
  static formatDate(final datetime) {
    if (TextUtil.isEmpty(datetime)) return "-";
    try {
      return DateFormat.yMMMd().format(DateTime.parse(datetime));
    } on FormatException catch (_) {
      return datetime;
    }
  }
}
