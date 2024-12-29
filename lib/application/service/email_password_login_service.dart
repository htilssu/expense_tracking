import 'package:expense_tracking/application/dto/email_password_login.dart';
import 'package:expense_tracking/domain/service/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/user_disabled_exception.dart';
import '../../exceptions/user_notfound_exception.dart';
import '../../exceptions/wrong_password_exception.dart';

class EmailPasswordLoginService extends LoginService<EmailPasswordLogin> {

  @override
  Future<void> login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userLogin.email, password: userLogin.password);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledException();
      } else {
        throw Exception("Hãy thử lại sau");
      }
    }
  }

  EmailPasswordLoginService(super.userLogin);
}
