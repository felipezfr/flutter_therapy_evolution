import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/services/session_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final sessionService = Modular.get<SessionService>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final isUserLoggedIn = await sessionService.isUserLoggedIn();

    if (isUserLoggedIn) {
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
