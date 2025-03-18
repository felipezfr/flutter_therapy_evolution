import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../design_system.dart';

class AppTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    colorSchemeSeed: AppColors.primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
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
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: AppColors.textBlackColor,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: AppColors.textBlackColor,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textBlackColor,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        color: AppColors.textBlackColor,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: AppColors.textBlackColor,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: AppColors.textBlackColor,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      displayLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
        color: AppColors.textBlackColor,
        fontSize: 140,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w300,
        color: AppColors.textBlackColor,
      ),
      headlineMedium: GoogleFonts.sourceSans3(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textBlackColor,
        fontStyle: FontStyle.normal,
      ),
    ),
  );
}
