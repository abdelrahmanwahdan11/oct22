import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/settings_repository.dart';
import 'design_system.dart';

ThemeData buildAppTheme(ThemeSetting themeSetting) {
  final isDark = themeSetting == ThemeSetting.dark;
  final baseColorScheme = ColorScheme.light(
    primary: AppColors.blue,
    secondary: AppColors.limeDark,
    surface: AppColors.surface,
    background: AppColors.backgroundTop,
    onPrimary: Colors.white,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
  );

  final darkColorScheme = ColorScheme.dark(
    primary: AppColors.blue,
    secondary: AppColors.limeDark,
    surface: const Color(0xFF111827),
    background: const Color(0xFF0F172A),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
  );

  final colorScheme = isDark ? darkColorScheme : baseColorScheme;

  final textTheme = GoogleFonts.interTextTheme().apply(
    bodyColor: isDark ? Colors.white : AppColors.textPrimary,
    displayColor: isDark ? Colors.white : AppColors.textPrimary,
  );

  return ThemeData(
    useMaterial3: false,
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor:
        isDark ? darkColorScheme.background : AppColors.backgroundTop,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: colorScheme,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.textPrimary),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: textTheme.labelLarge,
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textSecondary,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: AppColors.textPrimary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: AppColors.lime,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        ),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
    cardTheme: CardTheme(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
      ),
      elevation: 0,
      shadowColor: AppShadows.card.color,
      margin: EdgeInsets.zero,
    ),
  );
}
