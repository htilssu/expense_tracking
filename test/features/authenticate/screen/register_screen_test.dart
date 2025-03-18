import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late RegisterScreenState registerScreenState;

  setUp(() {
    registerScreenState = RegisterScreenState();
  });

  testWidgets('Hiển thị đúng các widget trong RegisterScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    expect(find.text('Đăng ký'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Kiểm tra nhập email không hợp lệ', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Email không đúng định dạng'), findsOneWidget);
  });

  testWidgets('Kiểm tra nhập mật khẩu không hợp lệ', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
  });

  testWidgets('Kiểm tra mật khẩu không khớp', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.enterText(find.byType(TextFormField).at(1), 'Password@1');
    await tester.enterText(find.byType(TextFormField).at(2), 'Password@2');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Mật khẩu không khớp'), findsOneWidget);
  });
}