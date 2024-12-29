class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([this.message = 'Không tìm thấy người dùng']);

  @override
  String toString() => 'UserNotFoundException: $message';
}