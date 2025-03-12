import 'dart:developer';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/command/result.dart';
import 'package:gap/gap.dart';

import '../../../../core/alert/alerts.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/validatoes/register_params_validator.dart';
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
    authViewModel.registerCommand.addListener(listener);
  }

  listener() {
    final result = authViewModel.registerCommand.result;

    switch (result) {
      case Ok<UserEntity>():
        print('Go to home');
      case Error<UserEntity>():
        print('Erro');
        Alerts.showFailure(
            context, (result.error as RepositoryException).message);
      case null:
    }

    // if (authViewModel.registerCommand.completed) {
    //   Modular.to.navigate('/home/');
    // }

    print(result);
  }

  @override
  void dispose() {
    // authViewmodel.signUpCommand.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cadastro',
                  style: theme.textTheme.displaySmall,
                ),
                const Gap(29),
                TextInputDs(
                  label: 'Nome',
                  width: size.width,
                  onChanged: _registerParams.setName,
                  validator: _validator.byField(_registerParams, 'name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                TextInputDs(
                  label: 'E-mail',
                  textInputType: TextInputType.emailAddress,
                  width: size.width,
                  onChanged: _registerParams.setEmail,
                  validator: _validator.byField(_registerParams, 'email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                TextInputDs(
                  width: size.width,
                  label: 'Senha',
                  isPassword: true,
                  onChanged: _registerParams.setPassword,
                  validator: _validator.byField(_registerParams, 'password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                TextInputDs(
                  width: size.width,
                  label: 'Confirmar senha',
                  isPassword: true,
                  onChanged: _registerParams.setConfirmPassword,
                  validator:
                      _validator.byField(_registerParams, 'confirmPassword'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                const Gap(40),
                Align(
                  alignment: Alignment.center,
                  child: ListenableBuilder(
                    listenable: authViewModel.registerCommand,
                    builder: (context, _) {
                      // if (authViewModel.registerCommand.running) {
                      //   return const Center(child: CircularProgressIndicator());
                      // }
                      if (authViewModel.registerCommand.error) {
                        log('Error');
                      }

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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
