import 'package:intl/intl.dart';

class Formatter {
  static String formatCurrency(double amount) {
    return NumberFormat.simpleCurrency(locale: 'vi').format(amount);
  }
}
