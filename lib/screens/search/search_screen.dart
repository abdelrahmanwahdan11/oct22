import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';
import '../../data/mock/app_content.dart';
import '../../widgets/components/property_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  String _status = 'all';

  @override
  void initState() {
    super.initState();
    final properties = NotifierProvider.read<PropertiesController>(context);
    _controller = TextEditingController(text: properties.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final properties = NotifierProvider.of<PropertiesController>(context);
    final results = properties.feed;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('open_search')),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.microphoneLines, size: 18),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(strings.t('voice_search_placeholder'))),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: strings.t('search_hint'),
                prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                suffixIcon: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.circleXmark, size: 16),
                  onPressed: () {
                    _controller.clear();
                    properties.setSearchQuery('', immediate: true);
                  },
                ),
              ),
              onChanged: properties.setSearchQuery,
              onSubmitted: (value) =>
                  properties.setSearchQuery(value, immediate: true),
            ).fadeMove(),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'all', label: Text(strings.t('all'))),
                ButtonSegment(value: 'for_sale', label: Text(strings.t('for_sale'))),
                ButtonSegment(value: 'for_rent', label: Text(strings.t('for_rent'))),
              ],
              selected: {_status},
              onSelectionChanged: (values) {
                setState(() => _status = values.first);
                final query = values.first == 'all' ? null : values.first;
                properties.setSearchQuery(_controller.text, immediate: true);
                if (query != null) {
                  properties.registerSearch('${_controller.text} $query');
                }
              },
            ).fadeMove(delay: 60),
            const SizedBox(height: 16),
            Text(strings.t('trending_searches'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final query in AppContent.trendingSearches)
                  ActionChip(
                    label: Text(query),
                    onPressed: () {
                      _controller.text = query;
                      properties.setSearchQuery(query, immediate: true);
                    },
                  ),
              ],
            ).fadeMove(delay: 80),
            if (properties.recentSearches.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(strings.t('recent_searches'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final recent in properties.recentSearches)
                    InputChip(
                      label: Text(recent),
                      onPressed: () {
                        _controller.text = recent;
                        properties.setSearchQuery(recent, immediate: true);
                      },
                    ),
                ],
              ).fadeMove(delay: 100),
            ],
            const SizedBox(height: 24),
            Text(strings.t('search_results'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text(strings.t('no_results'))),
              )
            else
              ...List.generate(
                results.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PropertyCard(property: results[index], index: index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
