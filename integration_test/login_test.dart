import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracking/main.dart';

void main() {
  setUp(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    },
  );

  group('Login Integration Test', () {
    testWidgets('Successful login flow', (tester) async {
      // Load the main widget
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Check the login title
      expect(find.text('Login'), findsOneWidget);

      // Enter username
      final usernameField = find.byKey(const Key('usernameField'));
      await tester.enterText(usernameField, 'testuser');
      await tester.pumpAndSettle();

      // Enter password
      final passwordField = find.byKey(const Key('passwordField'));
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      // Tap login button
      final loginButton = find.byKey(const Key('loginButton'));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Check for a welcome or home screen after login
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
