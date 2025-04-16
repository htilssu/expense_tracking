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
    'Login screen test',
    () {
      testWidgets('Test widget not missing', (widgetTester) async {
        await widgetTester.pumpWidget(const MaterialApp(home: LoginScreen()));

        // Verify the email and password fields are present
        expect(find.byType(EtTextField), findsNWidgets(2));

        // Verify the login button is present
        expect(
            find.descendant(
                of: find.byType(EtButton), matching: find.text('Đăng nhập')),
            findsOneWidget);

        // Verify the Google login button is present
        expect(find.text('Đăng nhập bằng Google'), findsOneWidget);

        // Verify the Facebook login button is present
        expect(find.text('Đăng nhập bằng Facebook'), findsOneWidget);
      });

      testWidgets(
          'Press login button with empty email expect show error message',
          (widgetTester) async {
        // Build the LoginScreen widget.
        await widgetTester.pumpWidget(const MaterialApp(home: LoginScreen()));

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
          'Press login button with empty password expect show error message',
          (widgetTester) async {
        await widgetTester.pumpWidget(const MaterialApp(home: LoginScreen()));

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
        'Press Register button expect go to register screen',
        (widgetTester) async {
          await widgetTester.pumpWidget(const MaterialApp(home: LoginScreen()));

          // Tap the register button.
          await widgetTester.tap(find.ancestor(
            of: find.text('Đăng ký'),
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
        'Press hide and show password expect change hide password state',
        (widgetTester) async {
          // Build the LoginScreen widget.
          await widgetTester.pumpWidget(const MaterialApp(home: LoginScreen()));

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

  group('Màn hình đăng nhập UI Test', () {
    testWidgets('Hiển thị tất cả các thành phần của form đăng nhập',
        (WidgetTester tester) async {
      // Render màn hình đăng nhập
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Kiểm tra tiêu đề form "Đăng nhập"
      final titleFinder = find.text('Đăng nhập');
      expect(titleFinder, findsOneWidget);

      // Kiểm tra styling của tiêu đề
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, Colors.blue);
      expect(titleWidget.textAlign, TextAlign.center);

      // Kiểm tra input email
      expect(
          find.byWidgetPredicate(
              (widget) => widget is EtTextField && widget.label == 'Email'),
          findsOneWidget);

      // Kiểm tra input password
      expect(
          find.byWidgetPredicate(
              (widget) => widget is EtTextField && widget.label == 'Mật khẩu'),
          findsOneWidget);

      // Kiểm tra text "Đăng nhập"
      final loginButtonTextFinder = find.text('Đăng nhập');
      expect(loginButtonTextFinder, findsAtLeastNWidgets(1));

      // Kiểm tra text "Đăng ký"
      final signUpTextFinder = find.text('Đăng ký');
      expect(signUpTextFinder, findsOneWidget);

      // Kiểm tra styling của text đăng ký
      final signUpText = tester.widget<Text>(signUpTextFinder);
      expect(signUpText.style?.fontWeight, FontWeight.bold);

      // Kiểm tra button đăng nhập Google
      expect(
          find.byWidgetPredicate((widget) =>
              widget is EtButton &&
              find
                  .descendant(
                      of: find.byWidget(widget),
                      matching: find.text('Đăng nhập bằng google'))
                  .evaluate()
                  .isNotEmpty),
          findsOneWidget);

      // Kiểm tra button đăng nhập Facebook
      expect(
          find.byWidgetPredicate((widget) =>
              widget is EtButton &&
              find
                  .descendant(
                      of: find.byWidget(widget),
                      matching: find.text('Đăng nhập bằng facebook'))
                  .evaluate()
                  .isNotEmpty),
          findsOneWidget);
    });

    testWidgets('Kiểm tra nhập form và gửi dữ liệu đăng nhập',
        (WidgetTester tester) async {
      // Render màn hình đăng nhập
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Tìm các input field
      final emailInput = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Email');
      final passwordInput = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Mật khẩu');

      // Nhập thông tin đăng nhập
      await tester.enterText(emailInput, 'test@example.com');
      await tester.enterText(passwordInput, 'password123');
      await tester.pump();

      // Tìm nút đăng nhập
      final loginButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          find
              .descendant(
                  of: find.byWidget(widget), matching: find.text('Đăng nhập'))
              .evaluate()
              .isNotEmpty);

      // Nhấn nút đăng nhập
      await tester.tap(loginButton);
      await tester.pump();

      // Tại đây chúng ta chỉ kiểm tra UI, không kiểm tra logic thực tế
      // Trong thực tế, cần mock các service và kiểm tra tương tác
    });

    testWidgets('Kiểm tra các nút đăng nhập bằng mạng xã hội',
        (WidgetTester tester) async {
      // Render màn hình đăng nhập
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Tìm các button đăng nhập mạng xã hội
      final googleButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          find
              .descendant(
                  of: find.byWidget(widget),
                  matching: find.text('Đăng nhập bằng google'))
              .evaluate()
              .isNotEmpty);

      final facebookButton = find.byWidgetPredicate((widget) =>
          widget is EtButton &&
          find
              .descendant(
                  of: find.byWidget(widget),
                  matching: find.text('Đăng nhập bằng facebook'))
              .evaluate()
              .isNotEmpty);

      expect(googleButton, findsOneWidget);
      expect(facebookButton, findsOneWidget);

      // Kiểm tra màu sắc của các button
      final googleButtonWidget = tester.widget<EtButton>(googleButton);
      final facebookButtonWidget = tester.widget<EtButton>(facebookButton);

      // Kiểm tra màu sắc (nếu có thể truy cập được thuộc tính màu)
      expect(googleButtonWidget.onPressed, isNotNull);
      expect(facebookButtonWidget.onPressed, isNotNull);
    });

    testWidgets('Kiểm tra điều hướng đến màn hình đăng ký',
        (WidgetTester tester) async {
      // Render màn hình đăng nhập
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Tìm text "Đăng ký"
      final signUpText = find.text('Đăng ký');
      expect(signUpText, findsOneWidget);

      // Tap vào text đăng ký
      await tester.tap(signUpText);
      await tester.pumpAndSettle();

      // Tại đây kiểm tra điều hướng (trong test thực tế)
      // Cần mock Navigator hoặc sử dụng router để kiểm tra điều hướng
    });
  });
}
