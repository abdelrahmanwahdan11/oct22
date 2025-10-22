import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_home_control/core/design_tokens.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    brightness: brightness,
    background: AppColors.bg,
    surface: AppColors.surface,
  );

  final textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: AppTypography.h1,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: AppTypography.h2,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: AppTypography.h3,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: AppTypography.label,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
  );

  final chipTheme = ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.chip),
      side: const BorderSide(color: AppColors.border),
    ),
    backgroundColor: AppColors.surface,
    selectedColor: AppColors.blueSoft,
    labelStyle: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      color: AppColors.textPrimary,
    ),
    secondaryLabelStyle: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      color: AppColors.blueDark,
      fontWeight: FontWeight.w500,
    ),
  );

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: AppTypography.body,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    chipTheme: chipTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: AppTypography.h2,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      foregroundColor: AppColors.textPrimary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.textPrimary,
      unselectedItemColor: AppColors.textSecondary,
      selectedIconTheme: const IconThemeData(color: AppColors.blueDark),
      unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
      selectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}
