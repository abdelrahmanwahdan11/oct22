import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/utils/animations.dart';
import '../../data/models/property.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, this.index = 0});

  final Property property;
  final int index;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final controller = NotifierProvider.of<PropertiesController>(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        'property.details',
        arguments: property.id,
      ),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(16, 24, 40, 0.08),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'property_image_${property.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      child: Image.network(
                        property.images.first,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () async {
                        await controller.toggleFavorite(property);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FaIcon(
                          property.favorite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          size: 16,
                          color: property.favorite ? Colors.redAccent : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.locationDot, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${property.city} · ${property.address}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IconStat(
                        icon: FontAwesomeIcons.bed,
                        label: '${property.beds}',
                      ),
                      _IconStat(
                        icon: FontAwesomeIcons.bath,
                        label: '${property.baths}',
                      ),
                      _IconStat(
                        icon: FontAwesomeIcons.rulerCombined,
                        label: '${property.areaM2} m²',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${property.currency} ${property.price}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          strings.t(property.status),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).listItem(index: index);
  }
}

class _IconStat extends StatelessWidget {
  const _IconStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 14, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
