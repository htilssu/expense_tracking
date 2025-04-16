import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logging.dart';

// Cho phép mock các phương thức tĩnh dễ dàng hơn
class BiometricAuthMethods {
  static Future<bool> Function() canCheckBiometrics =
      _defaultCanCheckBiometrics;
  static Future<List<BiometricType>> Function() getAvailableBiometrics =
      _defaultGetAvailableBiometrics;
  static Future<bool> Function({required String reason, bool biometricOnly})
      authenticate = _defaultAuthenticate;
  static Future<bool> Function() isBiometricEnabled =
      _defaultIsBiometricEnabled;
  static Future<void> Function(bool enabled) setBiometricEnabled =
      _defaultSetBiometricEnabled;
  static Future<void> Function(String userId) saveBiometricUser =
      _defaultSaveBiometricUser;
  static Future<String?> Function() getBiometricUser = _defaultGetBiometricUser;
  static Future<void> Function() clearBiometricUser =
      _defaultClearBiometricUser;

  // Implementations mặc định
  static Future<bool> _defaultCanCheckBiometrics() async {
    return await BiometricAuth.localAuth.canCheckBiometrics;
  }

  static Future<List<BiometricType>> _defaultGetAvailableBiometrics() async {
    return await BiometricAuth.localAuth.getAvailableBiometrics();
  }

  static Future<bool> _defaultAuthenticate(
      {required String reason, bool biometricOnly = false}) async {
    return await BiometricAuth.localAuth.authenticate(
      localizedReason: reason,
      options: AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: biometricOnly,
      ),
    );
  }

  static Future<bool> _defaultIsBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }

  static Future<void> _defaultSetBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
  }

  static Future<void> _defaultSaveBiometricUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('biometric_user_id', userId);
  }

  static Future<String?> _defaultGetBiometricUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('biometric_user_id');
  }

  static Future<void> _defaultClearBiometricUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('biometric_user_id');
  }

  // Reset method để khôi phục lại các phương thức mặc định sau khi kiểm thử
  static void resetMethods() {
    canCheckBiometrics = _defaultCanCheckBiometrics;
    getAvailableBiometrics = _defaultGetAvailableBiometrics;
    authenticate = _defaultAuthenticate;
    isBiometricEnabled = _defaultIsBiometricEnabled;
    setBiometricEnabled = _defaultSetBiometricEnabled;
    saveBiometricUser = _defaultSaveBiometricUser;
    getBiometricUser = _defaultGetBiometricUser;
    clearBiometricUser = _defaultClearBiometricUser;
  }
}

class BiometricAuth {
  // Cho phép inject mock LocalAuthentication để kiểm thử
  static LocalAuthentication localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricUserKey = 'biometric_user_id';

  /// Kiểm tra thiết bị có hỗ trợ xác thực sinh trắc học không
  static Future<bool> canCheckBiometrics() async {
    try {
      return await BiometricAuthMethods.canCheckBiometrics();
    } on PlatformException catch (e) {
      Logger.error('Lỗi khi kiểm tra khả năng xác thực sinh trắc học: $e');
      return false;
    }
  }

  /// Lấy danh sách loại xác thực sinh trắc học được hỗ trợ
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await BiometricAuthMethods.getAvailableBiometrics();
    } on PlatformException catch (e) {
      Logger.error('Lỗi khi lấy danh sách sinh trắc học: $e');
      return [];
    }
  }

  /// Thực hiện xác thực sinh trắc học
  static Future<bool> authenticate({
    required String reason,
    bool biometricOnly = false,
  }) async {
    try {
      return await BiometricAuthMethods.authenticate(
          reason: reason, biometricOnly: biometricOnly);
    } on PlatformException catch (e) {
      Logger.error('Lỗi khi xác thực sinh trắc học: $e');
      return false;
    }
  }

  /// Kiểm tra xem xác thực sinh trắc học đã được bật chưa
  static Future<bool> isBiometricEnabled() async {
    return await BiometricAuthMethods.isBiometricEnabled();
  }

  /// Lưu trạng thái bật/tắt xác thực sinh trắc học
  static Future<void> setBiometricEnabled(bool enabled) async {
    await BiometricAuthMethods.setBiometricEnabled(enabled);
  }

  /// Lưu ID người dùng cho xác thực sinh trắc học
  static Future<void> saveBiometricUser(String userId) async {
    await BiometricAuthMethods.saveBiometricUser(userId);
  }

  /// Lấy ID người dùng đã lưu cho xác thực sinh trắc học
  static Future<String?> getBiometricUser() async {
    return await BiometricAuthMethods.getBiometricUser();
  }

  /// Xóa ID người dùng đã lưu khi đăng xuất
  static Future<void> clearBiometricUser() async {
    await BiometricAuthMethods.clearBiometricUser();
  }
}
