import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = AppScope.of(context).settingsController;
    final user = AppScope.of(context).userRepository.currentUser;
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).canvasColor, Theme.of(context).scaffoldBackgroundColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 4),
                          Text(user.goals.join(' • ')),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0),
                  const SizedBox(height: 24),
                  Text(l10n.translate('settings'),
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    secondary: const FaIcon(FontAwesomeIcons.moon),
                    title: Text(l10n.translate('dark_mode')),
                    value: settingsController.themeMode == ThemeMode.dark,
                    onChanged: (_) => settingsController.toggleTheme(),
                  ),
                  SwitchListTile.adaptive(
                    secondary: const FaIcon(FontAwesomeIcons.bell),
                    title: Text(l10n.translate('notifications')),
                    value: settingsController.remindersEnabled,
                    onChanged: settingsController.setRemindersEnabled,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.translate('language'),
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: AppLocalizations.supportedLocales
                        .map(
                          (locale) => ChoiceChip(
                            label: Text(locale.languageCode.toUpperCase()),
                            selected: settingsController.locale == locale,
                            onSelected: (_) => settingsController.changeLocale(locale),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
