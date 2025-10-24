import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/filters_controller.dart';
import '../../controllers/properties_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/filter_chips.dart';
import '../../widgets/components/property_card.dart';
import '../../widgets/components/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  PropertiesController? _controller;
  bool _isGrid = true;
  String _sort = 'Newest';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = NotifierProvider.of<PropertiesController>(context);
    if (_controller != controller) {
      _controller?.scrollController.removeListener(_onScroll);
      _controller = controller;
      controller.scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.scrollController.position.pixels >
        controller.scrollController.position.maxScrollExtent - 120) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _controller?.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final properties = NotifierProvider.of<PropertiesController>(context);
    final filters = NotifierProvider.of<FiltersController>(context);
    final sortLabels = {
      'Newest': strings.t('sort_newest'),
      'Price ↑': strings.t('sort_price_low'),
      'Price ↓': strings.t('sort_price_high'),
      'Area ↑': strings.t('sort_area_low'),
      'Area ↓': strings.t('sort_area_high'),
    };
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width >= 1000
        ? 60.0
        : width >= 700
            ? 32.0
            : 20.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('explore')),
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'explore'),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: RefreshIndicator(
          onRefresh: properties.refresh,
          child: CustomScrollView(
            controller: properties.scrollController,
            slivers: [
              SliverToBoxAdapter(child: SearchBarWidget()),
              SliverToBoxAdapter(child: FilterChipsRow()),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('filters.sheet'),
                            icon: const FaIcon(FontAwesomeIcons.sliders, size: 16),
                            label: Text(strings.t('advanced_filters')),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed('search'),
                            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                            label: Text(strings.t('open_search')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 180,
                        decoration:
                            AppDecorations.glassCard(dark: settings.isDarkMode),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                'https://maps.googleapis.com/maps/api/staticmap?center=Jerusalem&zoom=10&size=600x400&scale=2',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: FilledButton.tonal(
                                onPressed: () {},
                                child: Text(strings.t('view_map_placeholder')),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SegmentedButton<bool>(
                            segments: [
                              ButtonSegment(value: true, icon: const FaIcon(FontAwesomeIcons.tableCellsLarge, size: 16)),
                              ButtonSegment(value: false, icon: const FaIcon(FontAwesomeIcons.list, size: 16)),
                            ],
                            selected: {_isGrid},
                            onSelectionChanged: (values) =>
                                setState(() => _isGrid = values.first),
                          ),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: _sort,
                            items: [
                              'Newest',
                              'Price ↑',
                              'Price ↓',
                              'Area ↑',
                              'Area ↓',
                            ]
                                .map(
                                  (label) => DropdownMenuItem<String>(
                                    value: label,
                                    child: Text(sortLabels[label] ?? label),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _sort = value);
                              filters.update(filters.filters.copyWith(sort: value));
                              properties.refresh();
                            },
                          ),
                        ],
                      ),
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
                            for (final item in properties.recentSearches)
                              ActionChip(
                                label: Text(item),
                                onPressed: () {
                                  properties.setSearchQuery(item);
                                  properties.registerSearch(item);
                                },
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_isGrid)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= properties.feed.length) {
                          return properties.loadingMore
                              ? const Center(child: CircularProgressIndicator())
                              : const SizedBox.shrink();
                        }
                        final property = properties.feed[index];
                        return PropertyCard(property: property, index: index);
                      },
                      childCount: properties.feed.length + (properties.loadingMore ? 1 : 0),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width >= 1100 ? 3 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.74,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= properties.feed.length) {
                        return properties.loadingMore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      final property = properties.feed[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                        child: PropertyCard(property: property, index: index),
                      );
                    },
                    childCount: properties.feed.length + 1,
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 32),
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('compare'),
                    icon: const FaIcon(FontAwesomeIcons.scaleBalanced, size: 16),
                    label: Text(strings.t('open_compare')),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
