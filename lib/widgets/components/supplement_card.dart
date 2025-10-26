import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../data/models/supplement.dart';

class SupplementCard extends StatelessWidget {
  const SupplementCard({
    super.key,
    required this.supplement,
    required this.onAdd,
  });

  final Supplement supplement;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.supplementDetails,
          arguments: {'id': supplement.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.86),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'supp_${supplement.id}',
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  supplement.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplement.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: supplement.tags
                        .take(3)
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.tonal(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.supplementDetails,
                            arguments: {'id': supplement.id},
                          );
                        },
                        child: Text(l10n.translate('learn_more')),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: onAdd,
                        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                        tooltip: l10n.translate('add_to_plan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(interval: 60.ms).fadeIn().scale(begin: 0.98, end: 1),
    );
  }
}
