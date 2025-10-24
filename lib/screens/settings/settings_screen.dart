import 'package:flutter/material.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/filters_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile.adaptive(
            title: Text(strings.t('dark_mode')),
            value: settings.isDarkMode,
            onChanged: (value) => settings.toggleDarkMode(value),
          ),
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
