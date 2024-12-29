import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //initial firebase app
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("test widget not missing", (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Verify the email and password fields are present
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify the login button is present
    expect(find.text('Đăng nhập'), findsNWidgets(2));

    // Verify the Google login button is present
    expect(find.text('Đăng nhập bằng Google'), findsOneWidget);

    // Verify the Facebook login button is present
    expect(find.text('Đăng nhập bằng Facebook'), findsOneWidget);
  });

  testWidgets("press login button with empty email", (widgetTester) async {
    // Build the LoginScreen widget.
    await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

    //put empty email
    await widgetTester.enterText(find.byType(EtTextField).first, '');
    // Tap the login button.
    await widgetTester.tap(find.descendant(
      of: find.byType(EtButton),
      matching: find.text('Đăng nhập'),
    ));

    await widgetTester.pump();

    //check error message in text form field
    expect(find.text('Tên đăng nhập không được để trống'), findsOneWidget);
  });

  testWidgets("press login button with empty password", (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

    //put empty password
    await widgetTester.enterText(find.byType(EtTextField).last, '');
    await widgetTester.tap(find.descendant(
      of: find.byType(EtButton),
      matching: find.text('Đăng nhập'),
    ));

    await widgetTester.pump();

    expect(find.text('Mật khẩu không được để trống'), findsOneWidget);
  });
}
