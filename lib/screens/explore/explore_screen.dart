import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/filters_controller.dart';
import '../../controllers/properties_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/app_content.dart';
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
  late final ScrollController _scrollController;
  bool _isGrid = true;
  String _sort = 'Newest';
  bool _filtersHydrated = false;
  String? _statusFilter;
  final Set<String> _typeFilters = {};
  double _maxPrice = 1000000;
  String? _cityFilter;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final properties = NotifierProvider.read<PropertiesController>(context);
        if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 120) {
          properties.loadMore();
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final properties = NotifierProvider.read<PropertiesController>(context);
      properties.ensureLoaded();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_filtersHydrated) return;
    final filters = NotifierProvider.of<FiltersController>(context);
    final current = filters.filters;
    _statusFilter = current.status;
    _typeFilters
      ..clear()
      ..addAll(current.types);
    _maxPrice = (current.maxPrice ?? 1000000).toDouble();
    _cityFilter = current.city;
    _filtersHydrated = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _commitFilters(FiltersController filtersController) {
    final current = filtersController.filters;
    filtersController.update(current.copyWith(
      status: _statusFilter,
      types: _typeFilters.toList(),
      maxPrice: _maxPrice.toInt(),
      city: _cityFilter,
    ));
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
    final languageCode = strings.languageCode;
    final exploreItems =
        properties.explore.isNotEmpty ? properties.explore : properties.feed;
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
            controller: _scrollController,
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
                      const SizedBox(height: 16),
                      Text(strings.t('quick_status_filters'),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final status in ['for_sale', 'for_rent'])
                            ChoiceChip(
                              label: Text(strings.t(status)),
                              selected: _statusFilter == status,
                              onSelected: (selected) {
                                setState(() {
                                  _statusFilter = selected ? status : null;
                                });
                                _commitFilters(filters);
                                properties.refresh();
                              },
                            ),
                          ChoiceChip(
                            label: Text(strings.t('clear_filters')),
                            selected: _statusFilter == null && _typeFilters.isEmpty,
                            onSelected: (_) {
                              setState(() {
                                _statusFilter = null;
                                _typeFilters.clear();
                                _cityFilter = null;
                                _maxPrice = 1000000;
                              });
                              filters.reset();
                              properties.refresh();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(strings.t('property_types'),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final type in ['apartments', 'villas', 'cabins', 'commercial'])
                            FilterChip(
                              label: Text(strings.t(type)),
                              selected: _typeFilters.contains(type),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _typeFilters.add(type);
                                  } else {
                                    _typeFilters.remove(type);
                                  }
                                });
                                _commitFilters(filters);
                                properties.refresh();
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(strings.t('max_price_label'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Slider(
                        value: _maxPrice,
                        min: 50000,
                        max: 1500000,
                        divisions: 29,
                        label: _maxPrice.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(() => _maxPrice = value);
                        },
                        onChangeEnd: (_) {
                          _commitFilters(filters);
                          properties.refresh();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${strings.t('currency_short')} ${_maxPrice.toStringAsFixed(0)}'),
                          Text(strings.t('price_hint')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: strings.t('city_filter_label')),
                        value: _cityFilter,
                        items: const ['Rawabi', 'Jericho', 'Bethlehem', 'Gaza']
                            .map(
                              (city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _cityFilter = value);
                          _commitFilters(filters);
                          properties.refresh();
                        },
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                          filters.saveCurrent();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.t('search_saved'))),
                          );
                        },
                        icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
                        label: Text(strings.t('save_search')),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 8),
                  child: Text(strings.t('heatmap_insights'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final zone in AppContent.marketHeatmap)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.chartLine, size: 16),
                          title: Text(AppContent.localizedText(
                              (zone['title'] as Map<String, String>), languageCode)),
                          trailing: Text('${zone['trend']}%'),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
                  child: Text(strings.t('subscribe_alerts'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final alert in AppContent.exploreAlerts)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.bell, size: 16),
                          title: Text(AppContent.localizedText(
                              (alert['title'] as Map<String, String>), languageCode)),
                          subtitle: Text(AppContent.localizedText(
                              (alert['body'] as Map<String, String>), languageCode)),
                          trailing: FilledButton.tonal(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(strings.t('alert_subscribed'))),
                            ),
                            child: Text(strings.t('subscribe')),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
                  child: Text(strings.t('commute_profiles'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final profile in AppContent.commuteProfiles)
                        Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: AppDecorations.sectionSurface(dark: settings.isDarkMode),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppContent.localizedText(
                                  (profile['title'] as Map<String, String>), languageCode),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text(AppContent.localizedText(
                                  (profile['body'] as Map<String, String>), languageCode)),
                            ],
                          ),
                        ),
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
                        if (index >= exploreItems.length) {
                          return properties.loadingMore
                              ? const Center(child: CircularProgressIndicator())
                              : const SizedBox.shrink();
                        }
                        final property = exploreItems[index];
                        return PropertyCard(property: property, index: index);
                      },
                      childCount: exploreItems.length + (properties.loadingMore ? 1 : 0),
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
                      if (index >= exploreItems.length) {
                        return properties.loadingMore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      final property = exploreItems[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                        child: PropertyCard(property: property, index: index),
                      );
                    },
                    childCount: exploreItems.length + 1,
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
