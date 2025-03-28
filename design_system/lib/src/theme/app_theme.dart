import 'package:flutter/material.dart';

import '../../design_system.dart';

final _border = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(15),
);

class AppTheme {
  static const double borderRadius = 19;
  static const double padding = 20;
  static const double inputSeparator = 10;

  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    // colorSchemeSeed: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLigth,
      labelStyle: AppStyle.inputText,
      suffixStyle: AppStyle.inputText,
      contentPadding: const EdgeInsets.all(20),
      hintStyle: AppStyle.inputText,
      iconColor: AppColors.textGrey,
      suffixIconColor: AppColors.textGrey,
      prefixIconColor: AppColors.textGrey,
      border: _border,
      enabledBorder: _border,
      focusedBorder: _border,
      errorBorder: _border,
      disabledBorder: _border,
      focusedErrorBorder: _border,
    ),
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.primaryColor,
        size: 30,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.whiteColor,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: AppStyle.inputText,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.whiteColor),
        padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
      ),
    ),
  );
}
