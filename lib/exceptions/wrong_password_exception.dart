class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException([this.message = "Mật khẩu không đúng"]);

  @override
  String toString() => "WrongPasswordException: $message";
}