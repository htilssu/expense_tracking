abstract class RegisterService {

  /// Đăng ký người dùng với thông tin đăng ký được cung cấp.
  ///
  /// Ném ra các ngoại lệ sau nếu có lỗi xảy ra:
  /// - [EmailAlreadyInUseException]: Nếu email đã được sử dụng.
  /// - [WeakPasswordException]: Nếu mật khẩu không đủ mạnh.
  /// - [Exception]: Nếu có lỗi khác xảy ra.
  Future<void> register();
}