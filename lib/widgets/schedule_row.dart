import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class ScheduleRow extends StatelessWidget {
  const ScheduleRow({
    super.key,
    required this.start,
    required this.end,
    required this.enabled,
    required this.onChange,
    required this.onPickTime,
  });

  final String start;
  final String end;
  final bool enabled;
  final Future<void> Function(bool enabled) onChange;
  final Future<void> Function(bool isStart) onPickTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Schedule', style: theme.textTheme.titleMedium),
              const Spacer(),
              Switch(value: enabled, onChanged: (value) => onChange(value)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TimeTile(
                  label: 'Start Time',
                  value: start,
                  onTap: () => onPickTime(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimeTile(
                  label: 'End Time',
                  value: end,
                  onTap: () => onPickTime(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
