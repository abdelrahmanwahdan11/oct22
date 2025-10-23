import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../models/models.dart';

class CompartmentCard extends StatelessWidget {
  const CompartmentCard({
    super.key,
    required this.compartment,
    required this.onAccept,
  });

  final Compartment compartment;
  final ValueChanged<String> onAccept;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progress = compartment.capacityLb == 0
        ? 0.0
        : compartment.currentLb / compartment.capacityLb;
    return DragTarget<String>(
      onWillAccept: (_) => true,
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        final isActive = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: AppMotion.fast,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
            boxShadow: [AppShadows.soft],
            border: Border.all(
              color: isActive ? AppColors.limeDark : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    compartment.label,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${compartment.currentLb}/${compartment.capacityLb} lb',
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  return Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: AppMotion.base,
                        curve: AppMotion.curve,
                        width: maxWidth * progress.clamp(0.0, 1.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.lime, AppColors.limeDark],
                          ),
                          borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
