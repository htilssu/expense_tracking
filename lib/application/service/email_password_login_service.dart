import 'package:expense_tracking/application/dto/email_password_login.dart';
import 'package:expense_tracking/domain/service/login_service.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../exceptions/user_disabled_exception.dart';
import '../../exceptions/user_notfound_exception.dart';
import '../../exceptions/wrong_password_exception.dart';

class EmailPasswordLoginService extends LoginService<EmailPasswordLogin> {
  @override
  Future<void> login(EmailPasswordLogin data) async {
    try {
      await auth?.signInWithEmailAndPassword(
          email: data.email, password: data.password);
      if (kDebugMode) {
        Logger.info('Đăng nhập thành công: ${auth?.currentUser}');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledException();
      } else {
        throw Exception('Hãy thử lại sau');
      }
    }
  }

  EmailPasswordLoginService({FirebaseAuth? auth}) : super(auth) {
    if (auth == null) {
      this.auth = FirebaseAuth.instance;
    }
  }
}
