import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * .15),
              Hero(
                tag: 'auth-logo',
                child: const Image(
                  image: AppImages.logo,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Bem-vindo ao aplicativo...",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              ),
              PrimaryButtonDs(
                title: 'Login',
                onPressed: () {
                  Modular.to.pushNamed('/auth/login');
                },
              ),
              const SizedBox(height: 20),
              PrimaryButtonDs.secondary(
                title: 'Registrar',
                onPressed: () {
                  Modular.to.pushNamed('/auth/register');
                },
              ),
              SizedBox(height: size.height * .05),
            ],
          ),
        ),
      ),
    );
  }
}
