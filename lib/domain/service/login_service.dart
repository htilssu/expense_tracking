import 'package:firebase_auth/firebase_auth.dart';

import '../dto/user_login.dart';

abstract class LoginService<T extends UserLogin> {
  FirebaseAuth auth = FirebaseAuth.instance;

  LoginService();

  /// Đăng nhập người dùng với thông tin đăng nhập được cung cấp.
  ///
  /// Ném ra các ngoại lệ sau nếu có lỗi xảy ra:
  /// - [UserNotFoundException]: Nếu người dùng không tồn tại.
  /// - [WrongPasswordException]: Nếu mật khẩu không đúng.
  /// - [UserDisabledException]: Nếu tài khoản người dùng bị vô hiệu hóa.
  /// - [Exception]: Nếu có lỗi khác xảy ra.
  Future<void> login(T data);
}
