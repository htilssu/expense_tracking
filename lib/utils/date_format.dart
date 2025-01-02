import 'package:intl/intl.dart';

class Date {
  static final DateFormat _formatter = DateFormat('HH:mm dd/MM');

  static String format(DateTime date) {
    return _formatter.format(date);
  }
}
