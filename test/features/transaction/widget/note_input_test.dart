import 'package:expense_tracking/presentation/features/transaction/widget/note_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NoteInput Widget Tests', () {
    testWidgets('should display initial value correctly',
        (WidgetTester tester) async {
      const initialValue = 'Ghi chú ban đầu';
      String capturedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteInput(
              value: initialValue,
              onChanged: (newValue) {
                capturedValue = newValue;
              },
            ),
          ),
        ),
      );

      // Kiểm tra giá trị ban đầu được hiển thị đúng
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('should handle user input and call onChanged',
        (WidgetTester tester) async {
      String capturedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteInput(
              value: '',
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
      const newNote = 'Ghi chú mới cho giao dịch';
      await tester.enterText(textField, newNote);
      await tester.pump();

      // Kiểm tra giá trị đã được cập nhật trong callback
      expect(capturedValue, newNote);
    });

    testWidgets('should have correct decoration and styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteInput(
              value: '',
              onChanged: (newValue) {},
            ),
          ),
        ),
      );

      // Tìm TextField và kiểm tra các thuộc tính styling
      final textField = find.byType(TextField);
      final textFieldWidget = tester.widget<TextField>(textField);

      // Kiểm tra decoration có đúng không
      expect(textFieldWidget.decoration, isNotNull);

      // Kiểm tra maxLines để đảm bảo đây là trường nhập nhiều dòng
      expect(textFieldWidget.maxLines, isNot(equals(1)));
    });

    testWidgets('should handle empty input correctly',
        (WidgetTester tester) async {
      String capturedValue = 'initial';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteInput(
              value: capturedValue,
              onChanged: (newValue) {
                capturedValue = newValue;
              },
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị
      final textField = find.byType(TextField);

      // Xóa giá trị hiện tại
      await tester.enterText(textField, '');
      await tester.pump();

      // Kiểm tra giá trị đã được cập nhật là rỗng
      expect(capturedValue, '');
    });

    testWidgets('should handle long text input', (WidgetTester tester) async {
      String capturedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteInput(
              value: '',
              onChanged: (newValue) {
                capturedValue = newValue;
              },
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị
      final textField = find.byType(TextField);

      // Nhập một đoạn văn bản dài
      const longText =
          'Đây là một ghi chú dài để kiểm tra xem widget có xử lý văn bản dài đúng cách không. '
          'Ghi chú này bao gồm nhiều thông tin như ngày, thời gian, địa điểm và mục đích của giao dịch.';

      await tester.enterText(textField, longText);
      await tester.pump();

      // Kiểm tra giá trị đã được cập nhật đúng
      expect(capturedValue, longText);
    });
  });
}
