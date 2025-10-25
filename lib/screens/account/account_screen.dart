import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';
import '../shared/tradex_bottom_nav.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watchController<SettingsController>();
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
          SwitchListTile.adaptive(
            value: settings.proMode,
            title: Text(strings.t('pro_mode_workspace')),
            secondary: const FaIcon(FontAwesomeIcons.userTie),
            onChanged: (value) => settings.setProMode(value),
          ),
          SwitchListTile.adaptive(
            value: settings.biometricEnabled,
            title: Text(strings.t('biometric_lock')),
            subtitle: Text(strings.t('biometric_lock_sub')),
            secondary: const FaIcon(FontAwesomeIcons.fingerprint),
            onChanged: (value) => settings.setBiometric(value),
          ),
          SwitchListTile.adaptive(
            value: settings.highContrast,
            title: Text(strings.t('high_contrast_charts')),
            secondary: const FaIcon(FontAwesomeIcons.eye),
            onChanged: (value) => settings.setHighContrast(value),
          ),
          SwitchListTile.adaptive(
            value: settings.autoRefreshPortfolio,
            title: Text(strings.t('auto_refresh_portfolio')),
            subtitle: Text(strings.t('auto_refresh_portfolio_sub')),
            secondary: const FaIcon(FontAwesomeIcons.rotate),
            onChanged: (value) => settings.setAutoRefresh(value),
          ),
          const Divider(height: 32),
          DropdownButtonFormField<String>(
            value: settings.defaultCurrency,
            decoration: InputDecoration(
              labelText: strings.t('primary_currency'),
              prefixIcon: const FaIcon(FontAwesomeIcons.coins, size: 18),
            ),
            items: const ['USD', 'EUR', 'AED', 'SAR', 'GBP']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                settings.setDefaultCurrency(value);
              }
            },
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
