import 'package:expense_tracking/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "validate email with invalid data",
    () {
      expect(Validator.isValidEmail("abc"), false);
      expect(Validator.isValidEmail("abc@"), false);
      expect(Validator.isValidEmail("abc@abc"), false);
      expect(Validator.isValidEmail("abc@abc."), false);
      expect(Validator.isValidEmail("@abc.com"), false);
      expect(Validator.isValidEmail("tihihi@a+bc.com"), false);
      expect(Validator.isValidEmail("tihihi@abc.co+m"), false);
      expect(Validator.isValidEmail("abc.com:9000"), false);
    },
  );

  test(
    "validate email with valid data",
    () {
      expect(Validator.isValidEmail("testemail@gmail.com"), true);
      expect(Validator.isValidEmail("testema.il@gmail.com"), true);
      expect(Validator.isValidEmail("testema+il@gmail.com"), true);
      expect(Validator.isValidEmail("h@gmail.net"), true);
    },
  );

  test(
    "Validate password not using special character expect false",
    () {
      expect(Validator.isValidPassword("Abcdefg1"), false);
    },
  );

  test(
    "Validate password not using number expect false",
    () {
      expect(Validator.isValidPassword("Abcdefg@"), false);
    },
  );

  test(
    "Validate password not Uppercase expect false",
    () {
      expect(Validator.isValidPassword("dbcdefg@34"), false);
    },
  );

  test(
    "Validate password not using lower case expect false",
    () {
      expect(Validator.isValidPassword("AAAAAAFFF@34"), false);
    },
  );

  test(
    "Validate password less then 6 char expect false",
    () {
      expect(Validator.isValidPassword("A@1ds"), false);
    },
  );
}
