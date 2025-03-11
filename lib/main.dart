import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

import 'src/app_widget.dart';
import 'src/core/DI/dependency_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final culture = Culture('pt', 'BR');
  LucidValidation.global.culture = culture;
  setupDependencyInjector();
  runApp(const AppWidget());
}
