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
      appBar: AppBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            PrimaryButtonDs(
              onPressed: () {
                Modular.to.pushNamed('/patient/');
              },
              title: 'Pacientes',
            ),
            const SizedBox(height: 20),
            PrimaryButtonDs(
              onPressed: () {
                Modular.to.pushNamed('/consultation/');
              },
              title: 'Consultas',
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
