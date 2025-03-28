import 'package:flutter/material.dart';

import '../../design_system.dart';

class CardTile extends StatelessWidget {
  final String title;
  final String text;
  const CardTile({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textGreyDark,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
