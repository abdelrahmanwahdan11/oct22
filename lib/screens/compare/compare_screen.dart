import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/properties_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/property.dart';
import '../../widgets/components/property_card.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final Set<String> _selected = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selected.isEmpty) {
      final favorites = NotifierProvider.of<FavoritesController>(context);
      final initial = favorites.favoritesList().take(3);
      _selected.addAll(initial.map((e) => e.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final favorites = NotifierProvider.of<FavoritesController>(context);
    final propertiesController = NotifierProvider.of<PropertiesController>(context);
    final allFavorites = favorites.favoritesList();
    final selectedProperties = _selected
        .map(propertiesController.findById)
        .whereType<Property>()
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('compare')),
      ),
      body: Container(
        decoration: AppDecorations.gradientBackground(
            dark: Theme.of(context).brightness == Brightness.dark),
        child: allFavorites.isEmpty
            ? Center(child: Text(strings.t('empty_saved')))
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  Text(strings.t('select_for_compare'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final property in allFavorites)
                        FilterChip(
                          avatar: CircleAvatar(
                            backgroundImage: NetworkImage(property.images.first),
                          ),
                          label: Text(property.title),
                          selected: _selected.contains(property.id),
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                if (_selected.length < 3) {
                                  _selected.add(property.id);
                                }
                              } else {
                                _selected.remove(property.id);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (selectedProperties.length < 2)
                    Text(strings.t('compare_hint'),
                        style: Theme.of(context).textTheme.bodyMedium)
                  else ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(strings.t('attribute'))),
                          for (final property in selectedProperties)
                            DataColumn(label: SizedBox(width: 160, child: Text(property.title))),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(strings.t('price'))),
                              for (final property in selectedProperties)
                                DataCell(Text('${property.currency} ${property.price}')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(strings.t('area'))),
                              for (final property in selectedProperties)
                                DataCell(Text('${property.areaM2} m²')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(strings.t('beds'))),
                              for (final property in selectedProperties)
                                DataCell(Text('${property.beds}')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(strings.t('baths'))),
                              for (final property in selectedProperties)
                                DataCell(Text('${property.baths}')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(strings.t('status'))),
                              for (final property in selectedProperties)
                                DataCell(Text(strings.t(property.status))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(strings.t('feature_overlap'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final feature in _sharedFeatures(selectedProperties))
                          Chip(label: Text(feature)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(strings.t('compare_gallery'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => SizedBox(
                          width: 240,
                          child: PropertyCard(
                            property: selectedProperties[index],
                            index: index,
                          ),
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemCount: selectedProperties.length,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed('property.submit'),
                      icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 16),
                      label: Text(strings.t('add_custom_property')),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Set<String> _sharedFeatures(List<Property> items) {
    if (items.isEmpty) return {};
    final sets = items.map((e) => e.features.toSet()).toList();
    final result = sets.first.toSet();
    for (final set in sets.skip(1)) {
      result.retainAll(set);
    }
    return result;
  }
}
