import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(double amount) {
    return NumberFormat.simpleCurrency(locale: 'vi').format(amount);
  }
}
