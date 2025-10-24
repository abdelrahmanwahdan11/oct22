import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF111111),
        secondary: Color(0xFF111111),
        background: Color(0xFFF5F4F6),
        surface: Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F4F6),
      canvasColor: const Color(0xFFF1EFE9),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFF111111),
        displayColor: const Color(0xFF111111),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF111111),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF111111)),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        selectedItemColor: const Color(0xFF111111),
        unselectedItemColor: const Color(0xFF6B7280),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEDEDED),
        selectedColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF111111),
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFFFFFF),
        ),
      ),
      dividerColor: const Color(0xFFE7E9EF),
      inputDecorationTheme: _inputTheme(light: true),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF111111),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        showDragHandle: true,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE5E7EB),
        secondary: Color(0xFFE5E7EB),
        background: Color(0xFF0F1216),
        surface: Color(0xFF1E2127),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1216),
      canvasColor: const Color(0xFF171A1F),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFFFFFFFF),
        displayColor: const Color(0xFFFFFFFF),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFFFFFF),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE5E7EB)),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E2127),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E2127),
        selectedItemColor: const Color(0xFFE5E7EB),
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2F36),
        selectedColor: const Color(0xFFE5E7EB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFE5E7EB),
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0E1115),
        ),
      ),
      dividerColor: const Color(0xFF262A31),
      inputDecorationTheme: _inputTheme(light: false),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFE5E7EB),
        foregroundColor: Color(0xFF0E1115),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1E2127),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        showDragHandle: true,
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
}
