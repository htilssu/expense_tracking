import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/login_screen.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //initial firebase app
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  group(
    "Login screen test",
    () {
      testWidgets("Test widget not missing", (widgetTester) async {
        await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

        // Verify the email and password fields are present
        expect(find.byType(EtTextField), findsNWidgets(2));

        // Verify the login button is present
        expect(
            find.descendant(
                of: find.byType(EtButton), matching: find.text("Đăng nhập")),
            findsOneWidget);

        // Verify the Google login button is present
        expect(find.text('Đăng nhập bằng Google'), findsOneWidget);

        // Verify the Facebook login button is present
        expect(find.text('Đăng nhập bằng Facebook'), findsOneWidget);
      });

      testWidgets(
          "Press login button with empty email expect show error message",
          (widgetTester) async {
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

      testWidgets(
          "Press login button with empty password expect show error message",
          (widgetTester) async {
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

      testWidgets(
        "Press Register button expect go to register screen",
        (widgetTester) async {
          await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

          // Tap the register button.
          await widgetTester.tap(find.ancestor(
            of: find.text("Đăng ký"),
            matching: find.byType(TextButton),
          ));

          // Rebuild the widget after the state has changed.
          await widgetTester.pumpAndSettle();

          // Verify that the RegisterScreen is shown
          expect(find.byType(LoginScreen), findsNothing);
          expect(find.byType(RegisterScreen), findsOne);
        },
      );

      testWidgets(
        "Press hide and show password expect change hide password state",
        (widgetTester) async {
          // Build the LoginScreen widget.
          await widgetTester.pumpWidget(MaterialApp(home: LoginScreen()));

          // Tap the hide password button.
          var hidePasswordButton = find.byIcon(Icons.visibility);
          expect(hidePasswordButton, findsOneWidget);
          await widgetTester.tap(hidePasswordButton);
          await widgetTester.pump();

          // Verify that the password is shown
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);

          // Tap the show password button.
          await widgetTester.tap(find.byIcon(Icons.visibility_off));
          await widgetTester.pump();

          // Verify that the password is hidden
          expect(find.byIcon(Icons.visibility), findsOneWidget);
        },
      );
    },
  );
}
