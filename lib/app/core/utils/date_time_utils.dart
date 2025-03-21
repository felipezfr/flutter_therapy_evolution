import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formateDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formateDateWithWeekName(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm - EEEE').format(date);
  }

  static String dayOfTheWeekName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
}
