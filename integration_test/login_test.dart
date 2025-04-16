import 'package:expense_tracking/main.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/login_screen.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

      // Đợi để ứng dụng hiển thị màn hình đăng nhập
      await tester.pumpAndSettle();

      // Tìm EtTextField cho email và password thông qua label
      final emailTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Tên đăng nhập');
      final passwordTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Mật khẩu');

      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      // Nhập email hợp lệ
      await tester.enterText(emailTextField, 'testhihi@gmail.com');
      // Nhập mật khẩu hợp lệ
      await tester.enterText(passwordTextField, 'Test@2004');

      // Nhấn nút "Đăng nhập"
      final loginButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          (widget.child is Text && (widget.child as Text).data == 'Đăng nhập'));
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);

      // Đợi quá trình đăng nhập hoàn tất và chuyển màn hình
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Kiểm tra không còn màn hình login nữa
      expect(find.byType(LoginScreen), findsNothing);

      // Kiểm tra không có lỗi hiển thị
      expect(find.text('Người dùng không tồn tại'), findsNothing);
      expect(find.text('Mật khẩu không đúng'), findsNothing);
    });

    // Test trường hợp email để trống
    testWidgets('should show error when email is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Tìm EtTextField cho password
      final passwordTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Mật khẩu');

      // Để trống email, nhập mật khẩu
      await tester.enterText(passwordTextField, 'password123');

      // Nhấn nút "Đăng nhập"
      final loginButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          (widget.child is Text && (widget.child as Text).data == 'Đăng nhập'));

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Tên đăng nhập không được để trống'), findsOneWidget);
    });

    // Test trường hợp mật khẩu để trống
    testWidgets('should show error when password is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Tìm EtTextField cho email
      final emailTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Tên đăng nhập');

      // Nhập email, để trống mật khẩu
      await tester.enterText(emailTextField, 'test@example.com');

      // Nhấn nút "Đăng nhập"
      final loginButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          (widget.child is Text && (widget.child as Text).data == 'Đăng nhập'));

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu không được để trống'), findsOneWidget);
    });

    // Test trường hợp người dùng không tồn tại
    testWidgets('should show error when user not found',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Tìm EtTextField cho email và password
      final emailTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Tên đăng nhập');
      final passwordTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Mật khẩu');

      // Nhập thông tin không tồn tại
      await tester.enterText(emailTextField, 'unknown@example.com');
      await tester.enterText(passwordTextField, 'password123');

      // Nhấn nút "Đăng nhập"
      final loginButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          (widget.child is Text && (widget.child as Text).data == 'Đăng nhập'));

      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

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
