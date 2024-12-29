import 'package:expense_tracking/domain/dto/user_register.dart';

class EmailPasswordRegister implements UserRegister {
  final String email;
  final String password;

  EmailPasswordRegister(this.email, this.password);
}