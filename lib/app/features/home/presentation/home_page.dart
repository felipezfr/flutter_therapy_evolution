import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_viewmodel.dart';
import 'widgets/custom_bottom_navigator_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final viewModel = Modular.get<HomeViewmodel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bom dia, Simone',
                      style: AppStyle.textTitle,
                    ),
                    Text(
                      'Desejamos a você um ótimo dia!',
                      style: AppStyle.textSubTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    HomeCard(
                      title: 'Meus pacientes',
                      color: AppColors.primaryColor,
                      onTap: () {
                        Modular.to.pushNamed('/patient/');
                      },
                    ),
                    const SizedBox(width: 20),
                    HomeCard(
                      title: 'Evoluções',
                      color: AppColors.textGreyDark,
                      onTap: () {
                        Modular.to.pushNamed('/consultation/');
                      },
                    )
                  ],
                ),
                const SizedBox(height: 30),
                // PrimaryButtonDs(
                //   onPressed: () {
                //     Modular.to.pushNamed('/patient/');
                //   },
                //   title: 'Pacientes',
                // ),
                // const SizedBox(height: 20),
                // PrimaryButtonDs(
                //   onPressed: () {
                //     Modular.to.pushNamed('/consultation/');
                //   },
                //   title: 'Consultas',
                // ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  const HomeCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
