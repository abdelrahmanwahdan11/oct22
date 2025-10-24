import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/app_bottom_navigation.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final auth = NotifierProvider.of<AuthController>(context);
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('account')),
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'account'),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(
                    user?.avatar ?? 'https://i.pravatar.cc/150?img=12',
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Ahmad',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(user?.email ?? 'ahmad@example.com'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clock, size: 18),
              title: Text(strings.t('recent')),
              onTap: () {},
            ),
            SwitchListTile.adaptive(
              secondary: const FaIcon(FontAwesomeIcons.moon, size: 18),
              title: Text(strings.t('dark_mode')),
              value: settings.isDarkMode,
              onChanged: (value) => settings.toggleDarkMode(value),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.language, size: 18),
              title: Text(strings.t('language')),
              onTap: () => _selectLocale(context, settings),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.gear, size: 18),
              title: Text(strings.t('settings')),
              onTap: () => Navigator.of(context).pushNamed('settings'),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 18),
              title: Text(strings.t('logout')),
              onTap: () {
                auth.logout();
                Navigator.of(context).pushReplacementNamed('auth.login');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectLocale(BuildContext context, SettingsController settings) {
    final strings = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLocalizations.supportedLocales
              .map(
                (locale) => ListTile(
                  title: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
                  onTap: () {
                    settings.setLocale(locale);
                    Navigator.of(context).pop();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
