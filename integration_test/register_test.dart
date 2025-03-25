import 'package:expense_tracking/main.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(); // Initialize real Firebase
    await FirebaseAuth.instance.signOut(); // Ensure clean state
  });

  group('RegisterScreen Integration Tests', () {
    // Test trường hợp đăng ký thành công
    testWidgets('should register successfully with valid credentials', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );
      final uniqueEmail = 'test${DateTime.now().millisecondsSinceEpoch}@gmail.com';
      await tester.enterText(find.byType(TextField).at(0), uniqueEmail);
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.enterText(find.byType(TextField).at(2), 'Password123!');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle(const Duration(seconds: 5)); // Wait for Firebase

      // Kiểm tra không có lỗi hiển thị và màn hình đã pop (giả sử đăng ký thành công quay lại LoginScreen)
      expect(find.text('Email đã tồn tại, vui lòng chọn email khác'), findsNothing);
      expect(find.byType(RegisterScreen), findsNothing); // Should navigate back
    });

    // Test trường hợp email không hợp lệ
    testWidgets('should show error when email is invalid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập email không hợp lệ
      await tester.enterText(find.byType(TextField).at(0), 'invalid-email');
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.enterText(find.byType(TextField).at(2), 'Password123!');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Email không đúng định dạng'), findsOneWidget);
    });

    // Test trường hợp mật khẩu yếu
    testWidgets('should show error when password is weak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập mật khẩu ngắn
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'pass');
      await tester.enterText(find.byType(TextField).at(2), 'pass');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
    });

    // Test trường hợp mật khẩu không có ký tự chữ thường
    testWidgets('should show error when password is weak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập mật khẩu ngắn
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), '123456A@');
      await tester.enterText(find.byType(TextField).at(2), '123456A@');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu phải có ít nhất 1 chữ hoa, 1 số, 1 ký tự đặc biệt'), findsOneWidget);
    });
    // Test trường hợp mật khẩu không có ký tự chữ hoa
    testWidgets('should show error when password is weak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập mật khẩu ngắn
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), '123456a@');
      await tester.enterText(find.byType(TextField).at(2), '123456a@');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu phải có ít nhất 1 chữ hoa, 1 số, 1 ký tự đặc biệt'), findsOneWidget);
    });

    // Test trường hợp mật khẩu không có ký tự đặc biệt
    testWidgets('should show error when password is weak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập mật khẩu ngắn
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), '123456Aa');
      await tester.enterText(find.byType(TextField).at(2), '123456Aa');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu phải có ít nhất 1 chữ hoa, 1 số, 1 ký tự đặc biệt'), findsOneWidget);
    });
    // Test trường hợp mật khẩu không có ký tự số
    testWidgets('should show error when password is weak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập mật khẩu ngắn
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'ahihihiA@');
      await tester.enterText(find.byType(TextField).at(2), 'ahihihiA@');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validator
      expect(find.text('Mật khẩu phải có ít nhất 1 chữ hoa, 1 số, 1 ký tự đặc biệt'), findsOneWidget);
    });

    // Test trường hợp mật khẩu không khớp
    testWidgets('should show error when passwords do not match', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập mật khẩu không khớp
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.enterText(find.byType(TextField).at(2), 'Password1234!');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      expect(find.text('Mật khẩu không khớp'), findsOneWidget);
    });

    // Test trường hợp email đã tồn tại (sử dụng toandong2004@gmail.com)
    testWidgets('should show error when email already exists', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhập email đã tồn tại: toandong2004@gmail.com
      await tester.enterText(find.byType(TextField).at(0), 'toandong2004@gmail.com');
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.enterText(find.byType(TextField).at(2), 'Password123!');

      // Nhấn nút "Đăng ký"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Kiểm tra thông báo lỗi từ EmailExistException
      expect(find.text('Email đã tồn tại, vui lòng chọn email khác'), findsOneWidget);
    });
    // Test trường hợp email để trống
    testWidgets('should show error when email is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.enterText(find.byType(TextField).at(2), 'Password123!');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      expect(find.text('Email không đúng định dạng'), findsOneWidget); // Validator checks format first
    });

    // Test trường hợp mật khẩu để trống
    testWidgets('should show error when password is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'Password123!');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng ký'));
      await tester.pumpAndSettle();

      expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget); // Empty triggers length check
    });


    // Test chuyển hướng về LoginScreen
    testWidgets('should navigate back to LoginScreen when clicking login link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
            child: const RegisterScreen(),
          ),
        ),
      );

      // Nhấn nút "Đã có tài khoản? Đăng nhập ngay"
      await tester.tap(find.widgetWithText(TextButton, 'Đã có tài khoản? Đăng nhập ngay'));
      await tester.pumpAndSettle();

      // Kiểm tra RegisterScreen đã biến mất (giả sử pop về LoginScreen)
      expect(find.byType(RegisterScreen), findsNothing);
    });
  });
}