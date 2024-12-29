import '../../domain/dto/user_login.dart';

class EmailPasswordLogin extends UserLogin {
  final String email;
  final String password;

  EmailPasswordLogin({required this.email, required this.password});
}