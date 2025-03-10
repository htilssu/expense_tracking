import 'package:expense_tracking/application/dto/email_password_register.dart';
import 'package:expense_tracking/domain/service/register_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/email_exist_exception.dart';

class EmailPasswordRegisterService
    implements RegisterService<EmailPasswordRegister> {
  late FirebaseAuth auth;

  EmailPasswordRegisterService({FirebaseAuth? auth}) {
    this.auth = auth ?? FirebaseAuth.instance;
  }

  @override
  Future<void> register(EmailPasswordRegister userRegister) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: userRegister.email, password: userRegister.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailExistException('Email đã được sử dụng');
      } else {
        throw Exception('Hãy thử lại sau');
      }
    }
  }
}
