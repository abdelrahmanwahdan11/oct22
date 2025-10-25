import 'package:flutter/material.dart';

import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watchController<SettingsController>();
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile(
            title: Text(strings.t('dark_mode')),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (value) => settings.toggleDarkMode(value),
          ),
          ListTile(
            title: Text(strings.t('language')),
            trailing: DropdownButton<Locale>(
              value: settings.locale,
              items: const [
                DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
              onChanged: (locale) {
                if (locale != null) settings.setLocale(locale);
              },
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () async {
              await settings.clearLocal();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(strings.t('clear_local_data'))));
            },
            child: Text(strings.t('clear_local_data')),
          ),
        ],
      ),
    );
  }
}
