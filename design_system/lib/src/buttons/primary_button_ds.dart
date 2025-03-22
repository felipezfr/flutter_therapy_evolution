import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButtonDs extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color textColor;
  final double height;
  final double width;
  final bool isLoading;

  const PrimaryButtonDs({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = Colors.white,
    this.textColor = Colors.white,
    this.height = 48,
    this.width = 220,
    this.isLoading = false,
  });

  factory PrimaryButtonDs.secondary({
    required String title,
    required VoidCallback onPressed,
    Color backgroundColor = AppColors.secondaryColor,
    Color foregroundColor = AppColors.greyDark,
    Color textColor = AppColors.textBlackColor,
    double height = 48,
    double width = 220,
    bool isLoading = false,
  }) {
    return PrimaryButtonDs(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textColor: textColor,
      title: title,
      isLoading: isLoading,
      height: height,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        fixedSize: Size(width, height),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(color: textColor),
            ),
    );
  }
}
