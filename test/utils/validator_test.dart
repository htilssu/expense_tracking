import 'package:expense_tracking/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Email validator test',
    () {
      test(
        'email without @ symbol should be invalid',
        () {
          expect(Validator.isValidEmail('abc'), false);
          expect(Validator.isValidEmail('abc.com'), false);
        },
      );

      test(
        'email with incomplete domain structure should be invalid',
        () {
          expect(Validator.isValidEmail('abc@'), false);
          expect(Validator.isValidEmail('abc@abc'), false);
          expect(Validator.isValidEmail('abc@abc.'), false);
        },
      );

      test(
        'email without local part should be invalid', 
        () {
          expect(Validator.isValidEmail('@abc.com'), false);
        },
      );

      test(
        'email with invalid characters in domain or local part should be invalid',
        () {
          expect(Validator.isValidEmail('tihihi@a+bc.com'), false);
          expect(Validator.isValidEmail('tihihi@abc.co+m'), false);
        },
      );

      test(
        'email with port number should be invalid',
        () {
          expect(Validator.isValidEmail('abc.com:9000'), false);
        },
      );

      test(
        'standard email address should be valid',
        () {
          expect(Validator.isValidEmail('testemail@gmail.com'), true);
        },
      );
      
      test(
        'email with dot in local part should be valid',
        () {
          expect(Validator.isValidEmail('testema.il@gmail.com'), true);
        },
      );
      
      test(
        'email with plus sign in local part should be valid',
        () {
          expect(Validator.isValidEmail('testema+il@gmail.com'), true);
        },
      );
      
      test(
        'email with single character local part should be valid',
        () {
          expect(Validator.isValidEmail('h@gmail.net'), true);
        },
      );
    },
  );

  group(
    'Password validator test',
    () {
      test(
        'Validate password not using special character expect false',
        () {
          expect(Validator.isValidPassword('Abcdefg1'), false);
        },
      );

      test(
        'Validate password not using number expect false',
        () {
          expect(Validator.isValidPassword('Abcdefg@'), false);
        },
      );

      test(
        'Validate password not Uppercase expect false',
        () {
          expect(Validator.isValidPassword('dbcdefg@34'), false);
        },
      );

      test(
        'Validate password not using lower case expect false',
        () {
          expect(Validator.isValidPassword('AAAAAAFFF@34'), false);
        },
      );

      test(
        'Validate password less then 6 char expect false',
        () {
          expect(Validator.isValidPassword('A@1ds'), false);
        },
      );
      
      test(
        'Validate minimum valid password (6 chars) expect true',
        () {
          expect(Validator.isValidPassword('Abc@1d'), true);
        },
      );

      test(
        'Validate password with multiple special characters expect true',
        () {
          expect(Validator.isValidPassword('Abcde@#\$123'), true);
        },
      );

      test(
        'Validate password with multiple numbers expect true',
        () {
          expect(Validator.isValidPassword('Abcde@123'), true);
        },
      );

      test(
        'Validate complex password expect true',
        () {
          expect(Validator.isValidPassword('P@ssw0rd!2023'), true);
        },
      );

      test(
        'Validate password with mixed case and special characters expect true',
        () {
          expect(Validator.isValidPassword('StRoNg#P@ss789'), true);
        },
      );
    },
  );
}

