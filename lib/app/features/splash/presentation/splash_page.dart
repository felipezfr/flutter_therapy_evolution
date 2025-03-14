import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/session/logged_user.dart';

import '../../auth/data/repositories/auth_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final authRepository = Modular.get<IAuthRepository>();

  @override
  void initState() {
    super.initState();
    _userIsAuthenticatedListener();
    authRepository.addListener(_userIsAuthenticatedListener);
  }

  Future<void> _userIsAuthenticatedListener() async {
    final isAuthenticated = await authRepository.isAuthenticated;

    if (isAuthenticated) {
      final userId = await authRepository.userLoggedId;
      authRepository.saveLastLoginDate(userId);
      LoggedUser.setUserId = userId;
      Modular.to.navigate('/home/');
    } else {
      Modular.to.navigate('/auth/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
