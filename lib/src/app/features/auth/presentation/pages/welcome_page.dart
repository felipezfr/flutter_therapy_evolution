import 'dart:developer';
import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: size.width * 0.55,
                  height: size.width * 0.55,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xffEFEFF1),
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AppIcons.uploadIcon,
                                width: 55,
                                height: 55,
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const Gap(40),
              Text(
                'Olá Mariana,',
                style: theme.textTheme.displaySmall,
              ),
              Text(
                'Seja bem-vinda!',
                style: theme.textTheme.displaySmall,
              ),
              Gap(size.height * 0.3),
              PrimaryButtonDs(
                title: 'Começar',
                onPressed: () async {
                  if (_imageFile != null) {
                    log(_imageFile!.lengthSync().toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
