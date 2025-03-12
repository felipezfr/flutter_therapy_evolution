import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/app_module.dart';
import 'package:lucid_validation/lucid_validation.dart';

import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final culture = Culture('pt', 'BR');
  LucidValidation.global.culture = culture;

  return runApp(
    ModularApp(module: AppModule(), child: AppWidget()),
  );
}
