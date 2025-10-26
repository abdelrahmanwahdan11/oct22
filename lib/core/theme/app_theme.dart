import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData buildLightTheme() {
    final palette = AppColors.light;
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.light,
        primary: palette.accent,
        secondary: palette.accentAlt,
        surface: palette.surface,
        background: palette.bgBottom,
        error: palette.danger,
      ),
      scaffoldBackgroundColor: palette.bgBottom,
      canvasColor: palette.bgTop,
      textTheme: _textTheme(palette),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: _textTheme(palette).titleLarge,
        foregroundColor: palette.textPrimary,
      ),
      cardTheme: CardTheme(
        color: palette.surface.withOpacity(0.96),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
      ),
      dividerColor: palette.border,
      chipTheme: _chipTheme(base.chipTheme, palette),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface.withOpacity(0.94),
        selectedItemColor: palette.accent,
        unselectedItemColor: palette.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        textColor: palette.textPrimary,
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    final palette = AppColors.dark;
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: palette.accent,
        secondary: palette.accentAlt,
        surface: palette.surface,
        background: palette.bgBottom,
        error: palette.danger,
      ),
      scaffoldBackgroundColor: palette.bgBottom,
      canvasColor: palette.bgTop,
      textTheme: _textTheme(palette, isDark: true),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: _textTheme(palette, isDark: true).titleLarge,
        foregroundColor: palette.textPrimary,
      ),
      cardTheme: CardTheme(
        color: palette.surface.withOpacity(0.92),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
      ),
      dividerColor: palette.border,
      chipTheme: _chipTheme(base.chipTheme, palette),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface.withOpacity(0.9),
        selectedItemColor: palette.accent,
        unselectedItemColor: palette.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        textColor: palette.textPrimary,
      ),
    );
  }

  static TextTheme _textTheme(AppPalette palette, {bool isDark = false}) {
    final base = GoogleFonts.poppinsTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: palette.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: palette.textSecondary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: palette.textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.black : Colors.white,
      ),
    );
  }

  static ChipThemeData _chipTheme(ChipThemeData base, AppPalette palette) {
    return base.copyWith(
      backgroundColor: palette.surface.withOpacity(0.72),
      selectedColor: palette.accent.withOpacity(0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: palette.border),
      ),
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: palette.textPrimary,
      ),
      secondaryLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: palette.accent,
      ),
    );
  }
}
