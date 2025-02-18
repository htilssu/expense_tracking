class AuthenticateException {
  final String message;

  AuthenticateException(this.message);

  @override
  String toString() {
    return message;
  }
}
