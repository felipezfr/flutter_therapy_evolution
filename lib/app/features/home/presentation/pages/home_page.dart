import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        child: Expanded(
          child: Center(
            child: Text('data'),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomIcon(
                  iconData: Icons.home,
                  isSelected: false,
                ),
                BottomIcon(
                  iconData: Icons.app_registration_rounded,
                  isSelected: false,
                ),
                BottomIcon(
                  iconData: Icons.person_2_sharp,
                  isSelected: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData iconData;
  final bool isSelected;
  const BottomIcon({
    super.key,
    required this.iconData,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
