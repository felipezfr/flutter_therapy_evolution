import 'package:flutter/material.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/dtos/user_adapter.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/entities/user_entity.dart';

class RegisterParams extends ChangeNotifier {
  String email;
  String password;
  String name;
  String confirmPassword;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterParams.empty() => RegisterParams(
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
      );

  setEmail(String value) {
    email = value;
    notifyListeners();
  }

  setPassword(String value) {
    password = value;
    notifyListeners();
  }

  setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  setName(String value) {
    name = value;
    notifyListeners();
  }

  UserEntity toUserEntity() {
    return UserEntity(
      id: '',
      name: name,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return UserAdapter.toMap(toUserEntity());
  }
}
