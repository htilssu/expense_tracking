import 'package:expense_tracking/main.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/login_screen.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    },
  );

  group('LoginScreen Integration Tests', () {
    // Test trường hợp đăng nhập thành công
    testWidgets('should login successfully with valid credentials',
        (WidgetTester tester) async {
      // Khởi động ứng dụng hoặc màn hình cụ thể
      await tester.pumpWidget(const MyApp());

      // Nhập email hợp lệ
      await tester.enterText(
          find.byType(TextField).at(0), 'testhihi@gmail.com');
      // Nhập mật khẩu hợp lệ
      await tester.enterText(find.byType(TextField).at(1), 'Test@2004');

      // Nhấn nút "Đăng nhập"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle(); // Chờ UI cập nhật

      // Kiểm tra không có lỗi hiển thị (giả sử đăng nhập thành công chuyển màn hình hoặc không có thông báo lỗi)
      expect(find.text('Người dùng không tồn tại'), findsNothing);
      expect(find.text('Mật khẩu không đúng'), findsNothing);
    });

    // Test trường hợp email để trống
    testWidgets('should show error when email is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Để trống email, nhập mật khẩu
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      // Nhấn nút "Đăng nhập"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Tên đăng nhập không được để trống'), findsOneWidget);
    });

    // Test trường hợp mật khẩu để trống
    testWidgets('should show error when password is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Nhập email, để trống mật khẩu
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');

      // Nhấn nút "Đăng nhập"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu không được để trống'), findsOneWidget);
    });

    // Test trường hợp người dùng không tồn tại
    testWidgets('should show error when user not found',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Nhập thông tin không tồn tại
      await tester.enterText(
          find.byType(TextField).at(0), 'unknown@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      // Nhấn nút "Đăng nhập"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi từ UserNotFoundException
      expect(find.text('Người dùng không tồn tại'), findsOneWidget);
    });

    // Test chuyển hướng sang RegisterScreen
    testWidgets('should navigate to RegisterScreen when clicking register link',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(TextButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra xem RegisterScreen đã được hiển thị
      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });
}
