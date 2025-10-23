import 'package:flutter/material.dart';

class AppColors {
  static const backgroundTop = Color(0xFFF7F8F5);
  static const backgroundBottom = Color(0xFFEEF6D7);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF101828);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE6EAF0);
  static const lime = Color(0xFFE8FF66);
  static const limeDark = Color(0xFFC7EF35);
  static const limeSoft = Color(0x2DE8FF66);
  static const blue = Color(0xFF1F6FEB);
  static const danger = Color(0xFFEE4B2B);
}

class AppRadii {
  static const Radius radiusXXL = Radius.circular(28);
  static const Radius radiusXL = Radius.circular(22);
  static const Radius radiusLG = Radius.circular(16);
  static const Radius radiusMD = Radius.circular(12);
  static const Radius radiusSM = Radius.circular(10);
  static const Radius radiusChip = Radius.circular(20);
  static const Radius radiusBottomBar = Radius.circular(24);

  static const BorderRadius card = BorderRadius.all(radiusLG);
  static const BorderRadius sheet = BorderRadius.vertical(top: radiusXXL);
}

class AppShadows {
  static final soft = BoxShadow(
    color: const Color(0x0F101828),
    blurRadius: 24,
    offset: const Offset(0, 6),
  );

  static final card = BoxShadow(
    color: const Color(0x14101828),
    blurRadius: 30,
    offset: const Offset(0, 10),
  );
}

class AppMotion {
  static const fast = Duration(milliseconds: 140);
  static const base = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 300);
  static const curve = Cubic(0.2, 0.8, 0.2, 1);
}

class AppGradients {
  static const background = LinearGradient(
    colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
