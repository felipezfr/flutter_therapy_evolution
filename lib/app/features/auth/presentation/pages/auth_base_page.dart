import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.padding),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * .11),
                Hero(
                  tag: 'auth-logo',
                  child: const Image(
                    image: AppImages.logo,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: size.height * .11),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Oque nos fazemos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Milhares de fonoaudiólogos confiam no Therapy Evolution para gerenciar pacientes, consultas, registros clínicos e atendimentos.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PrimaryButtonDs(
                  title: 'Cadastre-se',
                  onPressed: () {
                    Modular.to.pushNamed('/auth/register');
                  },
                ),
                TextButton(
                  onPressed: () {
                    Modular.to.pushNamed('/auth/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'JÁ TEM UMA CONTA?',
                        style: TextStyle(
                          color: AppColors.textGrey,
                        ),
                      ),
                      Text(
                        ' FAÇA LOGIN',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * .05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
