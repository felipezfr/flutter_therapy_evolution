import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_therapy_evolution/app/core/session/logged_user.dart';

class SessionService {
  final FirebaseAuth _firebaseAuth;

  SessionService(this._firebaseAuth);

  Future<bool> isUserLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<String> userLoggedId() async {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<void> logout() async {
    LoggedUser.logOut();
    await _firebaseAuth.signOut();
  }
}
