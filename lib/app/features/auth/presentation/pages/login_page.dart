import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/alert/alerts.dart';
import 'package:flutter_therapy_evolution/app/core/command/result.dart';
import 'package:flutter_therapy_evolution/app/core/state_management/errors/repository_exception.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/validatoes/login_params_validator.dart';
import '../models/login_params.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authViewModel = Modular.get<AuthViewmodel>();

  final _loginParams = LoginParams.empty();
  final _validator = LoginParamsValidator();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authViewModel.loginCommand.addListener(listener);
  }

  listener() {
    final result = authViewModel.loginCommand.result;

    switch (result) {
      case Ok<UserEntity>():
        Modular.to.navigate('/home/');
      case Error<UserEntity>():
        Alerts.showFailure(
            context, (result.error as RepositoryException).message);
      case null:
    }
  }

  @override
  void dispose() {
    authViewModel.loginCommand.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'auth-logo',
                  child: const Image(image: AppImages.logo),
                ),
                const SizedBox(height: 50),
                TextInputDs(
                  label: 'E-mail',
                  onChanged: _loginParams.setEmail,
                  validator: _validator.byField(_loginParams, 'email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                TextInputDs(
                  label: 'Senha',
                  isPassword: true,
                  onChanged: _loginParams.setPassword,
                  validator: _validator.byField(_loginParams, 'password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: authViewModel.loginCommand,
                  builder: (context, child) {
                    return PrimaryButtonDs(
                      title: 'Login',
                      isLoading: authViewModel.loginCommand.running,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authViewModel.loginCommand.execute(_loginParams);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 18),
                RichText(
                  text: TextSpan(
                    text: 'Esqueceu a Senha? ',
                    style: theme.textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: 'Recupere aqui!',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: AppColors.blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                        // TODO: Reset Password redirect
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
