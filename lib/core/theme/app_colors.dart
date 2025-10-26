import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.bgTop,
    required this.bgBottom,
    required this.surface,
    required this.surfaceGlass,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accent,
    required this.accentAlt,
    required this.warn,
    required this.danger,
  });

  final Color bgTop;
  final Color bgBottom;
  final Color surface;
  final Color surfaceGlass;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color accent;
  final Color accentAlt;
  final Color warn;
  final Color danger;
}

class AppColors {
  static const _surfaceGlassOpacity = 0.72;

  static final light = AppPalette(
    bgTop: const Color(0xFFF6F8F7),
    bgBottom: const Color(0xFFEFF4F1),
    surface: Colors.white,
    surfaceGlass: Colors.white.withOpacity(_surfaceGlassOpacity),
    textPrimary: const Color(0xFF0E1116),
    textSecondary: const Color(0x9E0E1116),
    border: const Color(0x140E1116),
    accent: const Color(0xFF4AC6A8),
    accentAlt: const Color(0xFF9DD36A),
    warn: const Color(0xFFF59E0B),
    danger: const Color(0xFFEF4444),
  );

  static final dark = AppPalette(
    bgTop: const Color(0xFF0E1116),
    bgBottom: const Color(0xFF131821),
    surface: const Color(0xFF171C24),
    surfaceGlass: const Color(0xFF171C24).withOpacity(_surfaceGlassOpacity),
    textPrimary: Colors.white,
    textSecondary: const Color(0xADFFFFFF),
    border: const Color(0x14FFFFFF),
    accent: const Color(0xFF49D2B1),
    accentAlt: const Color(0xFFA1DD70),
    warn: const Color(0xFFFBBF24),
    danger: const Color(0xFFF87171),
  );
}

class AppGradients {
  static const hero = LinearGradient(
    colors: [Color(0x00000000), Color(0x66000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const accent = LinearGradient(
    colors: [Color(0xFF49D2B1), Color(0xFF89E470)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const card = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF7FAF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppRadii {
  static const xxl = Radius.circular(28);
  static const xl = Radius.circular(22);
  static const lg = Radius.circular(18);
  static const md = Radius.circular(14);
  static const sm = Radius.circular(10);
  static const chip = Radius.circular(20);
  static const pill = Radius.circular(32);
}
