import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../design_system.dart';

class AppTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.blueLigth,
    colorSchemeSeed: AppColors.primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blueLigth,
      iconTheme: IconThemeData(
        color: AppColors.primaryColor,
        size: 30,
      ),
    ),
    drawerTheme: const DrawerThemeData(
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
      labelLarge: GoogleFonts.roboto(
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryColor,
      ),
      labelMedium: GoogleFonts.roboto(
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      ),
      labelSmall: GoogleFonts.mulish(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryColor,
      ),
      titleMedium: GoogleFonts.roboto(
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
      ),
      titleSmall: GoogleFonts.mulish(
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor,
      ),
      bodySmall: GoogleFonts.roboto(
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      displayLarge: GoogleFonts.roboto(
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
        fontSize: 140,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w300,
        color: AppColors.secondaryColor,
        fontStyle: FontStyle.italic,
      ),
      headlineMedium: GoogleFonts.sourceSans3(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.secondaryColor,
        fontStyle: FontStyle.normal,
      ),
    ),
  );
}
