import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AppImages.logo,
              fit: BoxFit.fill,
            ),
            const Gap(50),
            PrimaryButtonDs(
              title: 'Login',
              onPressed: () {
                Modular.to.pushNamed('/auth/login');
              },
            ),
            const Gap(20),
            PrimaryButtonDs(
              title: 'Registrar',
              onPressed: () {
                Modular.to.pushNamed('/auth/register');
              },
              backgroundColor: AppColors.secondaryColor,
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
