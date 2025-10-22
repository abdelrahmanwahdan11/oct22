import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/core/feature_catalog.dart';
import 'package:smart_home_control/core/responsive.dart';

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
        final features = enhancementCatalog;
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.t('more_title')),
          ),
          body: ResponsiveConstrainedBox(
            builder: (context, constraints) {
              final padding = AppBreakpoints.geometry(constraints.maxWidth);
              final activeOptions = features
                  .where((option) => settings.isEnhancementEnabled(option.id))
                  .toList();
              return ListView(
                padding: padding,
                children: [
                  _ProfileCard(name: auth.displayName, email: auth.email),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => _openGuidedSetup(context, loc),
                    icon: const Icon(Icons.school_outlined),
                    label: Text(loc.t('view_guided_setup')),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.t('view_guided_setup_subtitle'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                  _SectionTitle(title: loc.t('active_features')),
                  if (activeOptions.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final option in activeOptions)
                          Chip(
                            avatar: Icon(option.icon, size: 16),
                            label: Text(loc.t(option.chipKey)),
                          ),
                      ],
                    )
                  else
                    Text(
                      loc.t('no_active_features'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: loc.t('enhancements_title')),
                  Text(
                    loc.t('enhancements_description'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  for (final option in features) ...[
                    _FeatureToggleTile(
                      option: option,
                      enabled: settings.isEnhancementEnabled(option.id),
                      loc: loc,
                      onChanged: (value) => settings.toggleEnhancement(option.id, value),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openGuidedSetup(BuildContext context, AppLocalizations loc) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        final slides = [
          _GuidedTip(
            icon: Icons.dashboard_customize,
            title: loc.t('onboarding_title_1'),
            subtitle: loc.t('onboarding_desc_1'),
          ),
          _GuidedTip(
            icon: Icons.videocam_outlined,
            title: loc.t('onboarding_title_2'),
            subtitle: loc.t('onboarding_desc_2'),
          ),
          _GuidedTip(
            icon: Icons.ac_unit,
            title: loc.t('onboarding_title_3'),
            subtitle: loc.t('onboarding_desc_3'),
          ),
        ];
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.t('guided_setup_title'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                loc.t('guided_setup_message'),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              for (final slide in slides) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(slide.icon, color: theme.colorScheme.primary),
                  title: Text(slide.title),
                  subtitle: Text(slide.subtitle),
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(loc.t('cancel')),
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
    final cardColor = theme.colorScheme.surface;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: theme.brightness == Brightness.light ? AppShadows.soft : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _FeatureToggleTile extends StatelessWidget {
  const _FeatureToggleTile({
    required this.option,
    required this.enabled,
    required this.onChanged,
    required this.loc,
  });

  final EnhancementOption option;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: theme.brightness == Brightness.light ? AppShadows.soft : null,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(enabled ? 0.18 : 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(option.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.t(option.titleKey),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  loc.t(option.subtitleKey),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                    child: Text(
                      loc.t(option.chipKey),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _GuidedTip {
  const _GuidedTip({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}
