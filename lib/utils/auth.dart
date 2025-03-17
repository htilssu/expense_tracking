
import 'package:expense_tracking/exceptions/authenticate_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // Define a function variable that can be replaced in tests
  static Function uidFunction = _defaultUidFunction;

  ///- Get the current user's id
  ///- Throw [AuthenticateException] if the user is not logged in
  static String uid() {
    return uidFunction();
  }

  static String _defaultUidFunction() {
    try {
      var usr = FirebaseAuth.instance.currentUser;
      if (usr == null) throw AuthenticateException('User is not logged in');

      return usr.uid;
    } on Exception catch (e) {
      throw AuthenticateException(e.toString());
    }
  }
}
