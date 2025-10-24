import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const List<Color> accents = [
    Color(0xFF111111),
    Color(0xFF2563EB),
    Color(0xFFDC2626),
    Color(0xFF059669),
    Color(0xFF9333EA),
    Color(0xFF0EA5E9),
  ];

  static ThemeData light({Color? accent}) {
    final Color accentColor = accent ?? accents.first;
    final base = ThemeData(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
    final scheme = base.colorScheme.copyWith(
      primary: accentColor,
      onPrimary: accentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      primaryContainer: const Color(0xFFEDEDED),
      secondary: accentColor,
      onSecondary: accentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      secondaryContainer: const Color(0xFFF1EFE9),
      tertiary: const Color(0xFF9B9286),
      background: const Color(0xFFF5F4F6),
      onBackground: const Color(0xFF111111),
      surface: const Color(0xFFFFFFFF),
      surfaceTint: const Color(0xFFE7E9EF),
      onSurface: const Color(0xFF111111),
      outline: const Color(0xFFE7E9EF),
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF5F4F6),
      canvasColor: const Color(0xFFF1EFE9),
      textTheme: textTheme.apply(
        bodyColor: const Color(0xFF111111),
        displayColor: const Color(0xFF111111),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF111111)),
        toolbarHeight: 72,
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        margin: const EdgeInsets.all(0),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        tileColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary.withOpacity(0.2), width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        selectedItemColor: scheme.primary,
        unselectedItemColor: const Color(0xFF6B7280),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEDEDED),
        selectedColor: scheme.primary,
        secondarySelectedColor: scheme.primary,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        secondaryLabelStyle:
            textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: scheme.outline),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE7E9EF), thickness: 1),
      inputDecorationTheme: _inputTheme(light: true),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.primary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        contentTextStyle: textTheme.bodyMedium,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: const StadiumBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        showDragHandle: true,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: scheme.outline),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return scheme.primary;
          return scheme.surface;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return scheme.primary;
          return scheme.surface;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return scheme.primary.withOpacity(0.2);
          }
          return scheme.outline.withOpacity(0.3);
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return scheme.primary;
          return scheme.outline;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.outline,
      ),
    );
  }

  static ThemeData dark({Color? accent}) {
    final Color accentColor = accent ?? accents.firstWhere(
      (color) => color.computeLuminance() > 0.4,
      orElse: () => accents.first,
    );
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
    final scheme = base.colorScheme.copyWith(
      primary: accentColor,
      onPrimary: accentColor.computeLuminance() > 0.5 ? Colors.black : const Color(0xFF0E1115),
      primaryContainer: const Color(0xFF2A2F36),
      secondary: accentColor,
      onSecondary: accentColor.computeLuminance() > 0.5 ? Colors.black : const Color(0xFF0E1115),
      secondaryContainer: const Color(0xFF1E2127),
      tertiary: const Color(0xFF6B7280),
      background: const Color(0xFF0F1216),
      onBackground: Colors.white,
      surface: const Color(0xFF1E2127),
      surfaceTint: const Color(0xFF2A2F36),
      onSurface: Colors.white,
      outline: const Color(0xFF262A31),
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0F1216),
      canvasColor: const Color(0xFF171A1F),
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE5E7EB)),
        toolbarHeight: 72,
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        tileColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary.withOpacity(0.3), width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E2127),
        selectedItemColor: scheme.primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2F36),
        selectedColor: scheme.primary,
        secondarySelectedColor: scheme.primary,
        labelStyle: textTheme.labelLarge?.copyWith(color: Colors.white70),
        secondaryLabelStyle:
            textTheme.labelLarge?.copyWith(color: scheme.onPrimary, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: scheme.outline),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF262A31), thickness: 1),
      inputDecorationTheme: _inputTheme(light: false),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFFE5E7EB),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: const Color(0xFF0E1115)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        contentTextStyle: textTheme.bodyMedium,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: const StadiumBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        showDragHandle: true,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: scheme.outline),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return scheme.primary;
          return scheme.surface;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return scheme.primary;
          return scheme.surface;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return scheme.primary.withOpacity(0.25);
          }
          return scheme.outline.withOpacity(0.4);
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return scheme.primary;
          return scheme.outline;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.outline,
      ),
    );
  }

  static InputDecorationTheme _inputTheme({required bool light}) {
    final borderColor = light ? const Color(0xFFE7E9EF) : const Color(0xFF262A31);
    final fillColor = light ? const Color(0xFFF7F7F9) : const Color(0xFF14171C);
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
            BorderSide(color: light ? const Color(0xFF111111) : const Color(0xFFE5E7EB)),
      ),
      prefixIconColor: light
          ? const Color(0xFF6B7280)
          : const Color(0xFFE5E7EB).withOpacity(0.7),
      suffixIconColor: light
          ? const Color(0xFF6B7280)
          : const Color(0xFFE5E7EB).withOpacity(0.7),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: light ? const Color(0xFF6B7280) : Colors.white70,
      ),
    );
  }
}

class AppDecorations {
  static BoxDecoration gradientBackground({required bool dark}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: dark
            ? const [Color(0xFF0F1216), Color(0xFF171A1F)]
            : const [Color(0xFFF5F4F6), Color(0xFFF1EFE9)],
      ),
    );
  }

  static BoxDecoration glassCard({required bool dark}) {
    return BoxDecoration(
      color: dark
          ? const Color(0xFF1E2127).withOpacity(0.75)
          : const Color(0xFFFFFFFF).withOpacity(0.85),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: dark
            ? const Color(0xFF2A2F36).withOpacity(0.6)
            : const Color(0xFFE7E9EF).withOpacity(0.6),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(16, 24, 40, 0.08),
          blurRadius: 26,
          offset: Offset(0, 18),
        ),
      ],
    );
  }

  static BoxDecoration sectionSurface({required bool dark}) {
    return BoxDecoration(
      color: dark ? const Color(0xFF14171C) : const Color(0xFFF7F7F9),
      borderRadius: BorderRadius.circular(26),
    );
  }
}
