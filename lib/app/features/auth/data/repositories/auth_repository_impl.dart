import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_therapy_evolution/app/core/log/log_manager.dart';
import 'package:flutter_therapy_evolution/app/core/errors/repository_exception.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/models/login_params.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/session/logged_user.dart';
import '../../../../core/errors/auth_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import 'auth_repository.dart';
import '../../presentation/models/register_params.dart';

class AuthRepositoryImpl extends IAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<bool> get isAuthenticated async {
    return _auth.currentUser != null;
  }

  @override
  Future<String> get userLoggedId async {
    return _auth.currentUser!.uid;
  }

  // @override
  // Output<String> userLoggedId() async {
  //   try {
  //     final userId = _auth.currentUser?.uid;
  //     return Success(userId!);
  //   } catch (e) {
  //     return Failure(AuthException(message: 'Usuário não está logado'));
  //   }
  // }

  @override
  Output<void> logout() async {
    try {
      LoggedUser.logOut();
      await _auth.signOut();
      return Success(unit);
    } catch (e) {
      return Failure(AuthException(message: 'Erro ao fazer logout'));
    } finally {
      notifyListeners();
    }
  }

  @override
  Output<Unit> login(LoginParams loginParams) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginParams.email,
        password: loginParams.password,
      );

      if (userCredential.user == null) {
        return Failure(
          RepositoryException(
            message: 'Erro ao fazer login: usuário não encontrado',
          ),
        );
      }
      notifyListeners();

      return Success(unit);

      // return await _getUserById(userCredential.user!.uid).onSuccess(
      //   (success) {
      //     _saveLastLoginDate(success.id);
      //   },
      // );
    } on FirebaseAuthException catch (e, s) {
      Log.error('Error login', error: e, stackTrace: s);

      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário encontrado com este e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'E-mail ou senha incorretos';
      } else {
        errorMessage = 'Erro ao fazer login';
      }

      return Failure(RepositoryException(
        message: errorMessage,
      ));
    } catch (e, s) {
      Log.error('Error login', error: e, stackTrace: s);

      return Failure(
        RepositoryException(
          message: 'Erro inesperado ao fazer login',
        ),
      );
    }
  }

  @override
  Output<Unit> register(RegisterParams registerParams) async {
    UserCredential? userCredential;

    try {
      // Create user in Firebase Auth
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: registerParams.email,
        password: registerParams.password,
      );

      if (userCredential.user == null) {
        return Failure(
          RepositoryException(message: 'Erro ao criar usuário'),
        );
      }
      notifyListeners();
      return Success(unit);

      // final userData = registerParams.toMap();
      // userData['id'] = userCredential.user!.uid;

      // await _firestore.collection('users').doc(userData['id']).set(userData);

      // return Success(UserEntity.fromMap(userData));
    } on FirebaseAuthException catch (e, s) {
      Log.error('Error register', error: e, stackTrace: s);

      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Já existe uma conta com este e-mail.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O e-mail fornecido é inválido.';
      } else {
        errorMessage = 'Erro ao criar conta: ${e.message}';
      }

      userCredential?.user?.delete();

      return Failure(
        RepositoryException(
          message: errorMessage,
          errorCode: e.code,
        ),
      );
    } catch (e, s) {
      Log.error('Error register', error: e, stackTrace: s);

      userCredential?.user?.delete();

      return Failure(
        RepositoryException(
          message: 'Erro inesperado ao criar conta',
        ),
      );
    }
  }

  @override
  Output<Unit> saveLastLoginDate(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastLogin': DateTime.now(),
      });

      return Success(unit);
    } catch (e, s) {
      Log.error('Error _saveLastLoginDate', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro inesperado',
        ),
      );
    }
  }
}
