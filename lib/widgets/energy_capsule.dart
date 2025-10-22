import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class EnergyCapsule extends StatelessWidget {
  const EnergyCapsule({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedReveal(
      child: AnimatedContainer(
        duration: AppMotion.slow,
        curve: AppMotion.curve,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppGradients.blueCapsule),
          borderRadius: BorderRadius.circular(AppRadii.xl),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.curve,
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: const Icon(Icons.bolt, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.curve,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadii.chip),
              ),
              child: Text(
                trailing,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.blueDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
