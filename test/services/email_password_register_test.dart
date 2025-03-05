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
      'password123',
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
}
