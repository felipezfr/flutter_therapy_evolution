import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/local_storage/i_local_storage.dart';
import 'package:flutter_therapy_evolution/app/core/local_storage/shared_preferences_impl.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addInstance(FirebaseAuth.instance);
    i.addInstance(FirebaseFirestore.instance);
    i.addLazySingleton<ILocalStorage>(SharedPreferencesImpl.new);
  }
}
