import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final settings = scope.settings;
    final auth = scope.auth;
    final listenable = Listenable.merge([settings, auth]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final loc = auth.localization;
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.t('more_title')),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _ProfileCard(name: auth.displayName, email: auth.email),
              const SizedBox(height: 24),
              _SectionTitle(title: loc.t('language')),
              _SettingTile(
                icon: Icons.language,
                title: loc.t('choose_language'),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: auth.localization.locale,
                    onChanged: (value) {
                      if (value != null) {
                        settings.changeLocale(value);
                      }
                    },
                    items: AppLocalizations.supportedLocales
                        .map(
                          (locale) => DropdownMenuItem(
                            value: locale,
                            child: Text(locale.languageCode.toUpperCase()),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _SectionTitle(title: loc.t('theme')),
              _SettingTile(
                icon: Icons.dark_mode_outlined,
                title: loc.t('theme'),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        settings.updateThemeMode(value);
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(loc.t('theme_system')),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(loc.t('theme_light')),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(loc.t('theme_dark')),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: loc.t('user_access')),
              _SettingTile(
                icon: Icons.shield_person,
                title: loc.t('user_access'),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.userAccess),
                trailing: const Icon(Icons.chevron_right),
              ),
              const SizedBox(height: 16),
              _SettingTile(
                icon: Icons.analytics_outlined,
                title: loc.t('energy_analysis'),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.monthlyAnalysis),
                trailing: const Icon(Icons.chevron_right),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showSignOutDialog(context, auth),
                icon: const Icon(Icons.logout),
                label: Text(loc.t('logout')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, AuthController auth) async {
    final loc = auth.localization;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.t('logout')),
          content: Text(loc.t('sign_out_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.t('cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.t('logout')),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await auth.signOut();
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.name, this.email});

  final String name;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: theme.brightness == Brightness.light ? AppShadows.soft : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Text(
              name.isNotEmpty ? name.characters.first.toUpperCase() : '?',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    email!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: theme.brightness == Brightness.light ? AppShadows.soft : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
