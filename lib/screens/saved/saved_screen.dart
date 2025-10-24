import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/property_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final favorites = NotifierProvider.of<FavoritesController>(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final items = favorites.favoritesList();
    final totalValue = items.fold<num>(0, (previousValue, element) => previousValue + element.price);
    final types = items.map((e) => e.type).toSet().toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('saved')),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 18),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(strings.t('share_saved_message'))),
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trashCan, size: 18),
            onPressed: () async {
              await favorites.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.t('cleared_saved'))),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'saved'),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: items.isEmpty
            ? Center(
                child: Text(strings.t('empty_saved')),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration:
                            AppDecorations.glassCard(dark: settings.isDarkMode),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(strings.t('saved_summary'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              '${strings.t('saved_count_label')} ${items.length} · ${totalValue.toStringAsFixed(0)} ${strings.t('currency_short')}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                for (final type in types)
                                  Chip(label: Text(strings.t(type))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () => Navigator.of(context).pushNamed('compare'),
                              icon: const FaIcon(FontAwesomeIcons.scaleBalanced, size: 16),
                              label: Text(strings.t('open_compare')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => PropertyCard(
                          property: items[index],
                          index: index,
                        ),
                        childCount: items.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
      ),
    );
  }
}
