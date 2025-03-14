import 'package:flutter/material.dart';
import 'package:flutter_therapy_evolution/app/core/entities/user_entity.dart';

class RegisterParams extends ChangeNotifier {
  String email;
  String password;
  String name;
  String confirmPassword;
  String phone;
  String specialty;
  String licenseNumber;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.specialty,
    required this.licenseNumber,
  });

  factory RegisterParams.empty() => RegisterParams(
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
        phone: '',
        specialty: '',
        licenseNumber: '',
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

  setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  setSpecialty(String value) {
    specialty = value;
    notifyListeners();
  }

  setLicenseNumber(String value) {
    licenseNumber = value;
    notifyListeners();
  }

  UserEntity toUserEntity() {
    return UserEntity(
      id: '',
      name: name,
      email: email,
      phone: phone,
      specialty: specialty,
      licenseNumber: licenseNumber,
      profilePicture: null,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return UserEntity.toMap(toUserEntity());
  }
}
