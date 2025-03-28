import 'package:flutter/foundation.dart';
import 'package:flutter_therapy_evolution/app/core/entities/user_entity.dart';

class Session extends ChangeNotifier {
  static Session? _instance;
  Session._();
  static Session get instance => _instance ??= Session._();

  static UserEntity? _loggedUser;

  static UserEntity? get loggedUser => _loggedUser;

  static String get id => loggedUser!.id;

  set setLoggedUser(UserEntity loggedUser) {
    _loggedUser = loggedUser;
    notifyListeners();
  }

  static void logOut() {
    _loggedUser = null;
  }
}
