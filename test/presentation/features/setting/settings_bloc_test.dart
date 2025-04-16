import 'package:bloc_test/bloc_test.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/presentation/features/setting/screen/settings_screen.dart';
import 'package:expense_tracking/utils/biometric_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;

    setUp(() {
      settingsBloc = SettingsBloc();
      BiometricAuthMethods.resetMethods();
    });

    tearDown(() {
      settingsBloc.close();
    });

    test('initial state is correct', () {
      // Assert
      expect(settingsBloc.state, equals(const SettingsState()));
    });

    group('LoadUserDataEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [state with user data] when LoadUserDataEvent is added',
        build: () => settingsBloc,
        act: (bloc) => bloc.add(LoadUserDataEvent(
          User('test-id', 'test@example.com', 0, 'Test User', ''),
        )),
        expect: () => [
          predicate<SettingsState>((state) =>
              state.user?.id == 'test-id' &&
              state.user?.email == 'test@example.com' &&
              state.user?.fullName == 'Test User')
        ],
      );
    });

    group('ToggleDarkModeEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [state with darkMode = true] when ToggleDarkModeEvent(true) is added',
        build: () => settingsBloc,
        act: (bloc) => bloc.add(const ToggleDarkModeEvent(true)),
        expect: () =>
            [predicate<SettingsState>((state) => state.darkMode == true)],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [state with darkMode = false] when ToggleDarkModeEvent(false) is added',
        build: () => settingsBloc,
        seed: () => const SettingsState(darkMode: true),
        act: (bloc) => bloc.add(const ToggleDarkModeEvent(false)),
        expect: () =>
            [predicate<SettingsState>((state) => state.darkMode == false)],
      );
    });

    group('ToggleNotificationsEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [state with notificationsEnabled = false] when ToggleNotificationsEvent(false) is added',
        build: () => settingsBloc,
        act: (bloc) => bloc.add(const ToggleNotificationsEvent(false)),
        expect: () => [
          predicate<SettingsState>(
              (state) => state.notificationsEnabled == false)
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [state with notificationsEnabled = true] when ToggleNotificationsEvent(true) is added',
        build: () => settingsBloc,
        seed: () => const SettingsState(notificationsEnabled: false),
        act: (bloc) => bloc.add(const ToggleNotificationsEvent(true)),
        expect: () => [
          predicate<SettingsState>(
              (state) => state.notificationsEnabled == true)
        ],
      );
    });

    group('ChangeCurrencyEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [state with currency = USD] when ChangeCurrencyEvent(USD) is added',
        build: () => settingsBloc,
        act: (bloc) => bloc.add(const ChangeCurrencyEvent('USD')),
        expect: () =>
            [predicate<SettingsState>((state) => state.currency == 'USD')],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [state with currency = VND] when ChangeCurrencyEvent(VND) is added',
        build: () => settingsBloc,
        seed: () => const SettingsState(currency: 'USD'),
        act: (bloc) => bloc.add(const ChangeCurrencyEvent('VND')),
        expect: () =>
            [predicate<SettingsState>((state) => state.currency == 'VND')],
      );
    });

    group('ToggleBiometricsEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [loading, biometricsEnabled = true] when ToggleBiometricsEvent(true) is added and authentication succeeds',
        build: () {
          // Set up mocks for successful authentication
          BiometricAuthMethods.authenticate = (
                  {required String reason, bool biometricOnly = false}) async =>
              true;
          BiometricAuthMethods.setBiometricEnabled = (bool enabled) async {};
          BiometricAuthMethods.saveBiometricUser = (String userId) async {};

          return settingsBloc;
        },
        act: (bloc) => bloc.add(const ToggleBiometricsEvent(true)),
        expect: () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>((state) =>
              state.isLoading == false && state.biometricsEnabled == true)
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [loading, biometricsEnabled = false] when ToggleBiometricsEvent(true) is added and authentication fails',
        build: () {
          // Set up mocks for failed authentication
          BiometricAuthMethods.authenticate = (
                  {required String reason, bool biometricOnly = false}) async =>
              false;

          return settingsBloc;
        },
        act: (bloc) => bloc.add(const ToggleBiometricsEvent(true)),
        expect: () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>((state) =>
              state.isLoading == false && state.biometricsEnabled == false)
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [biometricsEnabled = false] when ToggleBiometricsEvent(false) is added',
        build: () {
          BiometricAuthMethods.setBiometricEnabled = (bool enabled) async {};
          return settingsBloc;
        },
        seed: () => const SettingsState(biometricsEnabled: true),
        act: (bloc) => bloc.add(const ToggleBiometricsEvent(false)),
        expect: () => [
          predicate<SettingsState>((state) => state.biometricsEnabled == false)
        ],
      );
    });

    group('CheckBiometricsAvailabilityEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [loading, isBiometricsAvailable = true] when biometrics is available',
        build: () {
          // Mock BiometricAuth static methods
          BiometricAuthMethods.canCheckBiometrics = () async => true;
          BiometricAuthMethods.getAvailableBiometrics =
              () async => [BiometricType.fingerprint];
          BiometricAuthMethods.isBiometricEnabled = () async => true;

          return settingsBloc;
        },
        act: (bloc) => bloc.add(CheckBiometricsAvailabilityEvent()),
        expect: () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>((state) =>
              state.isLoading == false &&
              state.isBiometricsAvailable == true &&
              state.biometricsEnabled == true)
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [loading, isBiometricsAvailable = false] when biometrics is not available',
        build: () {
          // Mock BiometricAuth static methods
          BiometricAuthMethods.canCheckBiometrics = () async => false;
          BiometricAuthMethods.getAvailableBiometrics = () async => [];

          return settingsBloc;
        },
        act: (bloc) => bloc.add(CheckBiometricsAvailabilityEvent()),
        expect: () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>((state) =>
              state.isLoading == false && state.isBiometricsAvailable == false)
        ],
      );
    });
  });
}
