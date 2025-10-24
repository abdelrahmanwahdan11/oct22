import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/utils/animations.dart';
import '../../data/models/property.dart';
import '../../widgets/components/bottom_action_bar.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final controller = NotifierProvider.of<PropertiesController>(context);
    final Property? property = controller.findById(propertyId);
    if (property == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(strings.t('no_results'))),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 18),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(
              property.favorite
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              size: 18,
            ),
            onPressed: () => controller.toggleFavorite(property),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Hero(
            tag: 'property_image_${property.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Image.network(
                property.images.first,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ).fadeMove(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ).fadeMove(),
                const SizedBox(height: 8),
                Text('${property.currency} ${property.price}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700))
                    .fadeMove(delay: 60),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _InfoPill(icon: FontAwesomeIcons.bed, label: '${property.beds}'),
                    _InfoPill(icon: FontAwesomeIcons.bath, label: '${property.baths}'),
                    _InfoPill(icon: FontAwesomeIcons.rulerCombined, label: '${property.areaM2} m²'),
                    _InfoPill(icon: FontAwesomeIcons.locationDot, label: property.city),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: property.features
                      .map((feature) => Chip(label: Text(feature)))
                      .toList(),
                ).fadeMove(delay: 120),
                const SizedBox(height: 16),
                Text(
                  strings.t('description'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ).fadeMove(delay: 160),
                const SizedBox(height: 8),
                Text(
                  property.description ?? strings.t('no_results'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ).fadeMove(delay: 200),
                const SizedBox(height: 24),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.mapLocationDot, size: 24),
                        const SizedBox(height: 8),
                        Text('${property.lat}, ${property.lng}')
                      ],
                    ),
                  ),
                ).fadeMove(delay: 240),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        onBook: () => Navigator.of(context)
            .pushNamed('booking.sheet', arguments: property.id),
        onContact: () => Navigator.of(context)
            .pushNamed('booking.sheet', arguments: property.id),
        onWhatsApp: () {},
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    ).fadeMove();
  }
}
