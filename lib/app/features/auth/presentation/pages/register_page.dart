import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';

import '../../domain/validators/register_params_validator.dart';
import '../models/register_params.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authViewModel = Modular.get<AuthViewmodel>();

  MaskedTextController numberController =
      MaskedTextController(mask: '(00) 00000-0000');
  MaskedTextController cepController = MaskedTextController(mask: '00000-000');

  final _registerParams = RegisterParams.empty();
  final _validator = RegisterParamsValidator();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authViewModel.registerCommand.addListener(_listener);
  }

  _listener() {
    ResultHandler.showAlert(
      context: context,
      result: authViewModel.registerCommand.result,
      showSuccessAlert: false,
    );
  }

  @override
  void dispose() {
    authViewModel.registerCommand.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(17),
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Crie sua conta',
                  style: AppStyle.textTitle,
                ),
                Text(
                  'Digite seus dados para criar uma conta',
                  style: AppStyle.textSubTitle,
                ),
                const SizedBox(height: 30),
                TextInputDs(
                  label: 'Nome',
                  width: size.width,
                  onChanged: _registerParams.setName,
                  validator: _validator.byField(_registerParams, 'name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: AppTheme.inputSeparator),
                TextInputDs(
                  label: 'E-mail',
                  textInputType: TextInputType.emailAddress,
                  width: size.width,
                  onChanged: _registerParams.setEmail,
                  validator: _validator.byField(_registerParams, 'email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: AppTheme.inputSeparator),
                TextInputDs(
                  width: size.width,
                  label: 'Senha',
                  isPassword: true,
                  onChanged: _registerParams.setPassword,
                  validator: _validator.byField(_registerParams, 'password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: AppTheme.inputSeparator),
                TextInputDs(
                  width: size.width,
                  label: 'Confirmar senha',
                  isPassword: true,
                  onChanged: _registerParams.setConfirmPassword,
                  validator:
                      _validator.byField(_registerParams, 'confirmPassword'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: AppTheme.inputSeparator),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: ListenableBuilder(
                    listenable: authViewModel.registerCommand,
                    builder: (context, _) {
                      return PrimaryButtonDs(
                        title: 'Cadastrar',
                        isLoading: authViewModel.registerCommand.running,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            authViewModel.registerCommand
                                .execute(_registerParams);
                          }
                        },
                      );
                    },
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
