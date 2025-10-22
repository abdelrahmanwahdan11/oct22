import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_home_control/core/design_tokens.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final background = isDark ? AppDarkColors.bg : AppColors.bg;
  final surface = isDark ? AppDarkColors.surface : AppColors.surface;
  final textPrimary = isDark ? AppDarkColors.textPrimary : AppColors.textPrimary;
  final textSecondary = isDark ? AppDarkColors.textSecondary : AppColors.textSecondary;
  final borderColor = isDark ? AppDarkColors.border : AppColors.border;
  final chipSelected = isDark ? AppDarkColors.blueSoft : AppColors.blueSoft;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    brightness: brightness,
  ).copyWith(
    background: background,
    surface: surface,
    onBackground: textPrimary,
    onSurface: textPrimary,
  );

  final textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: AppTypography.h1,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: AppTypography.h2,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: AppTypography.h3,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      fontWeight: FontWeight.w400,
      color: textSecondary,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: AppTypography.label,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
  );

  final chipTheme = ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.chip),
      side: BorderSide(color: borderColor),
    ),
    backgroundColor: surface,
    selectedColor: chipSelected,
    labelStyle: GoogleFonts.poppins(
      fontSize: AppTypography.body,
      color: textPrimary,
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
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: AppTypography.h2,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      foregroundColor: textPrimary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: textSecondary,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: textSecondary),
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
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: BorderSide(color: borderColor),
      ),
    ),
  );
}
