import 'package:flutter/material.dart';

import '../../controllers/filters_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/utils/animations.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key});

  static const _items = [
    _FilterItem('for_sale', type: _FilterType.status, value: 'for_sale'),
    _FilterItem('for_rent', type: _FilterType.status, value: 'for_rent'),
    _FilterItem('apartments', type: _FilterType.type, value: 'apartments'),
    _FilterItem('villas', type: _FilterType.type, value: 'villas'),
    _FilterItem('cabins', type: _FilterType.type, value: 'cabins'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtersController = NotifierProvider.of<FiltersController>(context);
    final filters = filtersController.filters;
    final strings = AppLocalizations.of(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = _items[index];
          bool selected = false;
          if (item.type == _FilterType.status) {
            selected = filters.status == item.value;
          } else {
            selected = filters.types.contains(item.value);
          }
          return FilterChip(
            label: Text(strings.t(item.labelKey)),
            selected: selected,
            onSelected: (value) {
              if (item.type == _FilterType.status) {
                filtersController.update(
                  filters.copyWith(status: value ? item.value : null),
                );
              } else {
                final types = List<String>.from(filters.types);
                if (value) {
                  types.add(item.value);
                } else {
                  types.remove(item.value);
                }
                filtersController.update(filters.copyWith(types: types));
              }
            },
          ).fadeMove(delay: index * 40);
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: _items.length,
      ),
    );
  }
}

enum _FilterType { status, type }

class _FilterItem {
  const _FilterItem(this.labelKey, {required this.type, required this.value});

  final String labelKey;
  final _FilterType type;
  final String value;
}
