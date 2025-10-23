import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../models/models.dart';

class TruckSideDiagram extends StatelessWidget {
  const TruckSideDiagram({
    super.key,
    required this.vehicle,
    this.onTapCompartment,
  });

  final Vehicle vehicle;
  final ValueChanged<Compartment>? onTapCompartment;

  @override
  Widget build(BuildContext context) {
    final compartments = vehicle.compartments;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusXL.x),
        boxShadow: [AppShadows.card],
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.radiusXL.x),
                child: Image.asset(
                  'assets/images/truck_side.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            for (var i = 0; i < compartments.length; i++)
              _CompartmentOverlay(
                alignment: Alignment(-0.4 + i * 0.4, 0.35),
                compartment: compartments[i],
                onTap: onTapCompartment,
              ),
          ],
        ),
      ),
    );
  }
}

class _CompartmentOverlay extends StatelessWidget {
  const _CompartmentOverlay({
    required this.alignment,
    required this.compartment,
    this.onTap,
  });

  final Alignment alignment;
  final Compartment compartment;
  final ValueChanged<Compartment>? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(compartment),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.limeSoft,
            borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
            border: Border.all(color: AppColors.limeDark, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2, size: 18, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text(
                '${compartment.label} • ${compartment.currentLb}/${compartment.capacityLb}',
                style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
