import 'package:flutter/foundation.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/entities/user_entity.dart';

class LoggedUser extends ChangeNotifier {
  static LoggedUser? _instance;
  // Avoid self instance
  LoggedUser._();
  static LoggedUser get instance => _instance ??= LoggedUser._();

  static UserEntity? _loggedUser;

  static String? _userId;

  static UserEntity? get loggedUser => _loggedUser;

  static String get id => _userId!;

  static set setUserId(String userId) {
    _userId = userId;
  }

  set setLoggedUser(UserEntity loggedUser) {
    _loggedUser = loggedUser;
    _userId = loggedUser.id;
    notifyListeners();
  }

  static void logOut() {
    _userId = null;
    _loggedUser = null;
  }
}
