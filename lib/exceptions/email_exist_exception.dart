class EmailExistException implements Exception {
  final String message;

  EmailExistException(this.message);
}