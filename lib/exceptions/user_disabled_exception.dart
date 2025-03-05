class UserDisabledException implements Exception {
  final String message;

  UserDisabledException([this.message = 'Tài khoản đã bị vô hiệu hóa']);

  @override
  String toString() => 'UserDisabledException: $message';
}