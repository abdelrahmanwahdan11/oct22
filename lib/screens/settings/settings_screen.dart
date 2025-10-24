import 'package:flutter/material.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/filters_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final accentOptions = AppTheme.accents;
    final featureDefinitions = [
      {'id': 'show_saved_filters', 'label': strings.t('feature_saved_filters'), 'description': strings.t('feature_saved_filters_hint')},
      {'id': 'show_neighborhood_guides', 'label': strings.t('feature_neighborhoods'), 'description': strings.t('feature_neighborhoods_hint')},
      {'id': 'show_virtual_tours', 'label': strings.t('feature_virtual_tours'), 'description': strings.t('feature_virtual_tours_hint')},
      {'id': 'show_events', 'label': strings.t('feature_events'), 'description': strings.t('feature_events_hint')},
      {'id': 'show_service_directory', 'label': strings.t('feature_services'), 'description': strings.t('feature_services_hint')},
      {'id': 'show_market_headlines', 'label': strings.t('feature_headlines'), 'description': strings.t('feature_headlines_hint')},
      {'id': 'show_sustainability_toggle', 'label': strings.t('feature_sustainability'), 'description': strings.t('feature_sustainability_hint')},
      {'id': 'show_price_per_m2', 'label': strings.t('feature_price_per_m2'), 'description': strings.t('feature_price_per_m2_hint')},
      {'id': 'agent_recommendations', 'label': strings.t('feature_agents'), 'description': strings.t('feature_agents_hint')},
      {'id': 'compare_tool', 'label': strings.t('feature_compare'), 'description': strings.t('feature_compare_hint')},
      {'id': 'alert_center', 'label': strings.t('feature_alerts'), 'description': strings.t('feature_alerts_hint')},
      {'id': 'notes_manager', 'label': strings.t('feature_notes'), 'description': strings.t('feature_notes_hint')},
      {'id': 'export_tools', 'label': strings.t('feature_exports'), 'description': strings.t('feature_exports_hint')},
      {'id': 'milestones_tracker', 'label': strings.t('feature_milestones'), 'description': strings.t('feature_milestones_hint')},
      {'id': 'market_digest', 'label': strings.t('feature_market_digest'), 'description': strings.t('feature_market_digest_hint')},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(strings.t('appearance_section'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            title: Text(strings.t('dark_mode')),
            value: settings.isDarkMode,
            onChanged: (value) => settings.toggleDarkMode(value),
          ),
          const SizedBox(height: 12),
          Text(strings.t('accent_color'),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < accentOptions.length; i++)
                GestureDetector(
                  onTap: () => settings.setAccentIndex(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentOptions[i],
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: settings.accentIndex == i
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.outline,
                        width: settings.accentIndex == i ? 2.4 : 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(strings.t('text_size'),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          Slider(
            value: settings.textScale,
            min: 0.9,
            max: 1.3,
            divisions: 8,
            label: settings.textScale.toStringAsFixed(2),
            onChanged: (value) => settings.setTextScale(value),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: Text(strings.t('language')),
            trailing: DropdownButton<String>(
              value: settings.locale.languageCode,
              items: AppLocalizations.supportedLocales
                  .map(
                    (locale) => DropdownMenuItem(
                      value: locale.languageCode,
                      child: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
                    ),
                  )
                  .toList(),
              onChanged: (code) {
                if (code == null) return;
                settings.setLocale(Locale(code));
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(strings.t('feature_center'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final feature in featureDefinitions)
            SwitchListTile.adaptive(
              title: Text(feature['label']!),
              subtitle: Text(feature['description']!),
              value: settings.featureEnabled(feature['id']!),
              onChanged: (value) => settings.setFeatureToggle(feature['id']!, value),
            ),
          const SizedBox(height: 20),
          Text(strings.t('data_section'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            title: Text(strings.t('enable_notifications')),
            subtitle: Text(strings.t('enable_notifications_hint')),
            value: settings.featureEnabled('enable_notifications'),
            onChanged: (value) => settings.setFeatureToggle('enable_notifications', value),
          ),
          SwitchListTile.adaptive(
            title: Text(strings.t('enable_biometrics')),
            subtitle: Text(strings.t('enable_biometrics_hint')),
            value: settings.featureEnabled('enable_biometrics'),
            onChanged: (value) => settings.setFeatureToggle('enable_biometrics', value),
          ),
          SwitchListTile.adaptive(
            title: Text(strings.t('auto_play_tours')),
            subtitle: Text(strings.t('auto_play_tours_hint')),
            value: settings.featureEnabled('auto_play_tours'),
            onChanged: (value) => settings.setFeatureToggle('auto_play_tours', value),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () async {
              await settings.clear();
              await NotifierProvider.read<FavoritesController>(context).clear();
              NotifierProvider.read<FiltersController>(context).reset();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.t('clear_success'))),
                );
              }
            },
            child: Text(strings.t('clear_local')),
          ),
        ],
      ),
    );
  }
}
