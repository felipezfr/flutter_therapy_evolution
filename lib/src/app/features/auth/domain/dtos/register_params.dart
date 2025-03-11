import 'package:flutter/material.dart';

import '../../data/models/request/register_model.dart';

class RegisterParams extends ChangeNotifier {
  String name;
  String email;
  String password;
  String confirmPassword;
  String phone;
  String zipCode;
  String address;
  String numberHouse;
  String complement;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.zipCode,
    required this.address,
    required this.numberHouse,
    required this.complement,
  });

  factory RegisterParams.empty() => RegisterParams(
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
        phone: '',
        zipCode: '',
        address: '',
        numberHouse: '',
        complement: '',
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

  setZipCode(String value) {
    zipCode = value;
    notifyListeners();
  }

  setAddress(String value) {
    address = value;
    notifyListeners();
  }

  setNumberHouse(String value) {
    numberHouse = value;
    notifyListeners();
  }

  setComplement(String value) {
    complement = value;
    notifyListeners();
  }

  RegisterModel toModel() {
    return RegisterModel(
      name: name,
      email: email,
      password: password,
      phone: phone,
      address: address,
      zipCode: zipCode,
      numberHouse: numberHouse,
      complement: complement,
      photoUrl: '',
    );
  }
}
