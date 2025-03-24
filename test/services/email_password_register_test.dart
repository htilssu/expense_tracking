import 'package:expense_tracking/application/dto/email_password_register.dart';
import 'package:expense_tracking/application/service/email_password_register_service.dart';
import 'package:expense_tracking/exceptions/email_exist_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import file mock được sinh ra bởi mockito
import 'email_password_login_service_test.mocks.dart';

// Tạo mock cho FirebaseAuth và UserCredential
@GenerateMocks([FirebaseAuth, UserCredential])
void main() {
  // Khai báo các biến
  late MockFirebaseAuth mockFirebaseAuth;
  late EmailPasswordRegisterService registerService;
  late EmailPasswordRegister registerData;

  // Thiết lập trước mỗi test
  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    registerService = EmailPasswordRegisterService(auth: mockFirebaseAuth);
    registerData = EmailPasswordRegister(
      'test@example.com',
      '07102004aA@',
    );
  });

  // Test case 1: Đăng ký thành công
  test('Đăng ký thành công', () async {
    // Arrange: Giả lập createUserWithEmailAndPassword trả về UserCredential
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: registerData.email,
      password: registerData.password,
    )).thenAnswer((_) async => MockUserCredential());

    // Act: Gọi phương thức register
    await registerService.register(registerData);

    // Assert: Kiểm tra rằng createUserWithEmailAndPassword được gọi đúng một lần
    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: registerData.email,
      password: registerData.password,
    )).called(1);
  });

  // Test case 2: Đăng ký thất bại do email đã tồn tại
  test('Đăng ký thất bại do email đã tồn tại', () async {
    // Arrange: Giả lập ném ra FirebaseAuthException với mã lỗi 'email-already-in-use'
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: registerData.email,
      password: registerData.password,
    )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    // Act & Assert: Kiểm tra rằng phương thức register ném ra EmailExistException
    expect(
      () => registerService.register(registerData),
      throwsA(isA<EmailExistException>()
          .having((e) => e.message, 'message', 'Email đã được sử dụng')),
    );
  });

  // Test case 3: Đăng ký thất bại do lỗi khác
  test('Đăng ký thất bại do lỗi khác', () async {
    // Arrange: Giả lập ném ra FirebaseAuthException với mã lỗi bất kỳ khác
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: registerData.email,
      password: registerData.password,
    )).thenThrow(FirebaseAuthException(code: 'other-error'));

    // Act & Assert: Kiểm tra rằng phương thức register ném ra Exception
    expect(
      () => registerService.register(registerData),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', 'Exception: Hãy thử lại sau')),
    );
  });

  // ✅ Test case 4: Email không hợp lệ (thiếu @)
  test('Email không hợp lệ - thiếu @', () async {
    final registerData = EmailPasswordRegister('testgmail.com', '07102004aA@');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Email không hợp lệ',
      )),
    );
  });

  // ✅ Test case 5: Email không hợp lệ (không có domain)
  test('Email không hợp lệ - không có domain', () async {
    final registerData = EmailPasswordRegister('test@gmail', '07102004aA@');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Email không hợp lệ',
      )),
    );
  });

  // ✅ Test case 6: Mật khẩu quá ngắn (dưới 8 ký tự)
  test('Mật khẩu quá ngắn', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', '07102');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu phải có ít nhất 8 ký tự',
      )),
    );
  });

  // ✅ Test case 7: Mật khẩu thiếu ký tự đặc biệt
  test('Mật khẩu thiếu ký tự đặc biệt', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', '07102004aA');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt',
      )),
    );
  });

  // ✅ Test case 8: Mật khẩu không có chữ hoa
  test('Mật khẩu không có chữ hoa', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', '071020a@');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu phải chứa ít nhất một chữ hoa',
      )),
    );
  });

  // ✅ Test case 9: Mật khẩu không có chữ thường
  test('Mật khẩu không có chữ thường', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', '071020A@');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu phải chứa ít nhất một chữ thường',
      )),
    );
  });

  // ✅ Test case 10: Mật khẩu trống
  test('Mật khẩu trống', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', '');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu không được để trống',
      )),
    );
  });

  // ✅ Test case 11: Mật khẩu nhập lại không khớp
  test('Mật khẩu nhập lại không khớp', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', '07102004aA@');
    const rePassword = '07102004bB@';

    expect(
          () {
        if (registerData.password != rePassword) {
          throw const FormatException('Mật khẩu nhập lại không khớp');
        }
        return registerService.register(registerData);
      },
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu nhập lại không khớp',
      )),
    );
  });

  // ✅ Test case 12: Email trống
  test('Email trống', () async {
    final registerData = EmailPasswordRegister('', '07102004aA@');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Email không được để trống',
      )),
    );
  });
  // ✅ Test case 13: Mat khau khong co ki tu so
  test('Mật khẩu thiếu số', () async {
    final registerData = EmailPasswordRegister('test@gmail.com', 'abcdefghA@');

    expect(
          () => registerService.register(registerData),
      throwsA(isA<FormatException>().having(
            (e) => e.message, 'message', 'Mật khẩu phải chứa ít nhất một số',
      )),
    );
  });
}
