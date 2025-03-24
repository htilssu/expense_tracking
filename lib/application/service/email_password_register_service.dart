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
    // Kiểm tra email hợp lệ
    if (userRegister.email.isEmpty) {
      throw const FormatException('Email không được để trống');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(userRegister.email)) {
      throw const FormatException('Email không hợp lệ');
    }

    // Kiểm tra mật khẩu hợp lệ
    if (userRegister.password.isEmpty) {
      throw const FormatException('Mật khẩu không được để trống');
    }
    if (userRegister.password.length < 8) {
      throw const FormatException('Mật khẩu phải có ít nhất 8 ký tự');
    }
    if (!RegExp(r'[A-Z]').hasMatch(userRegister.password)) {
      throw const FormatException('Mật khẩu phải chứa ít nhất một chữ hoa');
    }
    if (!RegExp(r'[a-z]').hasMatch(userRegister.password)) {
      throw const FormatException('Mật khẩu phải chứa ít nhất một chữ thường');
    }
    if (!RegExp(r'[0-9]').hasMatch(userRegister.password)) {
      throw const FormatException('Mật khẩu phải chứa ít nhất một số');
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(userRegister.password)) {
      throw const FormatException('Mật khẩu phải chứa ít nhất một ký tự đặc biệt');
    }

    try {
      await auth.createUserWithEmailAndPassword(
        email: userRegister.email,
        password: userRegister.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailExistException('Email đã được sử dụng');
      } else {
        throw Exception('Hãy thử lại sau');
      }
    }
  }
}
