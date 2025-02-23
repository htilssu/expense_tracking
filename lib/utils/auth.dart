import 'package:expense_tracking/exceptions/authenticate_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  ///- Get the current user's id
  ///- Throw [AuthenticateException] if the user is not logged in
  static String uid() {
    var usr = FirebaseAuth.instance.currentUser;
    if (usr == null) throw AuthenticateException("User is not logged in");

    return usr.uid;
  }
}
