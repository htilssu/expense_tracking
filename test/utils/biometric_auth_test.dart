import 'package:expense_tracking/utils/biometric_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'biometric_auth_test.mocks.dart';

// Tạo mock cho các lớp phụ thuộc (local_auth)
@GenerateMocks([LocalAuthentication])
void main() {
  late MockLocalAuthentication mockLocalAuth;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    BiometricAuth.localAuth = mockLocalAuth;
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    // Reset các phương thức về trạng thái ban đầu sau mỗi test
    BiometricAuthMethods.resetMethods();
  });

  group('BiometricAuth', () {
    group('canCheckBiometrics', () {
      test('returns true when device can check biometrics', () async {
        // Arrange
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);

        // Act
        final result = await BiometricAuth.canCheckBiometrics();

        // Assert
        expect(result, isTrue);
      });

      test('returns false when device cannot check biometrics', () async {
        // Arrange
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => false);

        // Act
        final result = await BiometricAuth.canCheckBiometrics();

        // Assert
        expect(result, isFalse);
      });

      test('returns false when an exception occurs', () async {
        // Arrange
        when(mockLocalAuth.canCheckBiometrics)
            .thenThrow(Exception('Test exception'));

        // Act
        final result = await BiometricAuth.canCheckBiometrics();

        // Assert
        expect(result, isFalse);
      });
    });

    group('getAvailableBiometrics', () {
      test('returns list of available biometrics', () async {
        // Arrange
        final expectedBiometrics = [
          BiometricType.fingerprint,
          BiometricType.face
        ];
        when(mockLocalAuth.getAvailableBiometrics)
            .thenAnswer((_) async => expectedBiometrics);

        // Act
        final result = await BiometricAuth.getAvailableBiometrics();

        // Assert
        expect(result, equals(expectedBiometrics));
      });

      test('returns empty list when no biometrics available', () async {
        // Arrange
        when(mockLocalAuth.getAvailableBiometrics).thenAnswer((_) async => []);

        // Act
        final result = await BiometricAuth.getAvailableBiometrics();

        // Assert
        expect(result, isEmpty);
      });

      test('returns empty list when an exception occurs', () async {
        // Arrange
        when(mockLocalAuth.getAvailableBiometrics)
            .thenThrow(Exception('Test exception'));

        // Act
        final result = await BiometricAuth.getAvailableBiometrics();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('authenticate', () {
      test('returns true when authentication succeeds', () async {
        // Arrange
        when(mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => true);

        // Act
        final result = await BiometricAuth.authenticate(reason: 'Test reason');

        // Assert
        expect(result, isTrue);
      });

      test('returns false when authentication fails', () async {
        // Arrange
        when(mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => false);

        // Act
        final result = await BiometricAuth.authenticate(reason: 'Test reason');

        // Assert
        expect(result, isFalse);
      });

      test('returns false when an exception occurs', () async {
        // Arrange
        when(mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          options: anyNamed('options'),
        )).thenThrow(Exception('Test exception'));

        // Act
        final result = await BiometricAuth.authenticate(reason: 'Test reason');

        // Assert
        expect(result, isFalse);
      });
    });

    group('SharedPreferences operations using mock functions', () {
      test('isBiometricEnabled returns value from SharedPreferences', () async {
        // Arrange - using function replacement
        bool mockFunctionCalled = false;
        BiometricAuthMethods.isBiometricEnabled = () async {
          mockFunctionCalled = true;
          return true;
        };

        // Act
        final result = await BiometricAuth.isBiometricEnabled();

        // Assert
        expect(result, isTrue);
        expect(mockFunctionCalled, isTrue);
      });

      test('setBiometricEnabled saves value through mock function', () async {
        // Arrange
        bool? passedValue;
        BiometricAuthMethods.setBiometricEnabled = (bool enabled) async {
          passedValue = enabled;
        };

        // Act
        await BiometricAuth.setBiometricEnabled(true);

        // Assert
        expect(passedValue, isTrue);
      });

      test('saveBiometricUser and getBiometricUser work through mock functions',
          () async {
        // Arrange
        String? savedUserId;
        BiometricAuthMethods.saveBiometricUser = (String userId) async {
          savedUserId = userId;
        };

        String? mockReturnedUserId;
        BiometricAuthMethods.getBiometricUser = () async {
          return savedUserId;
        };

        // Act - save
        await BiometricAuth.saveBiometricUser('test-user-id');

        // Act - get
        mockReturnedUserId = await BiometricAuth.getBiometricUser();

        // Assert
        expect(savedUserId, equals('test-user-id'));
        expect(mockReturnedUserId, equals('test-user-id'));
      });

      test('clearBiometricUser works through mock function', () async {
        // Arrange
        bool clearCalled = false;
        BiometricAuthMethods.clearBiometricUser = () async {
          clearCalled = true;
        };

        // Act
        await BiometricAuth.clearBiometricUser();

        // Assert
        expect(clearCalled, isTrue);
      });
    });

    group('BiometricAuthMethods.resetMethods', () {
      test('resetMethods restores default implementations', () async {
        // Arrange - replace with mock implementations
        BiometricAuthMethods.canCheckBiometrics = () async => true;
        BiometricAuthMethods.isBiometricEnabled = () async => true;

        // Act - reset methods
        BiometricAuthMethods.resetMethods();

        // Arrange mock for the default implementation
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => false);

        // Assert - should use default implementation that relies on LocalAuthentication
        final canCheckResult = await BiometricAuth.canCheckBiometrics();
        expect(canCheckResult, isFalse);

        // SharedPreferences default should return false for empty values
        final isEnabledResult = await BiometricAuth.isBiometricEnabled();
        expect(isEnabledResult, isFalse);
      });
    });
  });
}
