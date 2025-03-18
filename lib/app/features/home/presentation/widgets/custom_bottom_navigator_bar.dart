import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Modular.to.navigate('/home/');
    } else if (index == 1) {
      Modular.to.navigate('/appointment/');
    } else if (index == 2) {
      Modular.to.navigate('/home/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bottom-navigate',
      child: Material(
        child: SafeArea(
          bottom: true,
          child: Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryLigth,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(context, Icons.home, 'Home', 0),
                _buildNavItem(context, Icons.calendar_today, 'Agendamentos', 1),
                _buildNavItem(context, Icons.person, 'Perfil', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final primaryColor = AppColors.primaryColor;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.primaryColor,
                  size: 22,
                ),
              ],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected ? AppColors.primaryColor : AppColors.primaryColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
