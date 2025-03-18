class Validator {
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.+]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }
  static bool isValidPassword(String password){
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(password);
  }
}
