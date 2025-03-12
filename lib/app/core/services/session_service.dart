import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/dtos/user_adapter.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/entities/user_entity.dart';

import '../local_storage/i_local_storage.dart';

const _kUser = 'USER';

class SessionService {
  final FirebaseAuth _firebaseAuth;
  final ILocalStorage _localStorage;

  SessionService(this._firebaseAuth, this._localStorage);

  Future<bool> isUserLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await clearAllData();
  }

  Future<void> saveUser(UserEntity user) async {
    final userMap = UserAdapter.toMap(user);
    await _localStorage.setData(key: _kUser, value: userMap);
  }

  Future<UserEntity?> getUser() async {
    final userMap = await _localStorage.getData(_kUser);
    if (userMap == null) return null;
    return UserAdapter.fromMap(userMap);
  }

  Future<void> clearAllData() async {
    await _localStorage.clean();
  }
}
