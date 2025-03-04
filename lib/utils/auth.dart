import 'dart:async';

import 'package:expense_tracking/exceptions/authenticate_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Auth {
  ///- Get the current user's id
  ///- Throw [AuthenticateException] if the user is not logged in
  static String uid() {
    var usr = FirebaseAuth.instance.currentUser;
    if (usr == null) throw AuthenticateException('User is not logged in');

    return usr.uid;
  }

  static final authStream = StreamController<User?>();

  static Stream<User?> getStream() {
    authStream.add(FirebaseAuth.instance.currentUser);
    return authStream.stream;
  }

  static void closeStream() {
    authStream.close();
  }

  static void addStream(User? user) {
    authStream.add(user);
  }
}
