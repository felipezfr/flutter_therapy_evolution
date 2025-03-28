import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';

import '../../domain/validators/login_params_validator.dart';
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
    authViewModel.loginCommand.addListener(_listener);
  }

  _listener() {
    ResultHandler.showAlert(
      context: context,
      result: authViewModel.loginCommand.result,
      showSuccessAlert: false,
    );
  }

  @override
  void dispose() {
    authViewModel.loginCommand.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                  Text(
                    'Bem-vindo de volta!',
                    style: AppStyle.textTitle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Entre com seu email e senha',
                    style: AppStyle.textSubTitle,
                  ),
                  const SizedBox(height: 40),
                  TextInputDs(
                    label: 'Email',
                    onChanged: _loginParams.setEmail,
                    validator: _validator.byField(_loginParams, 'email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: AppTheme.inputSeparator),
                  TextInputDs(
                    label: 'Senha',
                    isPassword: true,
                    onChanged: _loginParams.setPassword,
                    validator: _validator.byField(_loginParams, 'password'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Esqueceu a Senha? ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
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
                  // const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      Modular.to.pushNamed('/auth/register');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'NÃO POSSUI CONTA?',
                          style: TextStyle(
                            color: AppColors.textGrey,
                          ),
                        ),
                        Text(
                          ' REGISTRE-SE!',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
