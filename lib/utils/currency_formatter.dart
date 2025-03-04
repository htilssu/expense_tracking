import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(int amount) {
    return NumberFormat.simpleCurrency(locale: 'vi').format(amount);
  }
}
