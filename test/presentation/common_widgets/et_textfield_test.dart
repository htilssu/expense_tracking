import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EtTextField Widget Tests', () {
    testWidgets('should display label correctly', (WidgetTester tester) async {
      const testLabel = 'Họ và tên';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: testLabel,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Kiểm tra label được hiển thị đúng
      expect(find.text(testLabel), findsOneWidget);
    });

    testWidgets('should display initial value correctly',
        (WidgetTester tester) async {
      const initialValue = 'Nguyễn Văn A';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: 'Họ và tên',
              initialValue: initialValue,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Kiểm tra giá trị ban đầu được hiển thị đúng
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes',
        (WidgetTester tester) async {
      String capturedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: 'Email',
              onChanged: (value) {
                capturedValue = value;
              },
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Nhập giá trị mới
      const newValue = 'test@example.com';
      await tester.enterText(textField, newValue);
      await tester.pump();

      // Kiểm tra giá trị đã được cập nhật trong callback
      expect(capturedValue, newValue);
    });

    testWidgets('should show error message when validation fails',
        (WidgetTester tester) async {
      const errorMessage = 'Email không hợp lệ';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: 'Email',
              validator: (value) {
                return value!.contains('@') ? null : errorMessage;
              },
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị không hợp lệ
      final textField = find.byType(TextField);

      // Nhập giá trị không hợp lệ
      await tester.enterText(textField, 'invalid-email');

      // Trigger validation bằng cách tap bên ngoài để mất focus
      await tester.tap(find.byType(Scaffold));
      await tester.pump();

      // Kiểm tra thông báo lỗi hiển thị
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should not show error message when validation passes',
        (WidgetTester tester) async {
      const errorMessage = 'Email không hợp lệ';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: 'Email',
              validator: (value) {
                return value!.contains('@') ? null : errorMessage;
              },
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Tìm TextField để nhập giá trị hợp lệ
      final textField = find.byType(TextField);

      // Nhập giá trị hợp lệ
      await tester.enterText(textField, 'valid@example.com');

      // Trigger validation bằng cách tap bên ngoài để mất focus
      await tester.tap(find.byType(Scaffold));
      await tester.pump();

      // Kiểm tra không có thông báo lỗi
      expect(find.text(errorMessage), findsNothing);
    });

    testWidgets('should toggle password visibility when isPassword is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: 'Mật khẩu',
              isPassword: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Kiểm tra ban đầu password được ẩn (obscureText = true)
      final textField = find.byType(TextField);
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.obscureText, true);

      // Kiểm tra có icon để toggle password visibility
      final visibilityIcon = find.byIcon(Icons.visibility);
      expect(visibilityIcon, findsOneWidget);

      // Tap vào icon để hiện password
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Kiểm tra sau khi tap, password được hiện (obscureText = false)
      final updatedTextField = tester.widget<TextField>(textField);
      expect(updatedTextField.obscureText, false);

      // Kiểm tra icon đã chuyển sang dạng visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should apply custom padding when provided',
        (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(20.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtTextField(
              label: 'Họ và tên',
              padding: customPadding,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Tìm widget Padding
      final padding = find.byType(Padding).first;
      final paddingWidget = tester.widget<Padding>(padding);

      // Kiểm tra padding tùy chỉnh được áp dụng
      expect(paddingWidget.padding, equals(customPadding));
    });
  });
}
