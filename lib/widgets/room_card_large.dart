import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/models/room.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class RoomCardLarge extends StatelessWidget {
  const RoomCardLarge({
    super.key,
    required this.room,
    required this.onTap,
    this.index = 0,
  });

  final Room room;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedReveal(
      delayFactor: index,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: AppMotion.slow,
              curve: AppMotion.curve,
              height: 220,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.xl),
                boxShadow: AppShadows.card,
                image: DecorationImage(
                  image: AssetImage(room.photo),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(Color(0xAA117BDB), BlendMode.srcOver),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadii.xl),
                  gradient: const LinearGradient(
                    colors: AppGradients.blueGlass,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _InfoChip(label: '${room.devicesActive}/${room.devicesTotal} Active'),
                        const SizedBox(width: 8),
                        _InfoChip(label: '${room.temperature}°C'),
                      ],
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 12,
                      children: const [
                        _DeviceQuick(label: 'ON/OFF', icon: Icons.power_settings_new),
                        _DeviceQuick(label: 'Lock', icon: Icons.lock_outline),
                        _DeviceQuick(label: 'Schedule', icon: Icons.schedule_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (room.favorite)
              Positioned(
                top: 16,
                right: 16,
                child: AnimatedContainer(
                  duration: AppMotion.base,
                  curve: AppMotion.curve,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, color: AppColors.warning, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.base,
      curve: AppMotion.curve,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}

class _DeviceQuick extends StatelessWidget {
  const _DeviceQuick({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
