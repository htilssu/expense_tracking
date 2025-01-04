import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/login_screen.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Test widget not missing", (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Verify the email, password, and confirm password fields are present
    expect(find.byType(EtTextField), findsNWidgets(3));

    // Verify the register button is present
    expect(
        find.descendant(
            of: find.byType(EtButton), matching: find.text("Đăng ký")),
        findsOneWidget);

    // Verify the login button is present
    expect(find.text('Đã có tài khoản? Đăng nhập ngay'), findsOneWidget);
  });

  testWidgets(
      "Press register button with empty email expect show error message",
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Put empty email
    await widgetTester.enterText(find.byType(EtTextField).first, '');
    // Tap the register button
    await widgetTester.tap(find.descendant(
      of: find.byType(EtButton),
      matching: find.text('Đăng ký'),
    ));

    await widgetTester.pump();

    // Check error message in text form field
    expect(find.text('Email không đúng định dạng'), findsOneWidget);
  });

  testWidgets(
      "Press register button with empty password expect show error message",
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Put empty password
    await widgetTester.enterText(find.byType(EtTextField).at(1), '');
    await widgetTester.tap(find.descendant(
      of: find.byType(EtButton),
      matching: find.text('Đăng ký'),
    ));

    await widgetTester.pump();

    expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
  });

  testWidgets(
      "Press register button with mismatched passwords expect show error message",
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Enter password
    await widgetTester.enterText(find.byType(EtTextField).at(1), 'Password1!');
    // Enter mismatched confirm password
    await widgetTester.enterText(find.byType(EtTextField).at(2), 'Password2!');
    await widgetTester.tap(find.descendant(
      of: find.byType(EtButton),
      matching: find.text('Đăng ký'),
    ));

    await widgetTester.pump();

    expect(find.text('Mật khẩu không khớp'), findsOneWidget);
  });

  testWidgets(
    "Press return to login button expect go to login_screen",
    (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

      await widgetTester.tap(find.descendant(
          of: find.byType(TextButton), matching: find.text("Đăng ký")));

      await widgetTester.pumpAndSettle();
      // Tap the return to login button
      await widgetTester.tap(find.ancestor(
          of: find.text("Đã có tài khoản? Đăng nhập ngay"),
          matching: find.byType(TextButton)));
      await widgetTester.pumpAndSettle();

      // Verify the login screen is present
      expect(find.byType(RegisterScreen), findsNothing);
      expect(find.byType(LoginScreen), findsOne);
    },
  );
}
