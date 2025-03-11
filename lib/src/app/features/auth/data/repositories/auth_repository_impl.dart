import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../../core/errors/errors.dart';
import '../../../../../core/typedefs/types.dart';
import '../../domain/dtos/login_params.dart';
import '../../domain/dtos/register_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../models/reponse/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Output<AuthEntity> login(
    LoginParams params,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      if (userCredential.user == null) {
        return Failure(
          ServerException(
            message: 'Erro ao fazer login: usuário não encontrado',
            error: 'user-not-found',
          ),
        );
      }

      // Buscar dados adicionais do usuário no Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        return Failure(
          ServerException(
            message: 'Dados do usuário não encontrados',
            error: 'user-data-not-found',
          ),
        );
      }

      final userData = userDoc.data()!;

      final user = UserEntity(
        id: userCredential.user!.uid,
        name: userData['name'] as String,
        email: userData['email'] as String,
      );

      final accessToken = await userCredential.user!.getIdToken();

      return Success(
        AuthEntity(
          user: user,
          accessToken: accessToken ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário encontrado com este e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta.';
      } else {
        errorMessage = 'Erro ao fazer login: ${e.message}';
      }
      return Failure(
        ServerException(
          message: errorMessage,
          error: e.code,
        ),
      );
    } catch (e) {
      return Failure(
        ServerException(
          message: 'Erro inesperado ao fazer login',
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Output<UserEntity> signUp(RegisterParams params) async {
    UserCredential? userCredential;

    try {
      // Create user in Firebase Auth
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      if (userCredential.user == null) {
        return Failure(
          ServerException(
            message: 'Erro ao criar usuário',
            error: 'user-creation-failed',
          ),
        );
      }

      userCredential.user?.delete();

      // Create user document in Firestore
      final userData = params.toModel().toMap();

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      userData['id'] = userCredential.user!.uid;

      final user = UserModel.fromMap(userData);

      return Success(user);
    } on FirebaseAuthException catch (e) {
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
        ServerException(
          message: errorMessage,
          error: e.code,
        ),
      );
    } catch (e) {
      userCredential?.user?.delete();

      return Failure(
        ServerException(
          message: 'Erro inesperado ao criar conta',
          error: e.toString(),
        ),
      );
    }
  }
}
