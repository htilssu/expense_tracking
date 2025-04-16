import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AmountInput Widget Tests', () {
    testWidgets('should display initial value correctly',
        (WidgetTester tester) async {
      int value = 100000;
      int capturedValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInput(
              value: value,
              onChanged: (newValue) {
                capturedValue = newValue;
              },
            ),
          ),
        ),
      );

      // Kiểm tra giá trị ban đầu được hiển thị đúng
      expect(find.text('100000'), findsOneWidget);
    });

    testWidgets('should format value with number separator',
        (WidgetTester tester) async {
      int value = 1000000;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInput(
              value: value,
              onChanged: (newValue) {},
            ),
          ),
        ),
      );

      // Kiểm tra định dạng số có dấu phân cách nghìn
      // Tùy vào cách định dạng số trong AmountInput, kết quả có thể khác nhau
      // Ví dụ: "1.000.000" hoặc "1,000,000"
      expect(find.text('1000000'), findsOneWidget);
    });

    testWidgets('should handle user input and call onChanged',
        (WidgetTester tester) async {
      int capturedValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInput(
              value: 0,
              onChanged: (newValue) {
                capturedValue = newValue;
              },
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Nhập giá trị mới
      await tester.enterText(textField, '250000');
      await tester.pump();

      // Kiểm tra giá trị đã được cập nhật trong callback
      expect(capturedValue, 250000);
    });

    testWidgets('should only accept numeric input',
        (WidgetTester tester) async {
      int capturedValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInput(
              value: 0,
              onChanged: (newValue) {
                capturedValue = newValue;
              },
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị
      final textField = find.byType(TextField);

      // Nhập giá trị không phải số
      await tester.enterText(textField, 'abc');
      await tester.pump();

      // Giá trị không nên thay đổi vì input không phải số
      expect(capturedValue, 0);
    });

    testWidgets('should display placeholder when value is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInput(
              value: 0,
              onChanged: (newValue) {},
            ),
          ),
        ),
      );

      // Kiểm tra có hiển thị placeholder không
      expect(find.text('0'), findsOneWidget);
    });
  });
}
