import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TradeXColors extends ThemeExtension<TradeXColors> {
  const TradeXColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accent,
    required this.accentSoft,
    required this.profit,
    required this.loss,
    required this.muted,
  });

  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color accent;
  final Color accentSoft;
  final Color profit;
  final Color loss;
  final Color muted;

  static const dark = TradeXColors(
    bg: Color(0xFF0B0C0F),
    surface: Color(0xFF131417),
    surfaceAlt: Color(0xFF0F1013),
    surfaceSoft: Color(0xFF191B20),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xADFFFFFF),
    border: Color(0x14FFFFFF),
    accent: Color(0xFFC5F21F),
    accentSoft: Color(0x29C5F21F),
    profit: Color(0xFF22C55E),
    loss: Color(0xFFEF4444),
    muted: Color(0xFF9AA3AF),
  );

  static const light = TradeXColors(
    bg: Color(0xFFF6F7F9),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF3F4F6),
    surfaceSoft: Color(0xFFECEEF2),
    textPrimary: Color(0xFF0B0C0E),
    textSecondary: Color(0xFF6B7280),
    border: Color(0xFFE5E7EB),
    accent: Color(0xFF111111),
    accentSoft: Color(0x22111111),
    profit: Color(0xFF16A34A),
    loss: Color(0xFFDC2626),
    muted: Color(0xFF6B7280),
  );

  @override
  ThemeExtension<TradeXColors> copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? surfaceSoft,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? accent,
    Color? accentSoft,
    Color? profit,
    Color? loss,
    Color? muted,
  }) {
    return TradeXColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      profit: profit ?? this.profit,
      loss: loss ?? this.loss,
      muted: muted ?? this.muted,
    );
  }

  @override
  ThemeExtension<TradeXColors> lerp(ThemeExtension<TradeXColors>? other, double t) {
    if (other is! TradeXColors) return this;
    return TradeXColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      profit: Color.lerp(profit, other.profit, t)!,
      loss: Color.lerp(loss, other.loss, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}

class TradeXTheme {
  static ThemeData dark() {
    const colors = TradeXColors.dark;
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.surfaceAlt,
      colorScheme: ColorScheme.dark(
        primary: colors.accent,
        secondary: colors.accent,
        surface: colors.surface,
        background: colors.bg,
        error: colors.loss,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      dividerColor: colors.border,
      dialogBackgroundColor: colors.surface,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
      ),
      inputDecorationTheme: _inputTheme(colors),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceSoft,
        side: BorderSide(color: colors.border),
        selectedColor: colors.accentSoft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: textTheme.bodyMedium,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surfaceAlt,
        selectedItemColor: colors.textPrimary,
        unselectedItemColor: colors.muted,
        selectedIconTheme: const IconThemeData(size: 22),
        unselectedIconTheme: const IconThemeData(size: 22),
        showUnselectedLabels: true,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelMedium,
        type: BottomNavigationBarType.fixed,
      ),
      filledButtonTheme: FilledButtonThemeData(style: _primaryCapsule(colors, textTheme)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _primaryCapsule(colors, textTheme)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _ghostButton(colors, textTheme)),
      textButtonTheme: TextButtonThemeData(style: _ghostButton(colors, textTheme)),
      listTileTheme: ListTileThemeData(
        tileColor: colors.surface,
        iconColor: colors.textPrimary,
        textColor: colors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceSoft,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(colors.accentSoft),
        thickness: MaterialStateProperty.all(4),
        radius: const Radius.circular(4),
      ),
      extensions: const [colors],
    );
  }

  static ThemeData light() {
    const colors = TradeXColors.light;
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.surfaceAlt,
      colorScheme: ColorScheme.light(
        primary: colors.accent,
        secondary: colors.accent,
        surface: colors.surface,
        background: colors.bg,
        error: colors.loss,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      dividerColor: colors.border,
      dialogBackgroundColor: colors.surface,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
      ),
      inputDecorationTheme: _inputTheme(colors),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceSoft,
        side: BorderSide(color: colors.border),
        selectedColor: colors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(color: colors.surface),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.textPrimary,
        unselectedItemColor: colors.muted,
        selectedIconTheme: const IconThemeData(size: 22),
        unselectedIconTheme: const IconThemeData(size: 22),
        showUnselectedLabels: true,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelMedium,
        type: BottomNavigationBarType.fixed,
      ),
      filledButtonTheme: FilledButtonThemeData(style: _primaryCapsule(colors, textTheme)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _primaryCapsule(colors, textTheme)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _ghostButton(colors, textTheme)),
      textButtonTheme: TextButtonThemeData(style: _ghostButton(colors, textTheme)),
      listTileTheme: ListTileThemeData(
        tileColor: colors.surface,
        iconColor: colors.textPrimary,
        textColor: colors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceAlt,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(colors.accentSoft),
        thickness: MaterialStateProperty.all(4),
        radius: const Radius.circular(4),
      ),
      extensions: const [colors],
    );
  }

  static InputDecorationTheme _inputTheme(TradeXColors colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceSoft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.accent),
      ),
      hintStyle: TextStyle(color: colors.textSecondary),
    );
  }

  static ButtonStyle _primaryCapsule(
    TradeXColors colors,
    TextTheme textTheme,
  ) {
    return FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: const StadiumBorder(),
      backgroundColor: colors.textPrimary,
      foregroundColor: colors.bg,
      textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 24),
    ).merge(
      ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed)
              ? colors.accentSoft
              : null,
        ),
      ),
    );
  }

  static ButtonStyle _ghostButton(
    TradeXColors colors,
    TextTheme textTheme,
  ) {
    return OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: const StadiumBorder(),
      side: BorderSide(color: colors.border),
      foregroundColor: colors.textPrimary,
      textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  static TradeXColors colorsOf(BuildContext context) {
    final extension = Theme.of(context).extension<TradeXColors>();
    assert(extension != null, 'TradeXColors extension not found');
    return extension ?? TradeXColors.dark;
  }
}

extension TradeXTextStyles on TextTheme {
  TextStyle get display => headlineMedium!.copyWith(fontSize: 34, fontWeight: FontWeight.w700);

  TextStyle get h1 => headlineSmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600);

  TextStyle get h2 => titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w600);

  TextStyle get h3 => titleMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w600);

  TextStyle get body => bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  TextStyle get caption => bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w400);
}
