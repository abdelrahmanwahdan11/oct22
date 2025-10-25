import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../shared/tradex_bottom_nav.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = NotifierProvider.of<SettingsController>(context);
    final strings = AppLocalizations.of(context);
    final isDark = settings.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('account'))),
      bottomNavigationBar: const TradeXBottomNav(currentIndex: 4),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ahmad', style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('ahmad@example.com', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SwitchListTile.adaptive(
            value: isDark,
            title: Text(strings.t('dark_mode')),
            secondary: const FaIcon(FontAwesomeIcons.moon),
            onChanged: (value) => settings.toggleDarkMode(value),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.language),
            title: Text(strings.t('language')),
            trailing: Text(settings.locale.languageCode.toUpperCase()),
            onTap: () {
              final newLocale = settings.locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
              settings.setLocale(newLocale);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.gear),
            title: Text(strings.t('settings')),
            onTap: () => Navigator.of(context).pushNamed('settings'),
          ),
        ],
      ),
    );
  }
}
