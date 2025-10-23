import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';
import '../l10n/app_localizations.dart';
import '../repositories/settings_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('settings'))),
      body: AnimatedBuilder(
        animation: settingsController,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SwitchListTile(
                title: Text(strings.t('dark_mode')),
                value: settingsController.isDark,
                onChanged: (value) => settingsController.toggleDarkMode(value),
              ),
              const SizedBox(height: 12),
              Text(strings.t('units'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  _SegmentButton(
                    label: strings.t('imperial'),
                    selected: settingsController.unitSystem == UnitSystem.imperial,
                    onTap: () => settingsController.setUnitSystem(UnitSystem.imperial),
                  ),
                  const SizedBox(width: 12),
                  _SegmentButton(
                    label: strings.t('metric'),
                    selected: settingsController.unitSystem == UnitSystem.metric,
                    onTap: () => settingsController.setUnitSystem(UnitSystem.metric),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(strings.t('locale'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButton<Locale>(
                value: settingsController.locale,
                items: AppLocalizations.supportedLocales
                    .map(
                      (locale) => DropdownMenuItem(
                        value: locale,
                        child: Text(locale.languageCode.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    settingsController.setLocale(value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE8FF66) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? Colors.black87 : Colors.black26),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
