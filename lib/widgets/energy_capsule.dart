import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppGradients.blueCapsule),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
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
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
            child: Text(
              trailing,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.blueDark,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
