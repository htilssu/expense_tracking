import 'package:expense_tracking/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('CurrencyFormatter', () {
    setUp(() {
      // Đảm bảo locale mặc định được thiết lập cho các test
      Intl.defaultLocale = 'vi';
    });

    test('formatCurrency trả về chuỗi định dạng tiền tệ đúng cho số dương', () {
      final result = CurrencyFormatter.formatCurrency(100000);
      expect(result, equals('100.000 ₫'));
    });

    test('formatCurrency trả về chuỗi định dạng tiền tệ đúng cho số 0', () {
      final result = CurrencyFormatter.formatCurrency(0);
      expect(result, equals('0 ₫'));
    });

    test('formatCurrency trả về chuỗi định dạng tiền tệ đúng cho số âm', () {
      final result = CurrencyFormatter.formatCurrency(-50000);
      expect(result, equals('-50.000 ₫'));
    });
  });
}
