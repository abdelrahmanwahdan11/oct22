import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/app_content.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/property_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.t('saved_collections'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final entry in AppContent.savedCollections)
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(12),
                                  decoration:
                                      AppDecorations.glassCard(dark: settings.isDarkMode),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppContent.localizedText(
                                            (entry['title'] as Map<String, String>),
                                            strings.languageCode),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        AppContent.localizedText(
                                            (entry['body'] as Map<String, String>),
                                            strings.languageCode),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          for (final contact in AppContent.advisorContacts)
                            ListTile(
                              leading: const FaIcon(FontAwesomeIcons.userTie, size: 16),
                              title: Text(AppContent.localizedText(
                                  (contact['title'] as Map<String, String>),
                                  strings.languageCode)),
                              subtitle: Text(contact['phone'] as String),
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(strings.t('advisor_contacted'))),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final property = items[index];
                          final note = favorites.noteFor(property.id);
                          final hasAlert = favorites.hasAlert(property.id);
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: PropertyCard(
                                  property: property,
                                  index: index,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const FaIcon(FontAwesomeIcons.noteSticky, size: 16),
                                      onPressed: () => _editNote(context, favorites, property.id, note),
                                      tooltip: strings.t('add_note'),
                                    ),
                                    IconButton(
                                      icon: FaIcon(
                                        hasAlert
                                            ? FontAwesomeIcons.bell
                                            : FontAwesomeIcons.bellSlash,
                                        size: 16,
                                      ),
                                      onPressed: () async {
                                        await favorites.toggleAlert(property.id);
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(strings.t('alert_toggle_success'))),
                                        );
                                      },
                                      tooltip: strings.t('price_drop_alert'),
                                    ),
                                  ],
                                ),
                              ),
                              if (note.isNotEmpty)
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                                    child: Text(note,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.labelMedium),
                                  ),
                                ),
                            ],
                          );
                        },
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

  Future<void> _editNote(BuildContext context, FavoritesController favorites, String id, String initial) async {
    final strings = AppLocalizations.of(context);
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.t('add_note')),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: strings.t('note_hint')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(strings.t('cancel'))),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(strings.t('save')),
          ),
        ],
      ),
    );
    if (result == null) return;
    await favorites.updateNote(id, result.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.t('note_saved'))),
    );
  }
}
