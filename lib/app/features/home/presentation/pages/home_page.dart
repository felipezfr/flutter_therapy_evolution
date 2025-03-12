import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/services/session_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sessionService = Modular.get<SessionService>();

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
            BottomSheet(sessionService: sessionService)
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
    required this.sessionService,
  });

  final SessionService sessionService;

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
                    await sessionService.logout();
                    Modular.to.navigate('/');
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
