import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_therapy_evolution/app/core/log/log_manager.dart';
import 'package:flutter_therapy_evolution/app/core/state_management/errors/repository_exception.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/dtos/user_adapter.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/models/login_params.dart';

import '../../../../core/command/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../presentation/models/register_params.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<Result<UserEntity>> login(LoginParams loginParams) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginParams.email,
        password: loginParams.password,
      );

      if (userCredential.user == null) {
        throw RepositoryException(
          message: 'Erro ao fazer login: usuário não encontrado',
        );
      }

      // Buscar dados adicionais do usuário no Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw RepositoryException(
          message: 'Dados do usuário não encontrados',
        );
      }

      final userData = userDoc.data()!;

      return Result.ok(UserAdapter.fromMap(userData));
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
        errorMessage = 'Erro ao fazer login: ${e.message}';
      }

      return Result.error(RepositoryException(
        message: errorMessage,
      ));
    } catch (e, s) {
      Log.error('Error login', error: e, stackTrace: s);

      return Result.error(
        RepositoryException(
          message: 'Erro inesperado ao fazer login',
        ),
      );
    }
  }

  @override
  Future<Result<UserEntity>> register(RegisterParams registerParams) async {
    UserCredential? userCredential;

    try {
      // Create user in Firebase Auth
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: registerParams.email,
        password: registerParams.password,
      );

      if (userCredential.user == null) {
        return Result.error(
          RepositoryException(
            message: 'Erro ao criar usuário',
            errorCode: 'user-creation-failed',
          ),
        );
      }

      final userData = registerParams.toMap();
      userData['id'] = userCredential.user!.uid;

      await _firestore.collection('users').doc(userData['id']).set(userData);

      final user = registerParams.toUserEntity();

      return Result.ok(user);
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

      return Result.error(
        RepositoryException(
          message: errorMessage,
          errorCode: e.code,
        ),
      );
    } catch (e, s) {
      Log.error('Error register', error: e, stackTrace: s);

      userCredential?.user?.delete();

      return Result.error(
        RepositoryException(
          message: 'Erro inesperado ao criar conta',
        ),
      );
    }
  }
}
