import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_viewmodel.dart';

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
                Modular.to.pushNamed('/schedule/');
              },
              title: 'Agendamentos',
            ),
            Spacer(),
            BottomSheet()
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomIcon(
                  onTap: () {},
                  iconData: Icons.home,
                  isSelected: false,
                ),
                BottomIcon(
                  onTap: () {},
                  iconData: Icons.app_registration_rounded,
                  isSelected: false,
                ),
                BottomIcon(
                  onTap: () async {
                    Modular.to.pushNamed('/home/profile');
                  },
                  iconData: Icons.person_2_sharp,
                  isSelected: true,
                ),
              ],
            ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomIcon({
    super.key,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          iconData,
          color: isSelected ? AppColors.blueLigth : AppColors.greyDark,
          size: 32,
        ),
      ),
    );
  }
}
