import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AppImages.logo),
            const Gap(50),
            PrimaryButtonDs(
              title: 'Login',
              onPressed: () {
                router.go('/auth/login');
              },
            ),
            const Gap(20),
            PrimaryButtonDs(
              title: 'Registrar',
              onPressed: () {
                context.go('/auth/register');
              },
              backgroundColor: AppColors.secondaryColor,
            ),
            const Gap(20),
            Text(
              'Powered by Flutterando',
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
