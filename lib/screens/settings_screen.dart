import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';
import '../core/app_scope.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../repositories/settings_repository.dart';
import '../widgets/animated_entry.dart';
import '../widgets/decorated_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final authController = AppScope.of(context).authController;
    return DecoratedScaffold(
      appBar: AppBar(title: Text(strings.t('settings'))),
      body: AnimatedBuilder(
        animation: settingsController,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedEntry(
                    child: SwitchListTile(
                      title: Text(strings.t('dark_mode')),
                      value: settingsController.isDark,
                      onChanged: (value) => settingsController.toggleDarkMode(value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 120),
                    child: Text(strings.t('units'),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 160),
                    child: Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: _SegmentButton(
                            label: strings.t('imperial'),
                            selected: settingsController.unitSystem == UnitSystem.imperial,
                            onTap: () => settingsController.setUnitSystem(UnitSystem.imperial),
                          ),
                        ),
                        SizedBox(width: isWide ? 12 : 0, height: isWide ? 0 : 12),
                        Expanded(
                          child: _SegmentButton(
                            label: strings.t('metric'),
                            selected: settingsController.unitSystem == UnitSystem.metric,
                            onTap: () => settingsController.setUnitSystem(UnitSystem.metric),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 200),
                    child: Text(strings.t('locale'),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 240),
                    child: DropdownButtonFormField<Locale>(
                      value: settingsController.locale,
                      decoration: const InputDecoration(),
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
                  ),
                  const SizedBox(height: 32),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 280),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await authController.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppNavigation.routes['auth.login']!,
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(strings.t('logout')),
                    ),
                  ),
                ],
              );

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [content],
                  ),
                ),
              );
            },
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
            color: selected ? AppColors.limeSoft : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
            border: Border.all(
              color: selected
                  ? AppColors.limeDark.withOpacity(0.7)
                  : Theme.of(context).dividerColor.withOpacity(0.4),
            ),
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
