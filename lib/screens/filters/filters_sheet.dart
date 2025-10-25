import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class FiltersSheet extends StatefulWidget {
  const FiltersSheet({super.key});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  String _assetType = 'Stocks';
  RangeValues _priceRange = const RangeValues(0, 5000);
  String _sort = 'Top Gainers';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('filters'), style: Theme.of(context).textTheme.h2),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: ['Stocks', 'Crypto', 'Commodities'].map((type) {
                    final selected = _assetType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      onSelected: (_) => setState(() => _assetType = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Text('Price'),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 5000,
                  divisions: 20,
                  labels: RangeLabels(_priceRange.start.toStringAsFixed(0), _priceRange.end.toStringAsFixed(0)),
                  onChanged: (values) => setState(() => _priceRange = values),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _sort,
                  decoration: const InputDecoration(labelText: 'Sort'),
                  items: const [
                    DropdownMenuItem(value: 'Top Gainers', child: Text('Top Gainers')),
                    DropdownMenuItem(value: 'Top Losers', child: Text('Top Losers')),
                    DropdownMenuItem(value: 'Most Active', child: Text('Most Active')),
                    DropdownMenuItem(value: 'Market Cap', child: Text('Market Cap')),
                  ],
                  onChanged: (value) => setState(() => _sort = value ?? _sort),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop({
                            'assetType': _assetType,
                            'price': _priceRange,
                            'sort': _sort,
                          });
                        },
                        child: Text(strings.t('apply')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(strings.t('saved'))));
                        },
                        child: Text(strings.t('save')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
