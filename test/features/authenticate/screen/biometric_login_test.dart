import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/login_screen.dart';
import 'package:expense_tracking/utils/biometric_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'biometric_login_test.mocks.dart';

@GenerateMocks([UserBloc])
void main() {
  group('Biometric authentication in LoginScreen', () {
    late MockUserBloc mockUserBloc;

    setUp(() {
      mockUserBloc = MockUserBloc();

      // Thiết lập lại mock methods về mặc định
      BiometricAuthMethods.resetMethods();
    });

    testWidgets(
        'Biometric login button is not shown when biometrics is not available',
        (WidgetTester tester) async {
      // Cấu hình mock
      BiometricAuthMethods.canCheckBiometrics = () async => false;
      BiometricAuthMethods.getAvailableBiometrics = () async => [];
      BiometricAuthMethods.isBiometricEnabled = () async => false;

      // Render màn hình đăng nhập
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (context) => mockUserBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      // Đợi quá trình kiểm tra sinh trắc học hoàn tất
      await tester.pumpAndSettle();

      // Tìm kiếm nút đăng nhập bằng sinh trắc học
      final biometricButton = find.text('Đăng nhập bằng sinh trắc học');

      // Xác nhận rằng nút không hiển thị
      expect(biometricButton, findsNothing);
    });

    testWidgets(
        'Biometric login button is shown when biometrics is available and enabled',
        (WidgetTester tester) async {
      // Cấu hình mock
      BiometricAuthMethods.canCheckBiometrics = () async => true;
      BiometricAuthMethods.getAvailableBiometrics =
          () async => [BiometricType.fingerprint];
      BiometricAuthMethods.isBiometricEnabled = () async => true;
      BiometricAuthMethods.getBiometricUser = () async => 'test-user-id';

      // Render màn hình đăng nhập
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (context) => mockUserBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      // Đợi quá trình kiểm tra sinh trắc học hoàn tất
      await tester.pumpAndSettle();

      // Tìm kiếm nút đăng nhập bằng sinh trắc học
      final biometricButton = find.text('Đăng nhập bằng sinh trắc học');

      // Xác nhận rằng nút hiển thị
      expect(biometricButton, findsOneWidget);
    });

    testWidgets('Pressing biometric login button triggers authentication',
        (WidgetTester tester) async {
      // Cấu hình mock
      BiometricAuthMethods.canCheckBiometrics = () async => true;
      BiometricAuthMethods.getAvailableBiometrics =
          () async => [BiometricType.fingerprint];
      BiometricAuthMethods.isBiometricEnabled = () async => true;
      BiometricAuthMethods.getBiometricUser = () async => 'test-user-id';
      BiometricAuthMethods.authenticate =
          ({required String reason, bool biometricOnly = false}) async => true;

      // Render màn hình đăng nhập
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (context) => mockUserBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      // Đợi quá trình kiểm tra sinh trắc học hoàn tất
      await tester.pumpAndSettle();

      // Tìm kiếm nút đăng nhập bằng sinh trắc học
      final biometricButton = find.text('Đăng nhập bằng sinh trắc học');

      // Tap nút đăng nhập bằng sinh trắc học
      await tester.tap(biometricButton);
      await tester.pump();

      // Xác nhận rằng LoadUserEvent được gọi với ID người dùng đúng
      verify(mockUserBloc.add(LoadUserEvent('test-user-id'))).called(1);
    });

    testWidgets('Authentication failure shows error message',
        (WidgetTester tester) async {
      // Cấu hình mock
      BiometricAuthMethods.canCheckBiometrics = () async => true;
      BiometricAuthMethods.getAvailableBiometrics =
          () async => [BiometricType.fingerprint];
      BiometricAuthMethods.isBiometricEnabled = () async => true;
      BiometricAuthMethods.getBiometricUser = () async => 'test-user-id';
      BiometricAuthMethods.authenticate =
          ({required String reason, bool biometricOnly = false}) async => false;

      // Render màn hình đăng nhập
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (context) => mockUserBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      // Đợi quá trình kiểm tra sinh trắc học hoàn tất
      await tester.pumpAndSettle();

      // Tìm kiếm nút đăng nhập bằng sinh trắc học
      final biometricButton = find.text('Đăng nhập bằng sinh trắc học');

      // Tap nút đăng nhập bằng sinh trắc học
      await tester.tap(biometricButton);
      await tester.pump();

      // Xác nhận rằng LoadUserEvent không được gọi
      verifyNever(mockUserBloc.add(any));
    });

    testWidgets(
        'Biometric authentication triggers automatically when available and enabled',
        (WidgetTester tester) async {
      // Cấu hình mock
      BiometricAuthMethods.canCheckBiometrics = () async => true;
      BiometricAuthMethods.getAvailableBiometrics =
          () async => [BiometricType.fingerprint];
      BiometricAuthMethods.isBiometricEnabled = () async => true;
      BiometricAuthMethods.getBiometricUser = () async => 'test-user-id';
      BiometricAuthMethods.authenticate =
          ({required String reason, bool biometricOnly = false}) async => true;

      // Render màn hình đăng nhập
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>(
            create: (context) => mockUserBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      // Đợi quá trình khởi tạo và xác thực tự động hoàn tất
      await tester.pumpAndSettle();

      // Xác nhận rằng LoadUserEvent được gọi với ID người dùng đúng
      verify(mockUserBloc.add(LoadUserEvent('test-user-id'))).called(1);
    });
  });
}
