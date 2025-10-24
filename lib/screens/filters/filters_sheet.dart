import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/filters_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../data/models/filters.dart';

class FiltersSheet extends StatefulWidget {
  const FiltersSheet({super.key});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late Filters _filters;
  late TextEditingController _cityController;
  RangeValues _price = const RangeValues(0, 2000000);
  RangeValues _area = const RangeValues(20, 1000);

  @override
  void initState() {
    super.initState();
    final controller = NotifierProvider.read<FiltersController>(context);
    _filters = controller.filters;
    _cityController = TextEditingController(text: _filters.city ?? '');
    _price = RangeValues(
      (_filters.minPrice ?? 0).toDouble(),
      (_filters.maxPrice ?? 2000000).toDouble(),
    );
    _area = RangeValues(
      (_filters.minArea ?? 20).toDouble(),
      (_filters.maxArea ?? 1000).toDouble(),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final controller = NotifierProvider.of<FiltersController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('filters')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ToggleButtons(
            isSelected: [
              _filters.status == 'for_sale',
              _filters.status == 'for_rent',
            ],
            onPressed: (index) {
              setState(() {
                _filters = _filters.copyWith(
                  status: index == 0 ? 'for_sale' : 'for_rent',
                );
              });
            },
            borderRadius: BorderRadius.circular(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(strings.t('for_sale')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(strings.t('for_rent')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: ['apartments', 'villas', 'cabins', 'commercial']
                .map(
                  (type) => FilterChip(
                    label: Text(strings.t(type)),
                    selected: _filters.types.contains(type),
                    onSelected: (value) {
                      setState(() {
                        final types = List<String>.from(_filters.types);
                        if (value) {
                          types.add(type);
                        } else {
                          types.remove(type);
                        }
                        _filters = _filters.copyWith(types: types);
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text('${strings.t('price')}: ${_price.start.toInt()} - ${_price.end.toInt()}'),
          RangeSlider(
            values: _price,
            min: 0,
            max: 2000000,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _price = value;
                _filters = _filters.copyWith(
                  minPrice: value.start.toInt(),
                  maxPrice: value.end.toInt(),
                );
              });
            },
          ),
          const SizedBox(height: 16),
          Text('${strings.t('area_m2')}: ${_area.start.toInt()} - ${_area.end.toInt()}'),
          RangeSlider(
            values: _area,
            min: 20,
            max: 1000,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _area = value;
                _filters = _filters.copyWith(
                  minArea: value.start.toInt(),
                  maxArea: value.end.toInt(),
                );
              });
            },
          ),
          const SizedBox(height: 16),
          _counterRow(
            context,
            icon: FontAwesomeIcons.bed,
            label: strings.t('beds_count'),
            value: _filters.minBeds ?? 0,
            onChanged: (value) => setState(() {
              _filters = _filters.copyWith(minBeds: value < 0 ? 0 : value);
            }),
          ),
          _counterRow(
            context,
            icon: FontAwesomeIcons.bath,
            label: strings.t('baths_count'),
            value: _filters.minBaths ?? 0,
            onChanged: (value) => setState(() {
              _filters = _filters.copyWith(minBaths: value < 0 ? 0 : value);
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(labelText: strings.t('city')),
            onChanged: (value) => _filters = _filters.copyWith(city: value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _filters.sort,
            decoration: InputDecoration(labelText: strings.t('sort')),
            items: ['newest', 'price_low', 'price_high', 'area_low', 'area_high']
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(strings.t(value)),
                  ),
                )
                .toList(),
            onChanged: (value) => _filters = _filters.copyWith(sort: value),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    controller.update(_filters);
                    Navigator.of(context).pop();
                  },
                  child: Text(strings.t('apply')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    controller.update(_filters);
                    await controller.saveCurrent();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('saved_filter_toast'))),
                    );
                  },
                  child: Text(strings.t('save_filter')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        FaIcon(icon, size: 16),
        const SizedBox(width: 12),
        Text('$label: $value'),
        const Spacer(),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.minus),
          onPressed: () => onChanged(value - 1),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.plus),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}
